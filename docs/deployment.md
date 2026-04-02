# Deployment — AccomMap

## Local / Self-Hosted (Docker Compose)

### Requirements
- Docker Engine 24+
- Docker Compose v2
- 2 GB RAM, 10 GB disk

### Quick Start

```bash
git clone https://github.com/dominikkollar/accommap.git
cd accommap
cp .env.example .env
# Edit .env — set your GOOGLE_PLACES_API_KEY and a strong POSTGRES_PASSWORD

docker compose up -d db backend frontend
# Wait ~30s for DB to initialise, then run the scraper:
docker compose run --rm scraper

# Open the app
open http://localhost:3000
# API docs
open http://localhost:8000/docs
```

### Ports
| URL | Service |
|---|---|
| http://localhost:3000 | Interactive Map (frontend) |
| http://localhost:8000 | REST API |
| http://localhost:8000/docs | Swagger UI |
| localhost:5432 | PostgreSQL |

## Production Hardening

1. **Secrets**: Replace `.env` values with Docker secrets or a vault.
2. **TLS**: Add a Traefik or Nginx reverse proxy with Let's Encrypt.
3. **Backups**: Schedule daily `pg_dump` via cron.
4. **Scraper schedule**: Add a cron job or use `docker compose run` in a crontab to refresh weekly.

```cron
# Refresh accommodation prices every Monday at 02:00
0 2 * * 1 cd /opt/accommap && docker compose run --rm scraper >> /var/log/accommap-scraper.log 2>&1
```

## Environment Variables

| Variable | Required | Description |
|---|---|---|
| `POSTGRES_DB` | Yes | Database name |
| `POSTGRES_USER` | Yes | DB user |
| `POSTGRES_PASSWORD` | Yes | DB password (keep secret) |
| `GOOGLE_PLACES_API_KEY` | Recommended | Enables Google Places scraper |

## Upgrading

```bash
git pull
docker compose build
docker compose up -d
```
