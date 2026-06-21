package com.agilesolutions.vergunning.config;

import com.agilesolutions.common.dto.ZaakRequest;
import com.agilesolutions.common.dto.ZaakResponse;
import com.agilesolutions.service_a.model.EntityInfo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.client.OAuth2AuthorizeRequest;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientManager;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;
import org.springframework.web.server.ResponseStatusException;

/**
 * HTTP Client for Service A to call Service B's internal API
 * 
 * Handles OAuth2 Client Credentials flow for service-to-service authentication
 * and retrieves entity information from Zaken service.
 *
 * Uses the modern RestClient API (Spring Boot 4.x) instead of legacy RestTemplate.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class ZakenRegistratieClient {

    @Value("${zakenregistratie.url:http://localhost:8081}")
    private String serviceBUrl;

    @Value("${zakenregistratie.timeout-ms:5000}")
    private long timeoutMs;

    @Value("${zakenregistratie.max-retries:3}")
    private int maxRetries;

    private final RestClient restClient;
    private final OAuth2AuthorizedClientManager authorizedClientManager;

    /**
     * Get entity information from Service B by entity name
     * 
     * @param zaakRequest
     * @return ZaakResponse containing the entity details
     * @throws RestClientException if the request fails
     */
    public ZaakResponse registreerZaak(ZaakRequest zaakRequest) {
        log.debug("Registreer Zaak voor vergunning met id: {}", zaakRequest.vergunningId());
        
        String url = String.format("%s/api/v1/zaken", serviceBUrl);
        
        return executeWithRetry(url, zaakRequest);
    }

    /**
     * Execute HTTP request with retry logic
     * 
     * @param url the target URL
     * @param zaakRequest the request payload
     * @return EntityInfo from Service B
     */
    private ZaakResponse executeWithRetry(String url, ZaakRequest zaakRequest) {
        RestClientException lastException = null;
        
        for (int attempt = 1; attempt <= maxRetries; attempt++) {
            try {
                log.debug("Attempt {}/{} to fetch from Service B: {}", attempt, maxRetries, url);
                
                String token = getOAuth2Token();

                ZaakResponse response = restClient.get()
                        .uri(url)
                        .header("Authorization", "Bearer " + token)
                        .header("Content-Type", "application/json")
                        .header("Accept", "application/json")
                        .header("User-Agent", "Service-A/1.0.0")
                        .retrieve()
                        .onStatus(status -> status.is5xxServerError(),
                            (request, response2) -> {
                                log.warn("Service B server error: {}", response2.getStatusCode());
                                throw HttpClientErrorException.create(
                                        response2.getStatusCode(),
                                        "Service B error",
                                        response2.getHeaders(),
                                        new byte[0],
                                        null);
                            })
                        .body(ZaakResponse.class);

                log.debug("Successfully stored vergunning met id : {}", zaakRequest.vergunningId());
                return response;

            } catch (HttpClientErrorException.NotFound e) {
                log.warn("Entity not found in Service B for: {}", zaakRequest.vergunningId());
                throw e;
            } catch (ResourceAccessException e) {
                // Handle timeout and connection errors
                log.warn("Attempt {}/{} - Timeout or connection error: {}", attempt, maxRetries, e.getMessage());
                lastException = e;
                
                if (attempt == maxRetries) {
                    log.error("Connection timeout to Service B after {} attempts", maxRetries);
                    throw new ResponseStatusException(
                            org.springframework.http.HttpStatus.GATEWAY_TIMEOUT,
                            "Service B is not responding. Please try again later."
                    );
                }
                
            } catch (RestClientException e) {
                log.warn("Attempt {}/{} failed to fetch from Service B: {}", attempt, maxRetries, e.getMessage());
                lastException = e;
                
                if (attempt < maxRetries) {
                    try {
                        // Exponential backoff: 100ms * 2^(attempt-1)
                        long backoffMs = 100L * (long) Math.pow(2, attempt - 1);
                        backoffMs = Math.min(backoffMs, 2000); // Cap at 2 seconds
                        log.debug("Waiting {} ms before retry", backoffMs);
                        Thread.sleep(backoffMs);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        log.error("Interrupted during retry backoff", ie);
                        throw new RuntimeException("Interrupted while retrying", ie);
                    }
                }
            }
        }
        
        log.error("Failed to fetch entity info for {} after {} attempts", zaakRequest.vergunningId(), maxRetries);
        throw new ResponseStatusException(
                org.springframework.http.HttpStatus.SERVICE_UNAVAILABLE,
                "Service B is unavailable. Please try again later."
        );
    }

    /**
     * Acquire OAuth2 token from Keycloak using Client Credentials flow
     * 
     * @return OAuth2 access token
     */
    private String getOAuth2Token() {
        try {
            OAuth2AuthorizeRequest authorizeRequest = OAuth2AuthorizeRequest
                    .withClientRegistrationId("keycloak")
                    .principal("service-a")
                    .build();
            
            var authorizedClient = authorizedClientManager.authorize(authorizeRequest);
            
            if (authorizedClient == null || authorizedClient.getAccessToken() == null) {
                throw new RuntimeException("Failed to obtain OAuth2 token");
            }
            
            String token = authorizedClient.getAccessToken().getTokenValue();
            log.debug("Successfully obtained OAuth2 token");
            return token;
            
        } catch (Exception e) {
            log.error("Failed to obtain OAuth2 token from Keycloak", e);
            throw new RuntimeException("Failed to obtain OAuth2 token", e);
        }
    }
}
