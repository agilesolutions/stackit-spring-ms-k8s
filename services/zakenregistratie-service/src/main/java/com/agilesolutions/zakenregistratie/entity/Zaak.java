package com.agilesolutions.zakenregistratie.entity;

import com.agilesolutions.common.domain.ZaakStatus;
import com.agilesolutions.common.domain.ZaakType;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "zaak")
@Data
public class Zaak {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false)
    private UUID vergunningId;

    @Column(nullable = false, unique = true, length = 50)
    private String zaaknummer;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ZaakType zaakType;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ZaakStatus status;

    @Column(nullable = false)
    private LocalDateTime registratieDatum;
}