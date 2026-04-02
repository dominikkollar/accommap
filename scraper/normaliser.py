"""
Shared data normalisation and DB upsert logic for all scrapers.
"""
from dataclasses import dataclass, field
from typing import Optional, List
from decimal import Decimal
import logging

logger = logging.getLogger(__name__)

SOUTH_MORAVIA_CITIES = {
    "brno", "znojmo", "mikulov", "lednice", "valtice", "hodonín", "břeclav",
    "kyjov", "hustopeče", "moravský krumlov", "uherské hradiště", "veselí nad moravou",
    "strážnice", "podivín", "velké pavlovice", "krumvíř", "bořetice", "pavlov",
    "dolní věstonice", "klentnice", "perná", "kobylí", "čejkovice", "mutěnice",
}


@dataclass
class AccommodationRecord:
    name: str
    lat: float
    lng: float
    source: str
    type: str = "other"
    address: Optional[str] = None
    city: Optional[str] = None
    postal_code: Optional[str] = None
    stars: Optional[int] = None
    beds_total: Optional[int] = None
    rooms_total: Optional[int] = None
    rating: Optional[float] = None
    review_count: Optional[int] = None
    source_id: Optional[str] = None
    source_url: Optional[str] = None
    price_total: Optional[float] = None
    beds_in_room: int = 1
    currency: str = "CZK"
    room_type: Optional[str] = None
    services: dict = field(default_factory=dict)


def classify_type(raw_type: str) -> str:
    """Map raw type string to canonical accommodation type."""
    raw = raw_type.lower() if raw_type else ""
    if any(k in raw for k in ("hotel",)):
        return "hotel"
    if any(k in raw for k in ("pension", "penzion", "guest house", "guesthouse", "b&b")):
        return "pension"
    if any(k in raw for k in ("hostel", "dormitory")):
        return "hostel"
    if any(k in raw for k in ("apartment", "apartmán", "flat", "studio")):
        return "apartment"
    if any(k in raw for k in ("agro", "farm", "statek", "dvůr")):
        return "agro"
    if any(k in raw for k in ("wellness", "spa", "resort")):
        return "wellness"
    if any(k in raw for k in ("camping", "camp", "kemp", "glamping")):
        return "camping"
    if any(k in raw for k in ("wine", "víno", "vinařství", "winery", "sklep")):
        return "winery"
    return "other"


def upsert_record(record: AccommodationRecord, conn) -> int:
    """Upsert an AccommodationRecord into the DB. Returns accommodation id."""
    cur = conn.cursor()

    cur.execute("""
        INSERT INTO accommodations
            (name, type, address, city, postal_code, lat, lng,
             stars, beds_total, rooms_total, rating, review_count,
             source, source_id, source_url)
        VALUES
            (%(name)s, %(type)s, %(address)s, %(city)s, %(postal_code)s,
             %(lat)s, %(lng)s, %(stars)s, %(beds_total)s, %(rooms_total)s,
             %(rating)s, %(review_count)s, %(source)s, %(source_id)s, %(source_url)s)
        ON CONFLICT (source, source_id) DO UPDATE SET
            name = EXCLUDED.name,
            type = EXCLUDED.type,
            address = EXCLUDED.address,
            city = EXCLUDED.city,
            lat = EXCLUDED.lat,
            lng = EXCLUDED.lng,
            stars = EXCLUDED.stars,
            beds_total = EXCLUDED.beds_total,
            rating = EXCLUDED.rating,
            review_count = EXCLUDED.review_count,
            source_url = EXCLUDED.source_url,
            scraped_at = NOW()
        RETURNING id
    """, {
        "name": record.name, "type": record.type,
        "address": record.address, "city": record.city,
        "postal_code": record.postal_code,
        "lat": record.lat, "lng": record.lng,
        "stars": record.stars, "beds_total": record.beds_total,
        "rooms_total": record.rooms_total,
        "rating": record.rating, "review_count": record.review_count,
        "source": record.source, "source_id": record.source_id,
        "source_url": record.source_url,
    })
    acc_id = cur.fetchone()[0]

    if record.price_total is not None:
        price_per_bed = round(record.price_total / max(record.beds_in_room, 1), 2)
        cur.execute("""
            INSERT INTO prices (accommodation_id, price_total, beds_in_room, price_per_bed, currency, room_type)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (acc_id, record.price_total, record.beds_in_room, price_per_bed, record.currency, record.room_type))

    if record.services:
        cols = ", ".join(record.services.keys())
        placeholders = ", ".join([f"%({k})s" for k in record.services])
        cur.execute(f"""
            INSERT INTO services (accommodation_id, {cols})
            VALUES (%(accommodation_id)s, {placeholders})
            ON CONFLICT (accommodation_id) DO UPDATE SET
                {", ".join(f"{k} = EXCLUDED.{k}" for k in record.services)}
        """, {"accommodation_id": acc_id, **record.services})

    conn.commit()
    return acc_id
