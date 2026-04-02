-- AccomMap database initialisation
-- PostGIS extension is pre-installed in postgis/postgis image

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- ──────────────────────────────────────────────
-- Accommodations
-- ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS accommodations (
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(255) NOT NULL,
    type            VARCHAR(50) CHECK (type IN (
                        'hotel','pension','hostel','apartment',
                        'agro','wellness','camping','winery','other'
                    )),
    address         TEXT,
    city            VARCHAR(100),
    postal_code     VARCHAR(20),
    lat             DOUBLE PRECISION NOT NULL,
    lng             DOUBLE PRECISION NOT NULL,
    geom            GEOMETRY(Point, 4326) GENERATED ALWAYS AS (
                        ST_SetSRID(ST_MakePoint(lng, lat), 4326)
                    ) STORED,
    stars           SMALLINT CHECK (stars BETWEEN 1 AND 5),
    beds_total      INTEGER,
    rooms_total     INTEGER,
    rating          NUMERIC(3,1),
    review_count    INTEGER,
    source          VARCHAR(50) NOT NULL,
    source_id       VARCHAR(255),
    source_url      TEXT,
    scraped_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (source, source_id)
);

CREATE INDEX idx_accommodations_geom ON accommodations USING GIST (geom);
CREATE INDEX idx_accommodations_type ON accommodations (type);
CREATE INDEX idx_accommodations_city ON accommodations (city);

-- ──────────────────────────────────────────────
-- Prices
-- ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS prices (
    id                  SERIAL PRIMARY KEY,
    accommodation_id    INTEGER NOT NULL REFERENCES accommodations(id) ON DELETE CASCADE,
    price_total         NUMERIC(10,2) NOT NULL,
    beds_in_room        INTEGER NOT NULL DEFAULT 1,
    price_per_bed       NUMERIC(10,2) GENERATED ALWAYS AS (
                            ROUND(price_total / GREATEST(beds_in_room, 1), 2)
                        ) STORED,
    currency            CHAR(3) DEFAULT 'CZK',
    date_collected      DATE DEFAULT CURRENT_DATE,
    check_in            DATE,
    check_out           DATE,
    room_type           VARCHAR(100)
);

CREATE INDEX idx_prices_accommodation ON prices (accommodation_id);
CREATE INDEX idx_prices_date ON prices (date_collected);

-- ──────────────────────────────────────────────
-- Services
-- ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS services (
    id                  SERIAL PRIMARY KEY,
    accommodation_id    INTEGER NOT NULL REFERENCES accommodations(id) ON DELETE CASCADE UNIQUE,
    parking_free        BOOLEAN DEFAULT FALSE,
    parking_paid        BOOLEAN DEFAULT FALSE,
    breakfast_included  BOOLEAN DEFAULT FALSE,
    restaurant          BOOLEAN DEFAULT FALSE,
    spa_wellness        BOOLEAN DEFAULT FALSE,
    pool                BOOLEAN DEFAULT FALSE,
    bike_rental         BOOLEAN DEFAULT FALSE,
    wine_tasting        BOOLEAN DEFAULT FALSE,
    pet_friendly        BOOLEAN DEFAULT FALSE,
    conference_rooms    BOOLEAN DEFAULT FALSE,
    ev_charging         BOOLEAN DEFAULT FALSE,
    wifi_free           BOOLEAN DEFAULT FALSE,
    air_conditioning    BOOLEAN DEFAULT FALSE
);

-- ──────────────────────────────────────────────
-- Convenience view: latest price per accommodation
-- ──────────────────────────────────────────────
CREATE OR REPLACE VIEW v_accommodations_with_price AS
SELECT
    a.*,
    p.price_per_bed,
    p.price_total,
    p.beds_in_room,
    p.currency,
    p.date_collected,
    s.parking_free,
    s.parking_paid,
    s.breakfast_included,
    s.restaurant,
    s.spa_wellness,
    s.pool,
    s.bike_rental,
    s.wine_tasting,
    s.pet_friendly,
    s.conference_rooms,
    s.ev_charging,
    s.wifi_free,
    s.air_conditioning
FROM accommodations a
LEFT JOIN LATERAL (
    SELECT * FROM prices
    WHERE accommodation_id = a.id
    ORDER BY date_collected DESC
    LIMIT 1
) p ON TRUE
LEFT JOIN services s ON s.accommodation_id = a.id;
