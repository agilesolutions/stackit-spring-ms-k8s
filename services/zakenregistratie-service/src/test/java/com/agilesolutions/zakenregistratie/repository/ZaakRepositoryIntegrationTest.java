package com.agilesolutions.zakenregistratie.repository;

import com.agilesolutions.common.domain.ZaakStatus;
import com.agilesolutions.common.domain.ZaakType;
import com.agilesolutions.zakenregistratie.config.TestContainersConfiguration;
import com.agilesolutions.zakenregistratie.entity.Zaak;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@Import(TestContainersConfiguration.class)
class ZaakRepositoryIntegrationTest {

    @Autowired
    ZaakRepository repository;

    @Test
    void shouldPersistZaak() {

        Zaak zaak = new Zaak();

        zaak.setVergunningId(UUID.randomUUID());
        zaak.setZaaknummer("ZAAK-2025-000200");
        zaak.setZaakType(ZaakType.BOUWVERGUNNING);
        zaak.setStatus(ZaakStatus.OPEN);
        zaak.setRegistratieDatum(LocalDateTime.now());

        repository.save(zaak);

        assertThat(repository.count()).isEqualTo(1);

    }

}