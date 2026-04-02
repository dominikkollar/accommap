from pydantic import BaseModel
from typing import Optional, List
from datetime import date


class ListingResponse(BaseModel):
    id: int
    name: str
    type: Optional[str]
    address: Optional[str]
    city: Optional[str]
    lat: float
    lng: float
    stars: Optional[int]
    beds_total: Optional[int]
    rating: Optional[float]
    review_count: Optional[int]
    source: str
    source_url: Optional[str]
    price_per_bed: Optional[float]
    price_total: Optional[float]
    beds_in_room: Optional[int]
    currency: Optional[str]
    date_collected: Optional[date]
    parking_free: Optional[bool]
    parking_paid: Optional[bool]
    breakfast_included: Optional[bool]
    restaurant: Optional[bool]
    spa_wellness: Optional[bool]
    pool: Optional[bool]
    bike_rental: Optional[bool]
    wine_tasting: Optional[bool]
    pet_friendly: Optional[bool]
    conference_rooms: Optional[bool]
    ev_charging: Optional[bool]
    wifi_free: Optional[bool]
    air_conditioning: Optional[bool]

    class Config:
        from_attributes = True


class ListingsPage(BaseModel):
    total: int
    items: List[ListingResponse]
