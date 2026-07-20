package com.agilesolutions.zakenregistratie.repository;


import com.agilesolutions.common.domain.ZaakStatus;
import com.agilesolutions.common.domain.ZaakType;
import com.agilesolutions.zakenregistratie.entity.Zaak;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.data.jpa.test.autoconfigure.DataJpaTest;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
class ZaakRepositoryTest {

    @Autowired
    ZaakRepository repository;

    @Test
    void shouldSaveZaak() {

        Zaak zaak = new Zaak();

        zaak.setVergunningId(UUID.randomUUID());
        zaak.setZaaknummer("ZAAK-2025-000100");
        zaak.setZaakType(ZaakType.OMGEVINGSVERGUNNING);
        zaak.setStatus(ZaakStatus.OPEN);
        zaak.setRegistratieDatum(LocalDateTime.now());

        Zaak saved = repository.save(zaak);

        assertThat(saved.getId()).isNotNull();
    }

}