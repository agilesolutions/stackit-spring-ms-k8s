package com.agilesolutions.zakenregistratie.service;

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

    public Zaak registreer(UUID vergunningId) {

        Zaak zaak = new Zaak();

        zaak.setVergunningId(vergunningId);
        zaak.setZaaknummer("ZAAK-" + UUID.randomUUID());
        zaak.setStatus("OPEN");
        zaak.setAangemaaktOp(LocalDateTime.now());

        return repository.save(zaak);
    }

    public Optional<Zaak> findById(UUID vergunningId) {
        return repository.findById(vergunningId);
    }

}