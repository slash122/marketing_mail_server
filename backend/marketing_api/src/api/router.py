from fastapi import APIRouter
from src.api.endpoints import accounts, senders, test, users

router = APIRouter()
router.include_router(test.router, prefix="/test", tags=["misc"])
router.include_router(users.router, tags=["users"])
router.include_router(accounts.router, tags=["accounts"])
router.include_router(senders.router, tags=["senders"])
