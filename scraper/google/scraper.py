"""
Google Places API scraper for South Moravia accommodation.
Uses Nearby Search + Place Details endpoints.
"""
import httpx
import asyncio
import logging
import os
from typing import List
from scraper.normaliser import AccommodationRecord, classify_type

logger = logging.getLogger(__name__)

PLACES_API_BASE = "https://maps.googleapis.com/maps/api/place"

# South Moravia bounding centre + radius
SEARCH_LOCATIONS = [
    # (lat, lng, label)
    (49.2000, 16.6078, "Brno"),
    (48.8553, 16.0487, "Znojmo"),
    (48.8015, 16.6389, "Mikulov"),
    (48.7977, 16.8023, "Lednice"),
    (49.0525, 17.4647, "Uherské Hradiště"),
    (48.9208, 17.0966, "Hodonín"),
]

ACCOMMODATION_TYPES = ["lodging", "hotel", "hostel", "campground"]


async def fetch_nearby(client: httpx.AsyncClient, lat: float, lng: float, api_key: str, radius: int = 30000) -> list:
    results = []
    next_page_token = None

    for _ in range(3):  # max 3 pages = 60 results per location
        params = {
            "location": f"{lat},{lng}",
            "radius": radius,
            "type": "lodging",
            "key": api_key,
            "language": "cs",
        }
        if next_page_token:
            params = {"pagetoken": next_page_token, "key": api_key}
            await asyncio.sleep(2)  # required delay for next_page_token

        resp = await client.get(f"{PLACES_API_BASE}/nearbysearch/json", params=params)
        data = resp.json()

        if data.get("status") not in ("OK", "ZERO_RESULTS"):
            logger.warning(f"Places API error: {data.get('status')} — {data.get('error_message', '')}")
            break

        results.extend(data.get("results", []))
        next_page_token = data.get("next_page_token")
        if not next_page_token:
            break

    return results


async def fetch_place_details(client: httpx.AsyncClient, place_id: str, api_key: str) -> dict:
    fields = "name,formatted_address,geometry,rating,user_ratings_total,price_level,types,website,url,opening_hours,formatted_phone_number"
    resp = await client.get(
        f"{PLACES_API_BASE}/details/json",
        params={"place_id": place_id, "fields": fields, "key": api_key, "language": "cs"},
    )
    return resp.json().get("result", {})


def _detect_type(types: list) -> str:
    for t in (types or []):
        mapped = classify_type(t)
        if mapped != "other":
            return mapped
    return "other"


async def scrape_google(api_key: str) -> List[AccommodationRecord]:
    if not api_key:
        logger.error("GOOGLE_PLACES_API_KEY not set — skipping Google scraper")
        return []

    records: List[AccommodationRecord] = []
    seen_ids: set = set()

    async with httpx.AsyncClient(timeout=30) as client:
        for lat, lng, label in SEARCH_LOCATIONS:
            logger.info(f"Google Places: searching near {label} ({lat},{lng})")
            places = await fetch_nearby(client, lat, lng, api_key)
            logger.info(f"  → {len(places)} raw results")

            for place in places:
                place_id = place.get("place_id")
                if not place_id or place_id in seen_ids:
                    continue
                seen_ids.add(place_id)

                details = await fetch_place_details(client, place_id, api_key)
                location = details.get("geometry", {}).get("location", {})
                if not location.get("lat"):
                    continue

                # Best-effort price: Google returns price_level 0–4 (not actual CZK)
                # We store None and let Booking/Trivago fill the price
                record = AccommodationRecord(
                    name=details.get("name", place.get("name", "")),
                    lat=location["lat"],
                    lng=location["lng"],
                    source="google",
                    source_id=place_id,
                    source_url=details.get("url") or details.get("website"),
                    type=_detect_type(details.get("types", [])),
                    address=details.get("formatted_address"),
                    city=_extract_city(details.get("formatted_address", "")),
                    rating=details.get("rating"),
                    review_count=details.get("user_ratings_total"),
                    price_total=None,  # Google doesn't provide exact prices
                )
                records.append(record)
                logger.info(f"  + {record.name} ({record.type}) @ {record.lat:.4f},{record.lng:.4f}")
                await asyncio.sleep(0.1)

    logger.info(f"Google scrape complete: {len(records)} records")
    return records


def _extract_city(address: str) -> str | None:
    """Best-effort city extraction from formatted address."""
    if not address:
        return None
    parts = [p.strip() for p in address.split(",")]
    # Typically: "Street, PostalCode City, Country"
    for part in reversed(parts[:-1]):
        part = part.strip()
        if part and not part.isdigit() and "Czech" not in part:
            # Remove postal code prefix
            import re
            city = re.sub(r"^\d{3}\s*\d{2}\s*", "", part).strip()
            if city:
                return city
    return None
