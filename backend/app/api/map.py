from fastapi import APIRouter, Depends, Query
from sqlalchemy import text
from sqlalchemy.orm import Session
from typing import Optional
import json
from app.database import get_db

router = APIRouter(prefix="/map", tags=["map"])

GEOJSON_QUERY = """
SELECT
    a.id, a.name, a.type, a.city, a.lat, a.lng,
    a.stars, a.rating, a.source, a.source_url,
    p.price_per_bed, p.currency,
    s.breakfast_included, s.spa_wellness, s.pool, s.wine_tasting, s.pet_friendly
FROM accommodations a
LEFT JOIN LATERAL (
    SELECT price_per_bed, currency FROM prices
    WHERE accommodation_id = a.id ORDER BY date_collected DESC LIMIT 1
) p ON TRUE
LEFT JOIN services s ON s.accommodation_id = a.id
WHERE (:type IS NULL OR a.type = :type)
  AND (:min_price IS NULL OR p.price_per_bed >= :min_price)
  AND (:max_price IS NULL OR p.price_per_bed <= :max_price)
"""


@router.get("/geojson")
def get_geojson(
    type: Optional[str] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    db: Session = Depends(get_db),
):
    rows = db.execute(
        text(GEOJSON_QUERY),
        {"type": type, "min_price": min_price, "max_price": max_price},
    ).mappings().all()

    features = []
    for r in rows:
        features.append({
            "type": "Feature",
            "geometry": {"type": "Point", "coordinates": [r["lng"], r["lat"]]},
            "properties": {
                "id": r["id"],
                "name": r["name"],
                "type": r["type"],
                "city": r["city"],
                "stars": r["stars"],
                "rating": float(r["rating"]) if r["rating"] else None,
                "source": r["source"],
                "source_url": r["source_url"],
                "price_per_bed": float(r["price_per_bed"]) if r["price_per_bed"] else None,
                "currency": r["currency"],
                "breakfast_included": r["breakfast_included"],
                "spa_wellness": r["spa_wellness"],
                "pool": r["pool"],
                "wine_tasting": r["wine_tasting"],
                "pet_friendly": r["pet_friendly"],
            },
        })

    return {"type": "FeatureCollection", "features": features}


@router.get("/heatmap")
def get_heatmap(db: Session = Depends(get_db)):
    """Returns [lat, lng, intensity] array for Leaflet.heat"""
    rows = db.execute(text("""
        SELECT a.lat, a.lng, p.price_per_bed
        FROM accommodations a
        LEFT JOIN LATERAL (
            SELECT price_per_bed FROM prices
            WHERE accommodation_id = a.id ORDER BY date_collected DESC LIMIT 1
        ) p ON TRUE
        WHERE p.price_per_bed IS NOT NULL
    """)).all()
    # Normalise intensity 0–1 based on price_per_bed
    prices = [float(r[2]) for r in rows]
    if not prices:
        return []
    max_p = max(prices)
    return [[float(r[0]), float(r[1]), float(r[2]) / max_p] for r in rows]
