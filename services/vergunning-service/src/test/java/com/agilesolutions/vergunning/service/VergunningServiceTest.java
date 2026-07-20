package com.agilesolutions.vergunning.service;

import com.agilesolutions.common.domain.ZaakStatus;
import com.agilesolutions.common.domain.ZaakType;
import com.agilesolutions.common.dto.VergunningRequest;
import com.agilesolutions.common.dto.VergunningResponse;
import com.agilesolutions.common.dto.ZaakResponse;
import com.agilesolutions.vergunning.config.ZakenRegistratieClient;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertAll;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class VergunningServiceTest {

    @Mock
    private ZakenRegistratieClient  zakenRegistratieClient;

    @InjectMocks
    private VergunningService vergunningService;

    private ZaakResponse validResponse;

    private VergunningRequest validRequest;

    @BeforeEach
    void setUp() {

        validRequest  = new VergunningRequest("Robert Rong",
                ZaakType.BOUWVERGUNNING,
                "Nieuwe bouw locatie",
                "Amstelveen");

        validResponse = new ZaakResponse(UUID.fromString("1"),
                UUID.fromString("2"),
                "test",
                ZaakType.BOUWVERGUNNING,
                ZaakStatus.OPEN,
                LocalDateTime.now());

    }

    @Test
    public void testAanvragen() {

        // GIVEN
        when(zakenRegistratieClient.registreerZaak(any())).thenReturn(validResponse);

        // WHEN
        VergunningResponse response = vergunningService.aanvragen(validRequest);

        // THEN
        assertAll("verify result",
                () -> assertEquals(ZaakStatus.OPEN,response.status()),
                () -> assertEquals("Vergunning succesvol geregistreerd", response.bericht())

        );









    }


}