from fastapi import APIRouter
from pydantic import BaseModel

from app.services.aws_client import BASE_URL, get_all_pricing_urls
from app.services.loader import load_known_versions, load_pricing_data
from app.services.schema_builder import generate_missing_schemas


class PricingUrl(BaseModel):
    type: str
    name: str
    region: str
    csv_url: str
    publication_date: str


class LoadRequest(BaseModel):
    name: str | None = None


class LoadResult(BaseModel):
    loaded: int
    services: int
    elapsed_seconds: float


router = APIRouter(prefix="/pricing", tags=["pricing"])


@router.get("/urls", response_model=list[PricingUrl])
def list_pricing_urls():
    known_versions = load_known_versions()
    all_urls = get_all_pricing_urls(known_versions)
    generate_missing_schemas(all_urls)
    return [
        PricingUrl(
            type=row["type"],
            name=row["name"],
            region=row["region"],
            csv_url=f"{BASE_URL}{row['csv_url']}",
            publication_date=row["publication_date"],
        )
        for row in all_urls
    ]


@router.post("/load", response_model=LoadResult)
def trigger_load(body: LoadRequest = None):
    name_filter = body.name if body else None
    result = load_pricing_data(name_filter=name_filter)
    return LoadResult(**result)
