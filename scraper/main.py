"""
AccomMap scraper entry point.
Runs all scrapers and persists results to PostgreSQL.
"""
import asyncio
import logging
import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(name)s] %(levelname)s: %(message)s",
)
logger = logging.getLogger("accommap.scraper")


def get_connection():
    return psycopg2.connect(os.environ["DATABASE_URL"])


async def run_all_scrapers():
    from booking.scraper import scrape_booking
    from google.scraper import scrape_google
    from trivago.scraper import scrape_trivago
    from normaliser import upsert_record

    conn = get_connection()
    total = 0

    # 1. Trivago
    logger.info("=== Starting Trivago scraper ===")
    try:
        trivago_records = await scrape_trivago()
        for rec in trivago_records:
            try:
                upsert_record(rec, conn)
                total += 1
            except Exception as e:
                logger.warning(f"Failed to upsert {rec.name}: {e}")
                conn.rollback()
        logger.info(f"Trivago: {len(trivago_records)} records processed")
    except Exception as e:
        logger.error(f"Trivago scraper failed: {e}")

    # 2. Google Places
    api_key = os.getenv("GOOGLE_PLACES_API_KEY", "")
    if api_key:
        logger.info("=== Starting Google Places scraper ===")
        try:
            google_records = await scrape_google(api_key)
            for rec in google_records:
                try:
                    upsert_record(rec, conn)
                    total += 1
                except Exception as e:
                    logger.warning(f"Failed to upsert {rec.name}: {e}")
                    conn.rollback()
            logger.info(f"Google: {len(google_records)} records processed")
        except Exception as e:
            logger.error(f"Google scraper failed: {e}")
    else:
        logger.warning("GOOGLE_PLACES_API_KEY not set — skipping Google Places")

    # 3. Booking.com
    logger.info("=== Starting Booking.com scraper ===")
    try:
        booking_records = await scrape_booking(max_pages=20)
        for rec in booking_records:
            try:
                upsert_record(rec, conn)
                total += 1
            except Exception as e:
                logger.warning(f"Failed to upsert {rec.name}: {e}")
                conn.rollback()
        logger.info(f"Booking: {len(booking_records)} records processed")
    except Exception as e:
        logger.error(f"Booking scraper failed: {e}")

    conn.close()
    logger.info(f"=== Scraping complete. Total records: {total} ===")


if __name__ == "__main__":
    asyncio.run(run_all_scrapers())
