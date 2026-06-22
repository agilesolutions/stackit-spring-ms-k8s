package com.agilesolutions.vergunning.controller;

import com.agilesolutions.common.domain.ZaakType;
import com.agilesolutions.common.dto.VergunningRequest;
import com.agilesolutions.common.dto.VergunningResponse;
import com.agilesolutions.vergunning.exception.GlobalExceptionHandler;
import com.agilesolutions.vergunning.service.VergunningService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import tools.jackson.databind.ObjectMapper;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(VergunningController.class)
@Import(GlobalExceptionHandler.class)
class VergunningControllerTest {

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
                "John Doe",
                ZaakType.BOUWVERGUNNING,
                "Aanvraag voor bouw van een nieuwe woning.",
                "Amsterdam"
        );

        validResponse = new VergunningResponse(
                UUID.fromString("1"),
                "John Doe",
                "BOUWVERGUNNING",
                LocalDateTime.now(),
                "IN_BEHANDELING"
        );

    }

    @Test
    void aanvraag_ValidRequest_ReturnsCreated() throws Exception {

        // Mock de service om een geldig antwoord te geven
        when(vergunningService.aanvragen(any(VergunningRequest.class)))
                .thenReturn(validResponse);

        // Voer de POST-aanvraag uit
        ResultActions resultActions = mockMvc.perform(post("/api/v1/vergunningen")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(validRequest)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.vergunningid").value(validResponse.vergunningId()))
                .andExpect(jsonPath("$.status").value(validResponse.status()));

    }

}