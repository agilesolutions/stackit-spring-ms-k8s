package com.agilesolutions.vergunning.security;

import dasniko.testcontainers.keycloak.KeycloakContainer;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestClient;

public class JwtTokenProvider {

    private final RestClient restClient;
    private final KeycloakContainer keycloak;

    public JwtTokenProvider(KeycloakContainer keycloak) {
        this.keycloak = keycloak;
        this.restClient = RestClient.builder().build();
    }

    public String getClientCredentialsToken(
            String clientId,
            String clientSecret) {

        String tokenEndpoint =
                keycloak.getAuthServerUrl()
                        + "/realms/overheid/protocol/openid-connect/token";

        TokenResponse response =
                restClient.post()
                        .uri(tokenEndpoint)
                        .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                        .body(
                                "grant_type=client_credentials"
                                        + "&client_id=" + clientId
                                        + "&client_secret=" + clientSecret
                        )
                        .retrieve()
                        .body(TokenResponse.class);

        return response.accessToken();
    }

    public record TokenResponse(
            String access_token,
            String expires_in,
            String token_type,
            String scope) {

        public String accessToken() {
            return access_token;
        }
    }

}