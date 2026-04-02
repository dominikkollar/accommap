# Testing — AccomMap

## Test Strategy

| Layer | Framework | Type |
|---|---|---|
| Normaliser | pytest | Unit |
| Backend API | pytest + FastAPI TestClient | Integration |
| Scraper | pytest + Playwright | E2E (manual) |
| Frontend | Browser DevTools | Manual smoke test |

## Running Tests

```bash
# Install test dependencies
cd backend && pip install pytest pytest-asyncio httpx

# Run all tests
pytest backend/tests/ -v

# Run specific file
pytest backend/tests/test_normaliser.py -v
```

## Test Coverage Goals

- `normaliser.classify_type()` — 100% (all type strings)
- API endpoints — all 200/422/404 paths
- DB upsert — idempotency (run twice → same row count)

## Data Quality Checks

After each scrape run, verify:
```sql
-- No duplicate source+source_id pairs
SELECT source, source_id, COUNT(*) FROM accommodations GROUP BY 1,2 HAVING COUNT(*) > 1;

-- All price_per_bed values are positive
SELECT COUNT(*) FROM prices WHERE price_per_bed <= 0;

-- No listings outside South Moravia bounding box
SELECT COUNT(*) FROM accommodations
WHERE lat NOT BETWEEN 48.55 AND 49.65
   OR lng NOT BETWEEN 15.80 AND 17.90;
```
