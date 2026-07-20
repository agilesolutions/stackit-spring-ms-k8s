package com.agilesolutions.vergunning.controller;

import com.agilesolutions.common.domain.ZaakStatus;
import com.agilesolutions.common.domain.ZaakType;
import com.agilesolutions.common.dto.VergunningRequest;
import com.agilesolutions.common.dto.VergunningResponse;
import com.agilesolutions.vergunning.config.AbstractIntegrationTest;
import com.agilesolutions.vergunning.security.JwtTokenProvider;
import com.agilesolutions.vergunning.service.VergunningService;
import dasniko.testcontainers.keycloak.KeycloakContainer;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import tools.jackson.databind.ObjectMapper;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.boot.test.context.SpringBootTest.WebEnvironment.RANDOM_PORT;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(webEnvironment = RANDOM_PORT)
@AutoConfigureMockMvc
class VergunningControllerIT extends AbstractIntegrationTest {


    @Autowired
    MockMvc mvc;

    @Autowired
    KeycloakContainer keycloak;

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private VergunningService vergunningService;

    private ObjectMapper objectMapper = new ObjectMapper();

    private VergunningRequest validRequest;

    private VergunningResponse validResponse;

    @BeforeEach
    void setUp() {

        validRequest = new VergunningRequest(
                "Robert Rong",
                ZaakType.BOUWVERGUNNING,
                "Aanvraag voor bouw van een nieuwe woning.",
                "Amsterdam"
        );

        validResponse = new VergunningResponse(
                UUID.fromString("1"),
                "Robert Rong",
                ZaakStatus.OPEN,
                LocalDateTime.now(),
                "Vergunning succesvol geregistreerd"
        );

    }

    @Test
    void aanvraag_ValidRequest_ReturnsCreated() throws Exception {

        JwtTokenProvider provider =
                new JwtTokenProvider(keycloak);

        String token = provider.getClientCredentialsToken(
                "vergunning-service",
                "test-secret");

        // Mock de service om een geldig antwoord te geven
        when(vergunningService.aanvragen(any(VergunningRequest.class)))
                .thenReturn(validResponse);

        // Voer de POST-aanvraag uit
        ResultActions resultActions = mockMvc.perform(post("/api/v1/vergunningen")
                        .header(HttpHeaders.AUTHORIZATION,
                                "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(validRequest)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.vergunningid").value(validResponse.vergunningId()))
                .andExpect(jsonPath("$.status").value(validResponse.status()));

    }

}