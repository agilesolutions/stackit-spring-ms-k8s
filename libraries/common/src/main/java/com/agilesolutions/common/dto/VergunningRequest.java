package com.agilesolutions.common.dto;

import com.agilesolutions.common.domain.ZaakType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record VergunningRequest(

        @NotBlank
        @Size(max = 100)
        String aanvrager,

        @NotBlank
        @Size(max = 50)
        ZaakType vergunningType,

        @NotBlank
        @Size(max = 250)
        String omschrijving,

        @NotNull
        String locatie

) {
}