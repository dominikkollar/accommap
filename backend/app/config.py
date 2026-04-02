from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    database_url: str = "postgresql://accommap:accommap_secret@localhost:5432/accommap"
    google_places_api_key: str = ""
    debug: bool = False

    class Config:
        env_file = ".env"


settings = Settings()
