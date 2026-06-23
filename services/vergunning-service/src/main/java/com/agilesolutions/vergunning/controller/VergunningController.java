package com.agilesolutions.vergunning.controller;

import com.agilesolutions.common.dto.VergunningRequest;
import com.agilesolutions.common.dto.VergunningResponse;
import com.agilesolutions.vergunning.service.VergunningService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/vergunningen")
@RequiredArgsConstructor
@Tag(name = "Vergunningen", description = "API voor het aanvragen van vergunningen")
public class VergunningController {

    private final VergunningService vergunningService;

    @PostMapping
    @Operation(summary = "Vraag een vergunning aan", description = "Deze endpoint wordt gebruikt om een nieuwe vergunning aan te vragen.")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Vergunning succesvol aangevraagd"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Ongeldige aanvraag"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Interne serverfout")
    })
    @PreAuthorize("hasRole('ROLE_USER')")
    public ResponseEntity<VergunningResponse> aanvraag(@Valid
                                                           @Parameter(description = "De aanvraaggegevens voor de vergunning",
                                                                   example = "{\"aanvrager\": \"Robert Rong\", \"type\": \"BOUWVERGUNNING\", \"details\": \"Aanvraag voor bouw van een nieuwe woning.\"}",
                                                                   required = true)
                                                           @RequestBody VergunningRequest request) {

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(vergunningService.aanvragen(request));

    }
}