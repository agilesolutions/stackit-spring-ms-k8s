-- Voorbeeld data

INSERT INTO zaak
(
    id,
    vergunning_id,
    zaaknummer,
    zaak_type,
    status,
    registratie_datum
)
VALUES
    (
        gen_random_uuid(),
        gen_random_uuid(),
        'ZAAK-2025-000001',
        'OMGEVINGSVERGUNNING',
        'OPEN',
        now()
    );