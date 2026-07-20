package com.agilesolutions.common.dto;

import com.agilesolutions.common.domain.ZaakStatus;

import java.time.LocalDateTime;
import java.util.UUID;

public record VergunningResponse(

        UUID vergunningId,

        String zaaknummer,

        ZaakStatus status,

        LocalDateTime aanvraagDatum,

        String bericht

) {
}