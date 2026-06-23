package com.agilesolutions.vergunning.service;

import com.agilesolutions.common.dto.VergunningRequest;
import com.agilesolutions.common.dto.VergunningResponse;
import com.agilesolutions.common.dto.ZaakRequest;
import com.agilesolutions.common.dto.ZaakResponse;
import com.agilesolutions.vergunning.config.ZakenRegistratieClient;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class VergunningService {

    private final ZakenRegistratieClient zakenRegistratieClient;

    public VergunningResponse aanvragen(VergunningRequest request) {

        ZaakResponse zaak =
                zakenRegistratieClient.registreerZaak(
                        new ZaakRequest(
                                UUID.randomUUID(),
                                request.vergunningType()));

        return new VergunningResponse(
                zaak.vergunningId(),
                zaak.zaaknummer(),
                zaak.status(),
                LocalDateTime.now(),
                "Vergunning succesvol geregistreerd");
    }


}