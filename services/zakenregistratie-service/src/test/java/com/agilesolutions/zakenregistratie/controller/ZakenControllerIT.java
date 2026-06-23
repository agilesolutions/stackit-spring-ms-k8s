package com.agilesolutions.zakenregistratie.controller;

import com.agilesolutions.zakenregistratie.config.AbstractIntegrationTest;
import com.agilesolutions.zakenregistratie.security.JwtTokenProvider;
import dasniko.testcontainers.keycloak.KeycloakContainer;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.boot.test.context.SpringBootTest.WebEnvironment.RANDOM_PORT;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(webEnvironment = RANDOM_PORT)
@AutoConfigureMockMvc
class ZakenControllerIT extends AbstractIntegrationTest {

    @Autowired
    MockMvc mvc;

    @Autowired
    KeycloakContainer keycloak;

    @Test
    void shouldCreateZaak() throws Exception {

        JwtTokenProvider provider =
                new JwtTokenProvider(keycloak);

        String token = provider.getClientCredentialsToken(
                "zaken-service",
                "test-secret");

        mvc.perform(post("/api/v1/zaken")
                        .header(HttpHeaders.AUTHORIZATION,
                                "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                        {
                          "vergunningId":"550e8400-e29b-41d4-a716-446655440000",
                          "zaakType":"OMGEVINGSVERGUNNING"
                        }
                        """))
                .andExpect(status().isCreated());

    }

}