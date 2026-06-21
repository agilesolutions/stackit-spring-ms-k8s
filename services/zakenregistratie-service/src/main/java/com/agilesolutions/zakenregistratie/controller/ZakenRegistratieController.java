package com.agilesolutions.zakenregistratie.controller;

import com.agilesolutions.common.dto.ZaakRequest;
import com.agilesolutions.zakenregistratie.entity.Zaak;
import com.agilesolutions.zakenregistratie.service.ZaakService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/zaken")
@RequiredArgsConstructor
public class ZakenRegistratieController {

    private final ZaakService zaakService;

    @PostMapping
    public ResponseEntity<Zaak> registreer(
            @RequestBody ZaakRequest request) {

        Zaak zaak =
                zaakService.registreer(request.vergunningId());

        return ResponseEntity.ok(zaak);

    }

    @GetMapping("/{id}")
    public ResponseEntity<Zaak> getZaak(
            @PathVariable UUID id) {

        return zaakService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());

    }

}