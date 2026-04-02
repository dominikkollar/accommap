"""
Booking.com scraper for South Moravia accommodation.
Uses Playwright to handle JS-rendered pages.
"""
import asyncio
import re
import logging
import os
from typing import List
from playwright.async_api import async_playwright, Page, TimeoutError as PlaywrightTimeout
from scraper.normaliser import AccommodationRecord, classify_type

logger = logging.getLogger(__name__)

BASE_URL = "https://www.booking.com/searchresults.cs.html"
# South Moravia region search parameters
SEARCH_PARAMS = {
    "ss": "Jihomoravský kraj, Česká republika",
    "lang": "en-gb",
    "sb": "1",
    "src_elem": "sb",
    "src": "searchresults",
    "dest_type": "region",
    "ac_position": "0",
    "ac_langcode": "cs",
    "rows": "25",
}

SERVICE_KEYWORDS = {
    "parking_free": ["free parking", "bezplatné parkování", "free private parking"],
    "parking_paid": ["paid parking", "placené parkování"],
    "breakfast_included": ["breakfast included", "snídaně v ceně", "free breakfast"],
    "restaurant": ["restaurant", "restaurace"],
    "spa_wellness": ["spa", "wellness", "sauna"],
    "pool": ["swimming pool", "bazén", "pool"],
    "bike_rental": ["bike rental", "půjčovna kol", "cycling"],
    "wine_tasting": ["wine tasting", "degustace vín", "vinotéka"],
    "pet_friendly": ["pets allowed", "domácí zvířata povolena"],
    "conference_rooms": ["meeting rooms", "conference", "konferenční"],
    "ev_charging": ["electric vehicle", "ev charging", "nabíjecí stanice"],
    "wifi_free": ["free wifi", "free wi-fi", "bezplatné wi-fi"],
    "air_conditioning": ["air conditioning", "klimatizace"],
}


async def extract_listing(card) -> dict | None:
    try:
        name_el = await card.query_selector('[data-testid="title"]')
        name = (await name_el.inner_text()).strip() if name_el else None
        if not name:
            return None

        url_el = await card.query_selector('a[data-testid="title-link"]')
        url = await url_el.get_attribute("href") if url_el else None

        # Price
        price_el = await card.query_selector('[data-testid="price-and-discounted-price"]')
        price_text = (await price_el.inner_text()).strip() if price_el else ""
        price = _parse_price(price_text)

        # Rating
        rating_el = await card.query_selector('[data-testid="review-score"] .ac4a7896c7')
        rating_text = (await rating_el.inner_text()).strip() if rating_el else ""
        rating = _parse_float(rating_text)

        # Type / stars from subtitle
        subtitle_el = await card.query_selector('[data-testid="recommended-units"] h4')
        subtitle = (await subtitle_el.inner_text()).strip() if subtitle_el else ""

        # Stars
        stars_el = await card.query_selector('[data-testid="rating-stars"] span')
        stars = None
        if stars_el:
            stars_text = await stars_el.get_attribute("aria-label") or ""
            m = re.search(r"(\d)", stars_text)
            stars = int(m.group(1)) if m else None

        # Location
        loc_el = await card.query_selector('[data-testid="address"]')
        address = (await loc_el.inner_text()).strip() if loc_el else None

        return {
            "name": name,
            "url": url,
            "price": price,
            "rating": rating,
            "type": classify_type(subtitle),
            "stars": stars,
            "address": address,
        }
    except Exception as e:
        logger.debug(f"Error extracting card: {e}")
        return None


def _parse_price(text: str) -> float | None:
    digits = re.sub(r"[^\d,.]", "", text).replace(",", "")
    try:
        return float(digits)
    except ValueError:
        return None


def _parse_float(text: str) -> float | None:
    text = text.replace(",", ".")
    m = re.search(r"[\d.]+", text)
    try:
        return float(m.group()) if m else None
    except ValueError:
        return None


async def _get_coordinates(page: Page, url: str) -> tuple[float, float] | None:
    """Extract lat/lng from a listing's detail page."""
    try:
        await page.goto(url, timeout=20000, wait_until="domcontentloaded")
        # Try meta geo tags
        lat_meta = await page.query_selector('meta[name="geo.position"]')
        if lat_meta:
            content = await lat_meta.get_attribute("content")
            if content:
                parts = content.split(";")
                if len(parts) == 2:
                    return float(parts[0]), float(parts[1])
        # Try map link
        map_link = await page.query_selector('a[id="hotel_address"]')
        if map_link:
            href = await map_link.get_attribute("href") or ""
            m = re.search(r"lat=([0-9.-]+).*?lng=([0-9.-]+)", href)
            if m:
                return float(m.group(1)), float(m.group(2))
        # Try data-atlas-latlng
        el = await page.query_selector('[data-atlas-latlng]')
        if el:
            latlng = await el.get_attribute("data-atlas-latlng")
            if latlng:
                parts = latlng.split(",")
                if len(parts) == 2:
                    return float(parts[0]), float(parts[1])
    except Exception as e:
        logger.debug(f"Could not get coords for {url}: {e}")
    return None


async def scrape_booking(max_pages: int = 10) -> List[AccommodationRecord]:
    records = []
    async with async_playwright() as p:
        browser = await p.chromium.launch(
            headless=True,
            args=["--no-sandbox", "--disable-dev-shm-usage"],
        )
        context = await browser.new_context(
            user_agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
                       "(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            locale="cs-CZ",
        )
        page = await context.new_page()

        # Build search URL
        from urllib.parse import urlencode
        search_url = f"{BASE_URL}?{urlencode(SEARCH_PARAMS)}"
        logger.info(f"Scraping Booking.com: {search_url}")

        for page_num in range(max_pages):
            offset = page_num * 25
            url = f"{search_url}&offset={offset}"
            try:
                await page.goto(url, timeout=30000, wait_until="networkidle")
            except PlaywrightTimeout:
                logger.warning(f"Timeout loading page {page_num}")
                continue

            cards = await page.query_selector_all('[data-testid="property-card"]')
            if not cards:
                logger.info(f"No cards found on page {page_num}, stopping")
                break

            logger.info(f"Page {page_num + 1}: found {len(cards)} cards")
            detail_page = await context.new_page()

            for card in cards:
                data = await extract_listing(card)
                if not data or not data.get("url"):
                    continue

                # Fetch coordinates from detail page
                coords = await _get_coordinates(detail_page, data["url"])
                if not coords:
                    logger.debug(f"Skipping {data['name']} — no coordinates")
                    continue

                lat, lng = coords
                record = AccommodationRecord(
                    name=data["name"],
                    lat=lat,
                    lng=lng,
                    source="booking",
                    source_id=re.search(r"/hotel/[^/]+/([^.]+)", data["url"] or "").group(0) if data.get("url") else None,
                    source_url=data.get("url"),
                    type=data.get("type", "other"),
                    address=data.get("address"),
                    stars=data.get("stars"),
                    rating=data.get("rating"),
                    price_total=data.get("price"),
                    currency="CZK",
                    beds_in_room=2,  # default; refined in detail scrape
                )
                records.append(record)
                logger.info(f"  + {record.name} ({record.type}) @ {lat:.4f},{lng:.4f} — {record.price_total} CZK")

            await detail_page.close()
            # Rate limit
            await asyncio.sleep(2)

        await browser.close()

    logger.info(f"Booking scrape complete: {len(records)} records")
    return records
