package com.agilesolutions.vergunning.rest;

import com.agilesolutions.common.domain.ZaakType;
import com.agilesolutions.common.dto.ZaakRequest;
import com.agilesolutions.vergunning.config.ZakenRegistratieClient;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.restclient.test.autoconfigure.RestClientTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;

import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;


@RestClientTest(ZakenRegistratieClient.class) // Focuses context only on this client
class ZakenRegistratieClientTest {

    @Autowired
    private ZakenRegistratieClient client;

    @Autowired
    private MockRestServiceServer server;

    @Test
    void registreerZaak() {

        UUID id = UUID.randomUUID();

        // 1. Setup Mock Server expectations
        server.expect( requestTo("/api/v1/zaken"))
                .andRespond(withSuccess("{\"zaakId\":{}, \"vergunningId\":9999}".formatted(id), MediaType.APPLICATION_JSON));

        // 2. Execute the Outbound Client Method
        var response = client.registreerZaak(new ZaakRequest(id, ZaakType.BOUWVERGUNNING));

        // 3. verify asserts
        assertThat(response.zaakId()).isEqualTo(id);
        assertThat(response.zaakType()).isEqualTo(ZaakType.BOUWVERGUNNING);

    }
}