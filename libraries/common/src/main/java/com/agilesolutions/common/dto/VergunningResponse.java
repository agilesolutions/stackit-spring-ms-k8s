package com.agilesolutions.common.dto;

import java.time.LocalDateTime;
import java.util.UUID;

public record VergunningResponse(

        UUID vergunningId,

        String zaaknummer,

        String status,

        LocalDateTime aanvraagDatum,

        String bericht

) {
}