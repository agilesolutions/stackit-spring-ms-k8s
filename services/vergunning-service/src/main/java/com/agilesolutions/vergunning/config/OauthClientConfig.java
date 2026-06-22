package com.agilesolutions.vergunning.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.web.client.OAuth2ClientHttpRequestInterceptor;
import org.springframework.web.client.RestClient;
import org.springframework.web.service.invoker.HttpServiceProxyFactory;
import org.springframework.web.client.support.RestClientAdapter;

/**
 * With this configuration:
 * 1. Tokens are automatically attached to outgoing requests
 * 2. Expired tokens are auto-refreshed by Spring before the request is made
 * 3. No manual token handling in your business logic
 *
 */
@Configuration
public class OauthClientConfig {

    @Bean
    ZakenRegistratieClient zakenRegistratieClient(
            RestClient.Builder builder,
            OAuth2AuthorizedClientManager authorizedClientManager,
            @Value("${application.clients.zakenregistratie.url}")
            String baseUrl) {

        OAuth2ClientHttpRequestInterceptor requestInterceptor =
                new OAuth2ClientHttpRequestInterceptor(authorizedClientManager);

        // Set client registration ID resolver (defaults to "oauth2ClientContext")
        // Use "auth-server" to match your application.yml registration name
        requestInterceptor.setClientRegistrationIdResolver(request -> "vergunning-service");

        RestClient restClient = builder
                .baseUrl(baseUrl)
                .requestInterceptor(requestInterceptor )
                .build();

        HttpServiceProxyFactory factory =
                HttpServiceProxyFactory
                        .builderFor(RestClientAdapter.create(restClient))
                        .build();

        return factory.createClient(ZakenRegistratieClient.class);
    }

}