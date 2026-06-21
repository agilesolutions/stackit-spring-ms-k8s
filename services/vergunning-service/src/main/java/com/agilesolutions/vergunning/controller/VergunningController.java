package com.agilesolutions.vergunning.controller;

import com.agilesolutions.common.dto.VergunningRequest;
import com.agilesolutions.common.dto.VergunningResponse;
import com.agilesolutions.vergunning.service.VergunningService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/vergunningen")
@RequiredArgsConstructor
public class VergunningController {

    private final VergunningService vergunningService;

    @PostMapping
    public VergunningResponse aanvraag(
            @RequestBody VergunningRequest request) {

        return vergunningService.aanvragen(request);

    }

}