CREATE TABLE zaak
(
    id                  UUID PRIMARY KEY,

    vergunning_id       UUID NOT NULL,

    zaaknummer          VARCHAR(50) NOT NULL UNIQUE,

    zaak_type           VARCHAR(50) NOT NULL,

    status              VARCHAR(30) NOT NULL,

    registratie_datum   TIMESTAMP NOT NULL
);

CREATE INDEX idx_zaak_vergunning
    ON zaak(vergunning_id);

CREATE INDEX idx_zaak_status
    ON zaak(status);

CREATE INDEX idx_zaak_zaaknummer
    ON zaak(zaaknummer);