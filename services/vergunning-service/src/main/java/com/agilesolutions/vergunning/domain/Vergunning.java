package com.agilesolutions.vergunning.domain;

import java.time.LocalDate;
import java.util.UUID;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class Vergunning {

    private UUID id;
    private String aanvrager;
    private String vergunningType;
    private LocalDate aanvraagDatum;
    private String status;

}
