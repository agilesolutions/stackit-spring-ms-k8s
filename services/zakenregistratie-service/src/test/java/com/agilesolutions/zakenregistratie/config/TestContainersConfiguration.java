package com.agilesolutions.zakenregistratie.config;

import dasniko.testcontainers.keycloak.KeycloakContainer;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.context.annotation.Bean;

import org.testcontainers.containers.PostgreSQLContainer;

@TestConfiguration
public class TestContainersConfiguration {

    @Bean
    @ServiceConnection
    PostgreSQLContainer<?> postgres() {

        return new PostgreSQLContainer<>("postgres:16-alpine");

    }

    @Bean
    KeycloakContainer keycloak() {

        return new KeycloakContainer("quay.io/keycloak/keycloak:26.1")
                .withRealmImportFile("keycloak/test-realm.json");
    }


}