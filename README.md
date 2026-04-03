# AccomMap — South Moravia Accommodation Price Map

Interactive price map of accommodation in the South Moravia (Jihomoravský kraj) region of the Czech Republic. Aggregates listings from Booking.com, Google Places, and Trivago, normalises all prices to **price per bed per night**, and visualises them on an open-source Leaflet.js map.

## Features

- **Interactive map** — OpenStreetMap base tiles, Leaflet.js (no proprietary API key needed for display)
- **Price heatmap** — density view weighted by price per bed
- **Marker clustering** — handles 500+ listings cleanly
- **Filters** — by accommodation type, price range, stars, services (breakfast, pool, spa, wine tasting…)
- **Multi-source data** — Booking.com (Playwright scraper), Google Places API, Trivago
- **PostGIS spatial DB** — bounding-box and radius queries
- **Full Docker stack** — `docker compose up` and you're done
- **Proxmox VM ready** — Terraform + cloud-init provisions a production Ubuntu 24.04 VM in minutes

## Quick Start

```bash
git clone https://github.com/dominikkollar/accommap.git
cd accommap
cp .env.example .env          # set GOOGLE_PLACES_API_KEY + POSTGRES_PASSWORD

docker compose up -d db backend frontend
docker compose run --rm scraper    # collect data (takes 10–30 min)

open http://localhost:3000         # interactive map
open http://localhost:8000/docs    # API docs
```

## Architecture

```
Scrapers (Python/Playwright) → PostgreSQL + PostGIS → FastAPI → Leaflet.js
```

See [docs/architecture.md](docs/architecture.md) for full detail.

## Deployment

| Target | Guide |
|---|---|
| Local (Docker Compose) | [docs/deployment.md](docs/deployment.md) |
| Proxmox VM (Terraform + cloud-init) | [infra/proxmox/README.md](infra/proxmox/README.md) |

## Data Sources

| Source | Method | Notes |
|---|---|---|
| Booking.com | Playwright scraper | JS-rendered, respects rate limits |
| Google Places | REST API | Requires `GOOGLE_PLACES_API_KEY` |
| Trivago | HTTP / MCP | Supplementary listings |

## Accommodation Types

Hotels · Pensions · Apartments · Hostels · Agro-tourism · Wellness Resorts · Camping · Winery Stays

## Docs

- [Business Analysis](docs/analysis.md)
- [Architecture](docs/architecture.md)
- [Testing](docs/testing.md)
- [Operations](docs/operations.md)
- [Deployment](docs/deployment.md)
- [Proxmox Infrastructure](infra/proxmox/README.md)

## License

MIT
