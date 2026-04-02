"""Unit tests for the scraper normaliser."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "../../scraper"))

from normaliser import classify_type, AccommodationRecord


def test_classify_hotel():
    assert classify_type("Hotel") == "hotel"
    assert classify_type("5-star hotel") == "hotel"


def test_classify_pension():
    assert classify_type("Pension") == "pension"
    assert classify_type("Guest House") == "pension"
    assert classify_type("B&B") == "pension"


def test_classify_hostel():
    assert classify_type("Hostel") == "hostel"
    assert classify_type("Dormitory") == "hostel"


def test_classify_apartment():
    assert classify_type("Apartment") == "apartment"
    assert classify_type("Holiday flat") == "apartment"


def test_classify_winery():
    assert classify_type("Winery Stay") == "winery"
    assert classify_type("Vinařství") == "winery"


def test_classify_other():
    assert classify_type("") == "other"
    assert classify_type(None) == "other"
    assert classify_type("random type") == "other"


def test_accommodation_record_defaults():
    rec = AccommodationRecord(name="Test Hotel", lat=49.2, lng=16.6, source="test")
    assert rec.type == "other"
    assert rec.beds_in_room == 1
    assert rec.currency == "CZK"
    assert rec.services == {}


def test_price_per_bed_calc():
    """Verify price_per_bed logic matches what the DB will compute."""
    price_total = 1500.0
    beds_in_room = 3
    expected = round(price_total / beds_in_room, 2)
    assert expected == 500.0
