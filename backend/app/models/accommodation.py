from sqlalchemy import Column, Integer, String, Float, Numeric, Boolean, Date, DateTime, SmallInteger, Text, ForeignKey, func
from sqlalchemy.orm import relationship
from geoalchemy2 import Geometry
from app.database import Base


class Accommodation(Base):
    __tablename__ = "accommodations"

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    type = Column(String(50))
    address = Column(Text)
    city = Column(String(100))
    postal_code = Column(String(20))
    lat = Column(Float, nullable=False)
    lng = Column(Float, nullable=False)
    geom = Column(Geometry("POINT", srid=4326))
    stars = Column(SmallInteger)
    beds_total = Column(Integer)
    rooms_total = Column(Integer)
    rating = Column(Numeric(3, 1))
    review_count = Column(Integer)
    source = Column(String(50), nullable=False)
    source_id = Column(String(255))
    source_url = Column(Text)
    scraped_at = Column(DateTime(timezone=True), server_default=func.now())

    prices = relationship("Price", back_populates="accommodation", cascade="all, delete-orphan")
    service = relationship("Service", back_populates="accommodation", uselist=False, cascade="all, delete-orphan")


class Price(Base):
    __tablename__ = "prices"

    id = Column(Integer, primary_key=True)
    accommodation_id = Column(Integer, ForeignKey("accommodations.id"), nullable=False)
    price_total = Column(Numeric(10, 2), nullable=False)
    beds_in_room = Column(Integer, default=1)
    price_per_bed = Column(Numeric(10, 2))
    currency = Column(String(3), default="CZK")
    date_collected = Column(Date, server_default=func.current_date())
    check_in = Column(Date)
    check_out = Column(Date)
    room_type = Column(String(100))

    accommodation = relationship("Accommodation", back_populates="prices")


class Service(Base):
    __tablename__ = "services"

    id = Column(Integer, primary_key=True)
    accommodation_id = Column(Integer, ForeignKey("accommodations.id"), nullable=False, unique=True)
    parking_free = Column(Boolean, default=False)
    parking_paid = Column(Boolean, default=False)
    breakfast_included = Column(Boolean, default=False)
    restaurant = Column(Boolean, default=False)
    spa_wellness = Column(Boolean, default=False)
    pool = Column(Boolean, default=False)
    bike_rental = Column(Boolean, default=False)
    wine_tasting = Column(Boolean, default=False)
    pet_friendly = Column(Boolean, default=False)
    conference_rooms = Column(Boolean, default=False)
    ev_charging = Column(Boolean, default=False)
    wifi_free = Column(Boolean, default=False)
    air_conditioning = Column(Boolean, default=False)

    accommodation = relationship("Accommodation", back_populates="service")
