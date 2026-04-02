from fastapi import APIRouter, Depends, Query
from sqlalchemy import text
from sqlalchemy.orm import Session
from typing import Optional
from app.database import get_db
from app.schemas import ListingResponse, ListingsPage

router = APIRouter(prefix="/listings", tags=["listings"])

LISTING_QUERY = """
SELECT
    a.id, a.name, a.type, a.address, a.city, a.lat, a.lng,
    a.stars, a.beds_total, a.rating, a.review_count,
    a.source, a.source_url,
    p.price_per_bed, p.price_total, p.beds_in_room, p.currency, p.date_collected,
    s.parking_free, s.parking_paid, s.breakfast_included, s.restaurant,
    s.spa_wellness, s.pool, s.bike_rental, s.wine_tasting, s.pet_friendly,
    s.conference_rooms, s.ev_charging, s.wifi_free, s.air_conditioning
FROM accommodations a
LEFT JOIN LATERAL (
    SELECT * FROM prices WHERE accommodation_id = a.id ORDER BY date_collected DESC LIMIT 1
) p ON TRUE
LEFT JOIN services s ON s.accommodation_id = a.id
WHERE 1=1
  AND (:type IS NULL OR a.type = :type)
  AND (:city IS NULL OR lower(a.city) LIKE lower(:city))
  AND (:min_price IS NULL OR p.price_per_bed >= :min_price)
  AND (:max_price IS NULL OR p.price_per_bed <= :max_price)
  AND (:min_stars IS NULL OR a.stars >= :min_stars)
  AND (:source IS NULL OR a.source = :source)
  AND (:breakfast IS NULL OR s.breakfast_included = :breakfast)
  AND (:pool IS NULL OR s.pool = :pool)
  AND (:spa IS NULL OR s.spa_wellness = :spa)
  AND (:parking IS NULL OR (s.parking_free = TRUE OR s.parking_paid = TRUE))
ORDER BY p.price_per_bed ASC NULLS LAST
LIMIT :limit OFFSET :offset
"""

COUNT_QUERY = """
SELECT COUNT(*)
FROM accommodations a
LEFT JOIN LATERAL (
    SELECT * FROM prices WHERE accommodation_id = a.id ORDER BY date_collected DESC LIMIT 1
) p ON TRUE
LEFT JOIN services s ON s.accommodation_id = a.id
WHERE 1=1
  AND (:type IS NULL OR a.type = :type)
  AND (:city IS NULL OR lower(a.city) LIKE lower(:city))
  AND (:min_price IS NULL OR p.price_per_bed >= :min_price)
  AND (:max_price IS NULL OR p.price_per_bed <= :max_price)
  AND (:min_stars IS NULL OR a.stars >= :min_stars)
  AND (:source IS NULL OR a.source = :source)
  AND (:breakfast IS NULL OR s.breakfast_included = :breakfast)
  AND (:pool IS NULL OR s.pool = :pool)
  AND (:spa IS NULL OR s.spa_wellness = :spa)
  AND (:parking IS NULL OR (s.parking_free = TRUE OR s.parking_paid = TRUE))
"""


@router.get("", response_model=ListingsPage)
def get_listings(
    type: Optional[str] = None,
    city: Optional[str] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    min_stars: Optional[int] = None,
    source: Optional[str] = None,
    breakfast: Optional[bool] = None,
    pool: Optional[bool] = None,
    spa: Optional[bool] = None,
    parking: Optional[bool] = None,
    limit: int = Query(default=50, le=500),
    offset: int = Query(default=0, ge=0),
    db: Session = Depends(get_db),
):
    params = dict(
        type=type,
        city=f"%{city}%" if city else None,
        min_price=min_price,
        max_price=max_price,
        min_stars=min_stars,
        source=source,
        breakfast=breakfast,
        pool=pool,
        spa=spa,
        parking=parking,
        limit=limit,
        offset=offset,
    )
    rows = db.execute(text(LISTING_QUERY), params).mappings().all()
    total = db.execute(text(COUNT_QUERY), {k: v for k, v in params.items() if k not in ("limit", "offset")}).scalar()
    return {"total": total, "items": [dict(r) for r in rows]}


@router.get("/{listing_id}", response_model=ListingResponse)
def get_listing(listing_id: int, db: Session = Depends(get_db)):
    row = db.execute(
        text(LISTING_QUERY.replace("WHERE 1=1", "WHERE a.id = :id").replace("LIMIT :limit OFFSET :offset", "")),
        {"id": listing_id, "type": None, "city": None, "min_price": None, "max_price": None,
         "min_stars": None, "source": None, "breakfast": None, "pool": None, "spa": None, "parking": None},
    ).mappings().first()
    if not row:
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="Listing not found")
    return dict(row)
