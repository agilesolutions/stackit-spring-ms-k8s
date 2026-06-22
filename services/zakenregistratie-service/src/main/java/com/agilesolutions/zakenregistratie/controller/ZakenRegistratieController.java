package com.agilesolutions.zakenregistratie.controller;

import com.agilesolutions.common.dto.ZaakRequest;
import com.agilesolutions.common.dto.ZaakResponse;
import com.agilesolutions.zakenregistratie.entity.Zaak;
import com.agilesolutions.zakenregistratie.service.ZaakService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/zaken")
@RequiredArgsConstructor
@Tag(name = "Zakenregistratie", description = "API voor het registreren van zaken")
public class ZakenRegistratieController {

    private final ZaakService zaakService;

    @PostMapping
    @Operation(summary = "Registreer een nieuwe zaak", description = "Deze endpoint wordt gebruikt om een nieuwe zaak te registreren.")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Zaak succesvol geregistreerd"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Ongeldige aanvraag"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Interne serverfout")
    })
    public ResponseEntity<ZaakResponse> registreer(
            @RequestBody ZaakRequest request) {

        var response =
                zaakService.registreer(request);

        return ResponseEntity.ok(response);

    }

    @GetMapping("/{id}")
    @Operation(summary = "Haal een zaak op", description = "Deze endpoint wordt gebruikt om een zaak op te halen op basis van het ID.")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Zaak succesvol opgehaald"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Zaak niet gevonden")
    })
    public ResponseEntity<Zaak> getZaak(
            @PathVariable UUID id) {

        return zaakService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());

    }

}