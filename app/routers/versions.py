from fastapi import APIRouter
from pydantic import BaseModel

from app.services.loader import get_all_versions


class Version(BaseModel):
    name: str
    version: str


router = APIRouter(prefix="/versions", tags=["versions"])


@router.get("", response_model=list[Version])
def list_versions():
    return get_all_versions()
