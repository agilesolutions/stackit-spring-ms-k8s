package com.agilesolutions.common.dto;

import com.agilesolutions.common.domain.ZaakType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.util.UUID;

public record ZaakRequest(

        @NotNull
        UUID vergunningId,

        @NotBlank
        ZaakType zaakType

) {
}