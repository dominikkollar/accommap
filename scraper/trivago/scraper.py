"""
Trivago accommodation scraper for South Moravia.
Uses the Trivago MCP tool (available when running inside Claude Code environment).
Falls back to direct HTTP search when MCP is unavailable.
"""
import logging
import asyncio
import httpx
from typing import List
from scraper.normaliser import AccommodationRecord, classify_type

logger = logging.getLogger(__name__)

# South Moravia search queries for Trivago
SEARCH_QUERIES = [
    "Brno, South Moravia",
    "Mikulov, Czech Republic",
    "Znojmo, Czech Republic",
    "Lednice, Czech Republic",
    "Uherské Hradiště, Czech Republic",
]


async def scrape_trivago_http() -> List[AccommodationRecord]:
    """
    Trivago public search via HTTP.
    Returns best-effort results; price_per_bed computed from cheapest available room.
    """
    records: List[AccommodationRecord] = []

    async with httpx.AsyncClient(
        timeout=30,
        headers={
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36",
            "Accept-Language": "cs-CZ,cs;q=0.9,en;q=0.8",
        },
        follow_redirects=True,
    ) as client:
        for query in SEARCH_QUERIES:
            logger.info(f"Trivago HTTP search: {query}")
            try:
                # Trivago search API (public, no auth)
                resp = await client.get(
                    "https://www.trivago.com/en-CZ/srl/hotels",
                    params={
                        "search[dest]": query,
                        "search[locid]": "",
                        "search[rid]": "",
                        "search[in]": "",
                        "search[out]": "",
                        "search[rc]": "1",
                        "search[pa]": "1",
                    },
                )
                # Parse JSON-LD or meta data from the response
                import re, json
                text = resp.text
                # Extract JSON-LD structured data
                json_ld_matches = re.findall(r'<script[^>]*type="application/ld\+json"[^>]*>(.*?)</script>', text, re.DOTALL)
                for match in json_ld_matches:
                    try:
                        data = json.loads(match)
                        if isinstance(data, list):
                            items = data
                        elif data.get("@type") in ("Hotel", "LodgingBusiness"):
                            items = [data]
                        else:
                            items = data.get("itemListElement", [])

                        for item in items:
                            if isinstance(item, dict) and item.get("item"):
                                item = item["item"]
                            if not isinstance(item, dict):
                                continue
                            if item.get("@type") not in ("Hotel", "LodgingBusiness", "BedAndBreakfast", "Hostel"):
                                continue

                            geo = item.get("geo", {})
                            lat = geo.get("latitude")
                            lng = geo.get("longitude")
                            if not lat or not lng:
                                continue

                            name = item.get("name", "")
                            agg = item.get("aggregateRating", {})
                            record = AccommodationRecord(
                                name=name,
                                lat=float(lat),
                                lng=float(lng),
                                source="trivago",
                                source_id=item.get("@id") or item.get("url"),
                                source_url=item.get("url"),
                                type=classify_type(item.get("@type", "")),
                                address=item.get("address", {}).get("streetAddress"),
                                city=item.get("address", {}).get("addressLocality"),
                                rating=float(agg["ratingValue"]) if agg.get("ratingValue") else None,
                                review_count=int(agg["reviewCount"]) if agg.get("reviewCount") else None,
                            )
                            records.append(record)
                            logger.info(f"  + {record.name} @ {record.lat:.4f},{record.lng:.4f}")
                    except (json.JSONDecodeError, KeyError, TypeError):
                        continue
            except Exception as e:
                logger.warning(f"Trivago HTTP error for '{query}': {e}")

            await asyncio.sleep(2)

    logger.info(f"Trivago scrape complete: {len(records)} records")
    return records


async def scrape_trivago(mcp_results: list | None = None) -> List[AccommodationRecord]:
    """
    Main entry point. If mcp_results are provided (from Claude Code MCP tool),
    parse them; otherwise fall back to HTTP scraping.
    """
    if mcp_results:
        return _parse_mcp_results(mcp_results)
    return await scrape_trivago_http()


def _parse_mcp_results(results: list) -> List[AccommodationRecord]:
    """Parse results from Trivago MCP tool into AccommodationRecords."""
    records = []
    for item in results:
        try:
            # Trivago MCP result structure
            lat = item.get("geoCode", {}).get("latitude") or item.get("lat")
            lng = item.get("geoCode", {}).get("longitude") or item.get("lng") or item.get("lon")
            if not lat or not lng:
                continue

            price = item.get("cheapestOffer", {}).get("price") or item.get("price")
            currency = item.get("cheapestOffer", {}).get("currency", "EUR") or "EUR"

            record = AccommodationRecord(
                name=item.get("name", ""),
                lat=float(lat),
                lng=float(lng),
                source="trivago",
                source_id=str(item.get("itemId") or item.get("id", "")),
                source_url=item.get("dealUrl") or item.get("url"),
                type=classify_type(item.get("accommodationType", "") or item.get("propertyType", "")),
                address=item.get("address") or item.get("location", {}).get("address"),
                city=item.get("city") or item.get("location", {}).get("city"),
                stars=item.get("stars"),
                rating=item.get("rating") or item.get("reviewScore"),
                review_count=item.get("reviewCount"),
                price_total=float(price) if price else None,
                currency=currency,
                beds_in_room=1,
            )
            records.append(record)
        except (KeyError, TypeError, ValueError) as e:
            logger.debug(f"Error parsing MCP result: {e}")
    return records
