package com.agilesolutions.vergunning.service;

import com.agilesolutions.common.dto.VergunningRequest;
import com.agilesolutions.common.dto.VergunningResponse;
import com.agilesolutions.common.dto.ZaakRequest;
import com.agilesolutions.common.dto.ZaakResponse;
import com.agilesolutions.vergunning.config.ZakenRegistratieClient;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class VergunningService {

    private final ZakenRegistratieClient client;

    public VergunningResponse aanvragen(
            VergunningRequest request) {

        UUID vergunningId = UUID.randomUUID();

        ZaakRequest zaak = new ZaakRequest(vergunningId);

        ZaakResponse response =
                client.registreerZaak(zaak);

        return new VergunningResponse(
                vergunningId,
                response.zaaknummer(),
                "INGEDIEND");

    }

}