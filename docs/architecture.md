# Architecture — AccomMap

## System Overview

```
┌──────────────────────────────────────────────────────────────────────┐
│  Deployment target: local Docker host  OR  Proxmox VM (Ubuntu 24.04) │
│                                                                       │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │                       Docker Compose                           │  │
│  │                                                                │  │
│  │  ┌──────────┐    ┌──────────────┐    ┌───────────────┐        │  │
│  │  │ Scraper  │───▶│  PostgreSQL  │◀───│   FastAPI     │        │  │
│  │  │(Playwright│    │  + PostGIS  │    │   Backend     │        │  │
│  │  │ + httpx) │    └──────────────┘    └───────┬───────┘        │  │
│  │  └──────────┘                                │                │  │
│  │                                              │ REST/JSON       │  │
│  │  ┌──────────────────────────────────────┐    │                │  │
│  │  │         Frontend (Nginx)             │◀───┘                │  │
│  │  │  Leaflet.js + OpenStreetMap tiles    │                     │  │
│  │  │  Price heatmap, clustering, filters  │                     │  │
│  │  └──────────────────────────────────────┘                     │  │
│  └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

## Component Details

### 1. Scraper Service (Python)
- **booking/**: Playwright headless browser scraper for Booking.com South Moravia listings
- **google/**: Google Places API client (Nearby Search + Place Details)
- **trivago/**: Trivago data via MCP tool integration
- **normaliser.py**: Unified data model, price-per-bed calculation
- Runs once on-demand (`docker compose run scraper`)

### 2. Database (PostgreSQL 16 + PostGIS 3.4)
- Spatial queries via PostGIS
- Schema: `accommodations`, `prices`, `services`, `sources`
- EPSG:4326 coordinates stored as `GEOMETRY(Point, 4326)`

### 3. Backend API (FastAPI)
- `/api/listings` — paginated accommodation list with filters
- `/api/listings/{id}` — single listing detail
- `/api/map/geojson` — GeoJSON FeatureCollection for map rendering
- `/api/stats` — price statistics by type/area
- `/api/filters` — available filter options

### 4. Frontend (Leaflet.js + Vite)
- **BaseMap**: OpenStreetMap tiles (no API key required)
- **PriceHeatmap**: Leaflet.heat plugin, density by price-per-bed
- **MarkerCluster**: Leaflet.markercluster for dense areas
- **FilterPanel**: Sidebar with type, price range, services checkboxes
- **PopupCard**: Name, type, price/bed, services, source link

## Database Schema

```sql
CREATE TABLE accommodations (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    type        VARCHAR(50),           -- hotel, pension, hostel, apartment, etc.
    address     TEXT,
    city        VARCHAR(100),
    lat         DOUBLE PRECISION,
    lng         DOUBLE PRECISION,
    geom        GEOMETRY(Point, 4326),
    stars       SMALLINT,
    beds_total  INTEGER,
    source      VARCHAR(50),           -- booking, google, trivago
    source_id   VARCHAR(255),
    source_url  TEXT,
    scraped_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE prices (
    id                  SERIAL PRIMARY KEY,
    accommodation_id    INTEGER REFERENCES accommodations(id),
    price_total         NUMERIC(10,2),  -- room price per night
    beds_in_room        INTEGER,
    price_per_bed       NUMERIC(10,2),  -- computed: price_total / beds_in_room
    currency            CHAR(3) DEFAULT 'CZK',
    date_collected      DATE DEFAULT CURRENT_DATE,
    check_in            DATE,
    check_out           DATE
);

CREATE TABLE services (
    id                  SERIAL PRIMARY KEY,
    accommodation_id    INTEGER REFERENCES accommodations(id),
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
    ev_charging         BOOLEAN DEFAULT FALSE
);
```

## Technology Choices

| Layer | Technology | Reason |
|---|---|---|
| Map tiles | OpenStreetMap | Free, open-source, no API key |
| Map library | Leaflet.js 1.9 | Lightweight, MIT, rich plugin ecosystem |
| Heatmap | Leaflet.heat | Native Leaflet plugin for density maps |
| Clustering | Leaflet.markercluster | Handles 500+ markers gracefully |
| Frontend build | Vite | Fast HMR, minimal config |
| Backend | FastAPI | Async, auto-docs, Pydantic validation |
| Spatial DB | PostGIS | Industry standard, bounding-box queries |
| Scraping | Playwright | Handles JS-rendered Booking.com pages |
| VM provisioning | Terraform (bpg/proxmox) | Declarative Proxmox VM lifecycle |
| VM bootstrap | cloud-init | Installs Docker, clones repo, writes .env, registers systemd service |
| VM OS | Ubuntu 24.04 LTS | LTS, cloud-image ready, official Docker support |

## Infrastructure Targets

| Target | Runtime | Guide |
|---|---|---|
| Local development | Docker Compose (bare host) | [docs/deployment.md](deployment.md) |
| Production (Proxmox cluster) | Ubuntu 24.04 VM + Docker Compose | [infra/proxmox/README.md](../infra/proxmox/README.md) |

The same `docker-compose.yml` runs in both targets — the only difference is how the host is provisioned.
