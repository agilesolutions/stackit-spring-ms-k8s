package com.agilesolutions.vergunning.config;

import dasniko.testcontainers.keycloak.KeycloakContainer;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.junit.jupiter.Container;

@SpringBootTest
@Import(TestContainersConfiguration.class)
public abstract class AbstractIntegrationTest {

    @Container
    static KeycloakContainer keycloak =
            new KeycloakContainer()
                    .withRealmImportFile("keycloak/test-realm.json");

    @DynamicPropertySource
    static void properties(DynamicPropertyRegistry registry) {

        registry.add(
                "spring.security.oauth2.client.provider.keycloak.token-uri",

                () -> keycloak.getAuthServerUrl()
                        + "/realms/overheid/protocol/openid-connect/token"
        );

        registry.add(
                "spring.security.oauth2.resourceserver.jwt.issuer-uri",

                () -> keycloak.getAuthServerUrl()
                        + "/realms/overheid"
        );

    }

}
