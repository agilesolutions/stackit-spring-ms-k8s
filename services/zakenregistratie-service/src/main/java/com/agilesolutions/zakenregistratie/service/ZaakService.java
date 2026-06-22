package com.agilesolutions.zakenregistratie.service;

import com.agilesolutions.common.domain.ZaakStatus;
import com.agilesolutions.common.domain.ZaakType;
import com.agilesolutions.common.dto.ZaakRequest;
import com.agilesolutions.common.dto.ZaakResponse;
import com.agilesolutions.zakenregistratie.entity.Zaak;
import com.agilesolutions.zakenregistratie.repository.ZaakRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ZaakService {

    private final ZaakRepository repository;

    public ZaakResponse registreer(ZaakRequest request) {

        Zaak zaak = new Zaak();

        zaak.setId(UUID.randomUUID());
        zaak.setVergunningId(request.vergunningId());
        zaak.setZaaknummer("ZAAK-" + System.currentTimeMillis());
        zaak.setZaakType(request.zaakType().name());
        zaak.setStatus("OPEN");
        zaak.setAangemaaktOp(LocalDateTime.now());

        repository.save(zaak);

        return new ZaakResponse(
                zaak.getId(),
                zaak.getVergunningId(),
                zaak.getZaaknummer(),
                ZaakType.valueOf(zaak.getZaakType()),
                ZaakStatus.valueOf(zaak.getStatus()),
                zaak.getAangemaaktOp()
        );
    }

    public Optional<Zaak> findById(UUID vergunningId) {
        return repository.findById(vergunningId);
    }

}