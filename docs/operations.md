# Operations — AccomMap

## Docker Services

| Service | Port | Purpose |
|---|---|---|
| `db` | 5432 | PostgreSQL 16 + PostGIS 3.4 |
| `backend` | 8000 | FastAPI REST API |
| `frontend` | 3000 | Nginx → Leaflet.js app |
| `scraper` | — | One-shot data collection |

## Starting the Stack

```bash
# First run: copy env config
cp .env.example .env
# Edit .env: set GOOGLE_PLACES_API_KEY and POSTGRES_PASSWORD

docker compose up -d db backend frontend
```

## Running the Scraper

```bash
# Full scrape (Trivago + Google + Booking)
docker compose run --rm scraper

# Scraper logs
docker compose logs scraper -f
```

## Monitoring

```bash
# All service logs
docker compose logs -f

# DB health
docker compose exec db psql -U accommap -c "SELECT COUNT(*) FROM accommodations;"

# Backend health
curl http://localhost:8000/health
```

## Database Access

```bash
docker compose exec db psql -U accommap -d accommap
```

### Useful Queries

```sql
-- Price distribution by type
SELECT type, COUNT(*), ROUND(AVG(price_per_bed)::numeric,2) avg
FROM v_accommodations_with_price GROUP BY type ORDER BY avg;

-- Top 10 cheapest per bed
SELECT name, city, type, price_per_bed, currency
FROM v_accommodations_with_price
WHERE price_per_bed IS NOT NULL
ORDER BY price_per_bed ASC LIMIT 10;

-- Listings in Mikulov area
SELECT name, type, price_per_bed
FROM v_accommodations_with_price
WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(16.6389, 48.8015), 4326)::geography, 10000);
```

## Backup

```bash
docker compose exec db pg_dump -U accommap accommap > backup_$(date +%Y%m%d).sql
```

## Updating Data

Re-run the scraper to refresh prices (price history is preserved, new rows added):
```bash
docker compose run --rm scraper
```
