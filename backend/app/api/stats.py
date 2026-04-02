from fastapi import APIRouter, Depends
from sqlalchemy import text
from sqlalchemy.orm import Session
from app.database import get_db

router = APIRouter(prefix="/stats", tags=["stats"])


@router.get("/summary")
def get_summary(db: Session = Depends(get_db)):
    row = db.execute(text("""
        SELECT
            COUNT(DISTINCT a.id) AS total_accommodations,
            COUNT(DISTINCT p.id) AS total_prices,
            ROUND(AVG(p.price_per_bed)::numeric, 2) AS avg_price_per_bed,
            ROUND(MIN(p.price_per_bed)::numeric, 2) AS min_price_per_bed,
            ROUND(MAX(p.price_per_bed)::numeric, 2) AS max_price_per_bed
        FROM accommodations a
        LEFT JOIN prices p ON p.accommodation_id = a.id
    """)).mappings().first()
    return dict(row)


@router.get("/by-type")
def stats_by_type(db: Session = Depends(get_db)):
    rows = db.execute(text("""
        SELECT
            a.type,
            COUNT(DISTINCT a.id) AS count,
            ROUND(AVG(p.price_per_bed)::numeric, 2) AS avg_price_per_bed,
            ROUND(MIN(p.price_per_bed)::numeric, 2) AS min_price_per_bed,
            ROUND(MAX(p.price_per_bed)::numeric, 2) AS max_price_per_bed
        FROM accommodations a
        LEFT JOIN LATERAL (
            SELECT price_per_bed FROM prices
            WHERE accommodation_id = a.id ORDER BY date_collected DESC LIMIT 1
        ) p ON TRUE
        GROUP BY a.type
        ORDER BY avg_price_per_bed DESC NULLS LAST
    """)).mappings().all()
    return [dict(r) for r in rows]


@router.get("/by-city")
def stats_by_city(db: Session = Depends(get_db)):
    rows = db.execute(text("""
        SELECT
            a.city,
            COUNT(DISTINCT a.id) AS count,
            ROUND(AVG(p.price_per_bed)::numeric, 2) AS avg_price_per_bed
        FROM accommodations a
        LEFT JOIN LATERAL (
            SELECT price_per_bed FROM prices
            WHERE accommodation_id = a.id ORDER BY date_collected DESC LIMIT 1
        ) p ON TRUE
        WHERE a.city IS NOT NULL
        GROUP BY a.city
        ORDER BY count DESC
        LIMIT 20
    """)).mappings().all()
    return [dict(r) for r in rows]


@router.get("/filters")
def get_filter_options(db: Session = Depends(get_db)):
    types = db.execute(text("SELECT DISTINCT type FROM accommodations WHERE type IS NOT NULL ORDER BY type")).scalars().all()
    cities = db.execute(text("SELECT DISTINCT city FROM accommodations WHERE city IS NOT NULL ORDER BY city")).scalars().all()
    return {"types": list(types), "cities": list(cities)}
