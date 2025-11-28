"""
API v1 router
"""
from fastapi import APIRouter
from app.api.v1.endpoints import auth, patients, consultations, prescriptions

api_router = APIRouter()

# Include endpoint routers
api_router.include_router(auth.router, prefix="/auth", tags=["authentication"])
api_router.include_router(patients.router, prefix="/patients", tags=["patients"])
api_router.include_router(consultations.router, prefix="/consultations", tags=["consultations"])
api_router.include_router(prescriptions.router, prefix="/prescriptions", tags=["prescriptions"])

