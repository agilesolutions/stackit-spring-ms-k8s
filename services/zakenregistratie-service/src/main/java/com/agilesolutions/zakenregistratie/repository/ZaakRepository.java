package com.agilesolutions.zakenregistratie.repository;

import com.agilesolutions.zakenregistratie.entity.Zaak;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface ZaakRepository
        extends JpaRepository<Zaak, UUID> {

    Optional<Zaak> findByZaaknummer(String zaaknummer);

}