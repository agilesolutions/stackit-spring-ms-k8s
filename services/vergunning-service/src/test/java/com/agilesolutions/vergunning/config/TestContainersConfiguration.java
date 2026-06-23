package com.agilesolutions.vergunning.config;

import dasniko.testcontainers.keycloak.KeycloakContainer;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;

@TestConfiguration
public class TestContainersConfiguration {

    @Bean
    KeycloakContainer keycloak() {

        return new KeycloakContainer("quay.io/keycloak/keycloak:26.1")
                .withRealmImportFile("keycloak/test-realm.json");
    }


}