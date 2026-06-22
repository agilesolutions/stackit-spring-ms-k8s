package com.agilesolutions.zakenregistratie.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name="zaken")
@Data
public class Zaak {

    @Id
    @GeneratedValue
    private UUID id;

    private UUID vergunningId;

    private String zaaknummer;

    private String zaakType;

    private String status;

    private LocalDateTime aangemaaktOp;

}