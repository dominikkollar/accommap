# Business Analysis — AccomMap

## Project Overview
**accommap** is an interactive price map of accommodation in the South Moravia region (Czech Republic). It aggregates accommodation listings from multiple sources, normalises pricing to **price per bed per night**, and visualises the data on an interactive open-source map.

## Goals
1. Provide a unified, searchable price map of South Moravian accommodation.
2. Support comparison by accommodation type, services, and price band.
3. Deliver a self-hosted, open-source solution deployable via Docker.

## Data Sources
| Source | Method | Data Collected |
|---|---|---|
| Booking.com | Web scraping (Playwright) | Name, address, type, price, beds, services, lat/lng |
| Google Places API | REST API | Name, address, rating, lat/lng, type |
| Trivago MCP | MCP tool calls | Price comparison, supplementary listings |

## Accommodation Types (South Moravia)
- Hotel (1–5 stars)
- Pension / Guest House
- Apartment / Holiday Flat
- Hostel / Dormitory
- Agro-tourism / Farm Stay
- Wellness Resort
- Camping / Glamping
- Winery Stay (wine region specific)

## Additional Services Tracked
- Parking (free / paid)
- Breakfast included
- Restaurant on-site
- Spa / Wellness
- Pool
- Bike rental
- Wine tasting
- Pet-friendly
- Conference rooms
- EV charging

## Key Metric
**Price per Bed per Night (CZK / EUR)**  
`price_per_bed = total_room_price / bed_count`

## Geographic Scope
- Region: Jihomoravský kraj (South Moravia), Czech Republic
- Key areas: Brno, Znojmo, Mikulov, Lednice, Valtice, Moravský krumlov, Uherské Hradiště surroundings
- Bounding box: 48.55°N–49.65°N, 15.80°E–17.90°E

## User Personas
1. **Traveller** — finds affordable accommodation on interactive map
2. **Event Planner** — compares group accommodation capacity and services
3. **Analyst** — exports data for regional tourism research

## Success Criteria
- ≥ 200 accommodation listings ingested
- Price data normalised to per-bed metric
- Interactive map with filter by type / price / services
- Full data pipeline reproducible via `docker compose up`
