package com.agilesolutions.vergunning.config;

import com.agilesolutions.common.dto.ZaakRequest;
import com.agilesolutions.common.dto.ZaakResponse;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.service.annotation.HttpExchange;
import org.springframework.web.service.annotation.PostExchange;

@HttpExchange("/api/v1/zaken")
public interface ZakenRegistratieClient {

    @PostExchange
    ZaakResponse registreerZaak(@RequestBody ZaakRequest request);

}