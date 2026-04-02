-- AccomMap seed data: real Trivago listings, South Moravia (April 2026)
-- 65 accommodations across Brno, Mikulov, Znojmo
-- Prices in EUR | price_per_bed = price_total / 2 beds (default)

BEGIN;

-- [1] Pension Euro (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Pension Euro', 'pension', 'Mikulov', 48.81303, 16.64619,
          NULL, 8.8, 1783,
          'trivago', 'trv_001', 'https://www.trivago.com/en-US/oar/guesthouse-pension-euro-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 80.0, 2, 40.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [2] Boutique Hotel Golf Garni (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Boutique Hotel Golf Garni', 'hotel', 'Mikulov', 48.80095, 16.64253,
          3, 9.0, 1071,
          'trivago', 'trv_002', 'https://www.trivago.com/en-US/oar/boutique-hotel-golf-garni-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 135.0, 2, 67.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [3] Hotel Ryzlink (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Ryzlink', 'hotel', 'Mikulov', 48.80215, 16.64578,
          4, 9.0, 1827,
          'trivago', 'trv_003', 'https://www.trivago.com/en-US/oar/hotel-ryzlink-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 195.0, 2, 97.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [4] Motel Eldorado (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Motel Eldorado', 'hotel', 'Mikulov', 48.81086, 16.62878,
          NULL, 9.5, 1364,
          'trivago', 'trv_004', 'https://www.trivago.com/en-US/oar/guesthouse-motel-eldorado-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 106.0, 2, 53.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [5] Hotel Zámeček (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Zámeček', 'hotel', 'Mikulov', 48.80627, 16.62482,
          3, 8.2, 7008,
          'trivago', 'trv_005', 'https://www.trivago.com/en-US/oar/hotel-zámeček-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 105.0, 2, 52.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, false, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [6] Hotel Marcinčák (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Marcinčák', 'hotel', 'Mikulov', 48.8055, 16.62584,
          3, 8.3, 636,
          'trivago', 'trv_006', 'https://www.trivago.com/en-US/oar/hotel-marcincak-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 142.0, 2, 71.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [7] Hotel Tanzberg (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Tanzberg', 'hotel', 'Mikulov', 48.80801, 16.64093,
          3, 8.1, 139,
          'trivago', 'trv_007', 'https://www.trivago.com/en-US/oar/hotel-tanzberg-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 139.0, 2, 69.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, false, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [8] Hotel Maroli Mikulov (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Maroli Mikulov', 'hotel', 'Mikulov', 48.80694, 16.62768,
          3, 8.7, 3059,
          'trivago', 'trv_008', 'https://www.trivago.com/en-US/oar/hotel-maroli-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 107.0, 2, 53.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, false, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [9] Penzion Monner (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Penzion Monner', 'pension', 'Mikulov', 48.80503, 16.64036,
          NULL, 9.4, 305,
          'trivago', 'trv_009', 'https://www.trivago.com/en-US/oar/guesthouse-penzion-monner-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 122.0, 2, 61.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [10] Vinařství Šílová (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Vinařství Šílová', 'winery', 'Mikulov', 48.80453, 16.63768,
          4, 9.5, 69,
          'trivago', 'trv_010', 'https://www.trivago.com/en-US/oar/hotel-vinařství-šílová-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 211.0, 2, 105.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [11] Villa Kiwi (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Villa Kiwi', 'pension', 'Mikulov', 48.80029, 16.64237,
          3, 9.5, 162,
          'trivago', 'trv_011', 'https://www.trivago.com/en-US/oar/guesthouse-villa-kiwi-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 100.0, 2, 50.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [12] Hotel Vivaldi (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Vivaldi', 'hotel', 'Mikulov', 48.80789, 16.6384,
          3, 8.6, 819,
          'trivago', 'trv_012', 'https://www.trivago.com/en-US/oar/hotel-vivaldi-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 100.0, 2, 50.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, false, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [13] Hotel Bonsai (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Bonsai', 'hotel', 'Mikulov', 48.80158, 16.63153,
          3, 8.9, 1131,
          'trivago', 'trv_013', 'https://www.trivago.com/en-US/oar/hotel-bonsai-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 110.0, 2, 55.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [14] Pension Archa Mikulov (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Pension Archa Mikulov', 'pension', 'Mikulov', 48.81273, 16.64382,
          3, 8.2, 518,
          'trivago', 'trv_014', 'https://www.trivago.com/en-US/oar/hotel-pension-archa-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 66.0, 2, 33.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, true, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [15] Penzion Zatisi (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Penzion Zatisi', 'pension', 'Mikulov', 48.81485, 16.63475,
          NULL, 8.5, 1308,
          'trivago', 'trv_015', 'https://www.trivago.com/en-US/oar/bed-breakfast-penzion-zatisi-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 68.0, 2, 34.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [16] Pension ANDREA (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Pension ANDREA', 'pension', 'Mikulov', 48.8109, 16.64122,
          3, 8.3, 624,
          'trivago', 'trv_016', 'https://www.trivago.com/en-US/oar/guesthouse-pension-andrea-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 59.0, 2, 29.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [17] Castle-Wall-Inn (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Castle-Wall-Inn', 'pension', 'Mikulov', 48.80545, 16.63545,
          NULL, 9.3, 267,
          'trivago', 'trv_017', 'https://www.trivago.com/en-US/oar/guesthouse-castle-wall-inn-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 83.0, 2, 41.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [18] Guesthouse Mikuláš Mikulov (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Guesthouse Mikuláš Mikulov', 'pension', 'Mikulov', 48.80803, 16.63971,
          NULL, 8.6, 1213,
          'trivago', 'trv_018', 'https://www.trivago.com/en-US/oar/guesthouse-mikuláš-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 81.0, 2, 40.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [19] Pod Vinicí (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Pod Vinicí', 'hotel', 'Mikulov', 48.81028, 16.64497,
          3, 8.6, 526,
          'trivago', 'trv_019', 'https://www.trivago.com/en-US/oar/hotel-pod-vinicí-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 68.0, 2, 34.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [20] Mlýn Sedlec (Mikulov)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Mlýn Sedlec', 'pension', 'Mikulov', 48.78234, 16.677,
          NULL, 8.8, 1428,
          'trivago', 'trv_020', 'https://www.trivago.com/en-US/oar/guesthouse-mlýn-sedlec-mikulov')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 111.0, 2, 55.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [21] PREMIUM Wellness & Wine Hotel Znojmo (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('PREMIUM Wellness & Wine Hotel Znojmo', 'wellness', 'Znojmo', 48.86905, 16.03551,
          4, 8.6, 6551,
          'trivago', 'trv_021', 'https://www.trivago.com/en-US/oar/premium-wellness-wine-hotel-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 108.0, 2, 54.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [22] Hotel Savannah (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Savannah', 'hotel', 'Znojmo', 48.76273, 16.05908,
          4, 8.9, 5407,
          'trivago', 'trv_022', 'https://www.trivago.com/en-US/oar/hotel-savannah-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 128.0, 2, 64.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [23] Hotel Katerina (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Katerina', 'hotel', 'Znojmo', 48.85829, 16.0462,
          4, 9.1, 1108,
          'trivago', 'trv_023', 'https://www.trivago.com/en-US/oar/hotel-katerina-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 157.0, 2, 78.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, false, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [24] Hotel U Divadla (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel U Divadla', 'hotel', 'Znojmo', 48.85284, 16.05386,
          3, 7.6, 1637,
          'trivago', 'trv_024', 'https://www.trivago.com/en-US/oar/hotel-u-divadla-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 116.0, 2, 58.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [25] Wellness Hotel Happy Star (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Wellness Hotel Happy Star', 'wellness', 'Znojmo', 48.79961, 15.99241,
          4, 9.1, 3262,
          'trivago', 'trv_025', 'https://www.trivago.com/en-US/oar/wellness-hotel-happy-star-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 85.0, 2, 42.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [26] Hotel Morava (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Morava', 'hotel', 'Znojmo', 48.85684, 16.04898,
          3, 8.0, 1657,
          'trivago', 'trv_026', 'https://www.trivago.com/en-US/oar/hotel-morava-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 75.0, 2, 37.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [27] Hotel Lahofer (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Lahofer', 'hotel', 'Znojmo', 48.85715, 16.04709,
          3, 8.8, 993,
          'trivago', 'trv_027', 'https://www.trivago.com/en-US/oar/hotel-lahofer-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 83.0, 2, 41.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [28] Apartmány Marienhof (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Apartmány Marienhof', 'apartment', 'Znojmo', 48.85636, 16.05393,
          4, 9.4, 1205,
          'trivago', 'trv_028', 'https://www.trivago.com/en-US/oar/serviced-apartment-apartmány-marienhof-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 111.0, 2, 55.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [29] Penzion U Tří Jasanů (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Penzion U Tří Jasanů', 'pension', 'Znojmo', 48.82693, 16.05401,
          3, 7.5, 120,
          'trivago', 'trv_029', 'https://www.trivago.com/en-US/oar/hotel-penzion-u-tří-jasanů-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 97.0, 2, 48.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, true, false, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [30] Penzion U Císaře Zikmunda (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Penzion U Císaře Zikmunda', 'pension', 'Znojmo', 48.85643, 16.04766,
          3, 9.5, 524,
          'trivago', 'trv_030', 'https://www.trivago.com/en-US/oar/hotel-penzion-u-císaře-zikmunda-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 90.0, 2, 45.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, false, false, false, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [31] Zoofarma Penzion Konírna (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Zoofarma Penzion Konírna', 'agro', 'Znojmo', 48.75657, 16.23351,
          NULL, 9.3, 30,
          'trivago', 'trv_031', 'https://www.trivago.com/en-US/oar/countryside-stay-zoofarma-penzion-konírna-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 103.0, 2, 51.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [32] Penzion Zlatý vůl (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Penzion Zlatý vůl', 'pension', 'Znojmo', 48.85687, 16.04759,
          NULL, 9.3, 358,
          'trivago', 'trv_032', 'https://www.trivago.com/en-US/oar/guesthouse-penzion-zlatý-vůl-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 100.0, 2, 50.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [33] Penzion Kulíšek (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Penzion Kulíšek', 'pension', 'Znojmo', 48.85831, 16.04828,
          3, 9.1, 900,
          'trivago', 'trv_033', 'https://www.trivago.com/en-US/oar/guesthouse-penzion-kulíšek-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 81.0, 2, 40.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [34] Hotel Mariel Znojmo (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Mariel Znojmo', 'hotel', 'Znojmo', 48.85557, 16.05478,
          3, 9.3, 4889,
          'trivago', 'trv_034', 'https://www.trivago.com/en-US/oar/hotel-mariel-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 98.0, 2, 49.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [35] Penzion Kimex (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Penzion Kimex', 'pension', 'Znojmo', 48.84601, 16.05563,
          3, 8.9, 115,
          'trivago', 'trv_035', 'https://www.trivago.com/en-US/oar/hotel-penzion-kimex-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 57.0, 2, 28.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [36] Penzion Eden (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Penzion Eden', 'pension', 'Znojmo', 48.83545, 16.06791,
          NULL, 7.8, 378,
          'trivago', 'trv_036', 'https://www.trivago.com/en-US/oar/guesthouse-penzion-eden-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 66.0, 2, 33.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, true, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [37] Hotel N (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel N', 'hotel', 'Znojmo', 48.88417, 16.03524,
          3, 7.7, 569,
          'trivago', 'trv_037', 'https://www.trivago.com/en-US/oar/hotel-n-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 107.0, 2, 53.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [38] Wine Cellar Stay Hnanice (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Wine Cellar Stay Hnanice', 'winery', 'Znojmo', 48.79798, 15.98298,
          NULL, 9.4, 17,
          'trivago', 'trv_038', 'https://www.trivago.com/en-US/oar/entire-house-apartment-stay-in-the-heart-of-hnanice-with-wine-cellar-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 202.0, 2, 101.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [39] VT6 House & Restaurant (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('VT6 House & Restaurant', 'pension', 'Znojmo', 48.8551, 16.05052,
          NULL, 8.3, 248,
          'trivago', 'trv_039', 'https://www.trivago.com/en-US/oar/bed-breakfast-vt6-house-restaurant-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 86.0, 2, 43.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, false, false, false, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [40] Hotel Prestige Znojmo (Znojmo)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Prestige Znojmo', 'hotel', 'Znojmo', 48.86905, 16.03551,
          4, 8.6, 6551,
          'trivago', 'trv_040', 'https://www.trivago.com/en-US/oar/premium-wellness-wine-hotel-znojmo')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 108.0, 2, 54.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [41] Hotel Continental (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Continental', 'hotel', 'Brno', 49.2005500793457, 16.604650497436523,
          4, 8.5, 5918,
          'trivago', 'trv_041', 'https://www.trivago.com/en-US/oar/hotel-continental-brno?search=100-129554;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 123.0, 2, 61.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [42] Cosmopolitan Bobycentrum (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Cosmopolitan Bobycentrum', 'hotel', 'Brno', 49.21221923828125, 16.608060836791992,
          4, 8.7, 8728,
          'trivago', 'trv_042', 'https://www.trivago.com/en-US/oar/hotel-cosmopolitan-bobycentrum-brno?search=100-197111;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 111.0, 2, 55.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [43] Orea Congress Hotel Brno (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Orea Congress Hotel Brno', 'hotel', 'Brno', 49.18579864501953, 16.584749221801758,
          4, 8.7, 15616,
          'trivago', 'trv_043', 'https://www.trivago.com/en-US/oar/orea-congress-hotel-brno?search=100-126981;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 100.0, 2, 50.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [44] Hotel Vista (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Vista', 'hotel', 'Brno', 49.23619079589844, 16.582359313964844,
          4, 8.6, 6205,
          'trivago', 'trv_044', 'https://www.trivago.com/en-US/oar/hotel-vista-brno?search=100-1360096;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 127.0, 2, 63.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [45] Grandezza Hotel Luxury Palace (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Grandezza Hotel Luxury Palace', 'hotel', 'Brno', 49.192588806152344, 16.609689712524414,
          4, 9.2, 6644,
          'trivago', 'trv_045', 'https://www.trivago.com/en-US/oar/grandezza-hotel-luxury-palace-brno?search=100-2254588;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 119.0, 2, 59.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [46] eFi Palace Hotel (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('eFi Palace Hotel', 'hotel', 'Brno', 49.19969177246094, 16.62044906616211,
          3, 8.4, 4948,
          'trivago', 'trv_046', 'https://www.trivago.com/en-US/oar/efi-palace-hotel-brno?search=100-3368023;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 72.0, 2, 36.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [47] Grand Palace Brno (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Grand Palace Brno', 'hotel', 'Brno', 49.19203186035156, 16.60563087463379,
          5, 9.2, 7300,
          'trivago', 'trv_047', 'https://www.trivago.com/en-US/oar/hotel-grand-palace-brno?search=100-1236199;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 129.0, 2, 64.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [48] Jacob Brno (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Jacob Brno', 'hotel', 'Brno', 49.19704055786133, 16.60886001586914,
          3, 8.8, 2286,
          'trivago', 'trv_048', 'https://www.trivago.com/en-US/oar/hotel-jacob-brno?search=100-2347852;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 76.0, 2, 38.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [49] Grandhotel Brno (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Grandhotel Brno', 'hotel', 'Brno', 49.19266128540039, 16.613000869750977,
          4, 8.6, 6598,
          'trivago', 'trv_049', 'https://www.trivago.com/en-US/oar/grandhotel-brno?search=100-127980;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 116.0, 2, 58.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [50] Hotel Royal Ricc (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Royal Ricc', 'hotel', 'Brno', 49.192630767822266, 16.607099533081055,
          4, 8.7, 3075,
          'trivago', 'trv_050', 'https://www.trivago.com/en-US/oar/hotel-royal-ricc-brno?search=100-177312;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 112.0, 2, 56.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [51] Hotel Europa (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Europa', 'hotel', 'Brno', 49.202789306640625, 16.61035919189453,
          3, 8.4, 7864,
          'trivago', 'trv_051', 'https://www.trivago.com/en-US/oar/hotel-europa-brno?search=100-971481;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 106.0, 2, 53.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [52] Hotel International Brno (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel International Brno', 'hotel', 'Brno', 49.195091247558594, 16.60548973083496,
          4, 8.9, 10343,
          'trivago', 'trv_052', 'https://www.trivago.com/en-US/oar/hotel-international-brno?search=100-126980;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 128.0, 2, 64.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [53] Hotel Passage (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Passage', 'hotel', 'Brno', 49.2021484375, 16.60708999633789,
          4, 9.2, 1938,
          'trivago', 'trv_053', 'https://www.trivago.com/en-US/oar/hotel-passage-brno?search=100-13266632;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 104.0, 2, 52.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [54] Courtyard by Marriott Brno (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Courtyard by Marriott Brno', 'hotel', 'Brno', 49.18218994140625, 16.606050491333008,
          4, 9.1, 7116,
          'trivago', 'trv_054', 'https://www.trivago.com/en-US/oar/hotel-courtyard-by-marriott-brno?search=100-5960582;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 133.0, 2, 66.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [55] Avanti Hotel (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Avanti Hotel', 'hotel', 'Brno', 49.212520599365234, 16.604719161987305,
          4, 8.7, 5929,
          'trivago', 'trv_055', 'https://www.trivago.com/en-US/oar/avanti-hotel-brno?search=100-177297;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 178.0, 2, 89.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [56] Fairhotel (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Fairhotel', 'hotel', 'Brno', 49.185821533203125, 16.587139129638672,
          4, 9.3, 2157,
          'trivago', 'trv_056', 'https://www.trivago.com/en-US/oar/fairhotel-brno?search=100-5162512;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 87.0, 2, 43.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [57] OREA Resort Santon (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('OREA Resort Santon', 'hotel', 'Brno', 49.23093032836914, 16.51845932006836,
          3, 9.0, 8769,
          'trivago', 'trv_057', 'https://www.trivago.com/en-US/oar/hotel-orea-resort-santon-brno?search=100-125357;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 156.0, 2, 78.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [58] EFI SPA Hotel Superior & Pivovar (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('EFI SPA Hotel Superior & Pivovar', 'hotel', 'Brno', 49.20183181762695, 16.61389923095703,
          4, 9.1, 2666,
          'trivago', 'trv_058', 'https://www.trivago.com/en-US/oar/efi-spa-hotel-superior-pivovar-brno?search=100-23329710;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 178.0, 2, 89.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [59] Maximus Resort (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Maximus Resort', 'hotel', 'Brno', 49.24338150024414, 16.515609741210938,
          4, 8.9, 5467,
          'trivago', 'trv_059', 'https://www.trivago.com/en-US/oar/hotel-maximus-resort-brno?search=100-2179290;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 172.0, 2, 86.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [60] Hotel Vaka (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Hotel Vaka', 'hotel', 'Brno', 49.218048095703125, 16.609060287475586,
          4, 8.9, 1268,
          'trivago', 'trv_060', 'https://www.trivago.com/en-US/oar/hotel-vaka-brno?search=100-970613;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 129.0, 2, 64.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [61] OREA Hotel Voro Brno (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('OREA Hotel Voro Brno', 'hotel', 'Brno', 49.18482971191406, 16.583459854125977,
          3, 8.2, 8159,
          'trivago', 'trv_061', 'https://www.trivago.com/en-US/oar/orea-hotel-voro-brno?search=100-126982;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 71.0, 2, 35.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [62] Kalina Apartments (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Kalina Apartments', 'apartment', 'Brno', 49.196250915527344, 16.60569953918457,
          4, 9.1, 923,
          'trivago', 'trv_062', 'https://www.trivago.com/en-US/oar/serviced-apartment-kalina-apartments-brno?search=100-27932116;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 89.0, 2, 44.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [63] U Heligonky (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('U Heligonky', 'pension', 'Brno', 49.19794845581055, 16.62520980834961,
          NULL, 8.1, 3662,
          'trivago', 'trv_063', 'https://www.trivago.com/en-US/oar/guesthouse-u-heligonky-brno?search=100-2671298;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 87.0, 2, 43.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, false, false, true, true, false FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [64] Euro Apartments Lidická 39 Brno (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('Euro Apartments Lidická 39 Brno', 'apartment', 'Brno', 49.203529357910156, 16.60658073425293,
          3, 8.8, 643,
          'trivago', 'trv_064', 'https://www.trivago.com/en-US/oar/serviced-apartment-euro-apartments-lidická-39-brno?search=100-9969752;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 58.0, 2, 29.0, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

-- [65] VV hotel & apartments (Brno)
WITH ins AS (
  INSERT INTO accommodations (name, type, city, lat, lng, stars, rating, review_count, source, source_id, source_url)
  VALUES ('VV hotel & apartments', 'apartment', 'Brno', 49.19078063964844, 16.616199493408203,
          3, 9.0, 3295,
          'trivago', 'trv_065', 'https://www.trivago.com/en-US/oar/vv-hotel-apartments-brno?search=100-1942933;dr-20260410-20260411;rc-1-2&cip=234716015')
  ON CONFLICT (source, source_id) DO UPDATE SET
    name=EXCLUDED.name, type=EXCLUDED.type, rating=EXCLUDED.rating, scraped_at=NOW()
  RETURNING id
)
, p AS (
  INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency)
  SELECT id, 165.0, 2, 82.5, 'EUR' FROM ins
)
INSERT INTO services (accommodation_id, wifi_free, parking_free, breakfast_included, restaurant, spa_wellness, pool, air_conditioning, pet_friendly)
SELECT id, true, true, false, true, true, true, true, true FROM ins
ON CONFLICT (accommodation_id) DO NOTHING;

COMMIT;

-- Seeded 65 South Moravia accommodations