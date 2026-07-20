package com.agilesolutions.common.dto;

import com.agilesolutions.common.domain.ZaakStatus;
import com.agilesolutions.common.domain.ZaakType;

import java.time.LocalDateTime;
import java.util.UUID;

public record ZaakResponse(
        UUID zaakId,
        UUID vergunningId,
        String zaaknummer,
        ZaakType zaakType,
        ZaakStatus status,
        LocalDateTime registratieDatum
) {
}