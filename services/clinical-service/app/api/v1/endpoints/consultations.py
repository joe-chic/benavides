"""
Consultation endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import text
from app.core.database import get_db
from app.api.v1.endpoints.auth import get_current_user
from app.models.user import User
from typing import List, Optional
from uuid import UUID
from pydantic import BaseModel
from datetime import datetime

router = APIRouter()


class ConsultationCreate(BaseModel):
    """Consultation creation schema"""
    patient_id: UUID
    motivo: Optional[str] = None
    diagnostico: Optional[str] = None
    indicaciones: Optional[str] = None


class ConsultationResponse(BaseModel):
    """Consultation response schema"""
    id: UUID
    patient_id: UUID
    author_id: Optional[UUID] = None
    motivo: Optional[str] = None
    diagnostico: Optional[str] = None
    indicaciones: Optional[str] = None
    signed: Optional[bool] = None
    created_at: Optional[str] = None


@router.get("/", response_model=List[dict])
async def get_consultations(
    skip: int = 0,
    limit: int = 100,
    patient_id: Optional[UUID] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get list of consultations"""
    if patient_id:
        query = text("""
            SELECT id, patient_id, author_id, motivo, diagnostico, indicaciones, signed, created_at
            FROM consultations
            WHERE patient_id = :patient_id
            ORDER BY created_at DESC
            LIMIT :limit OFFSET :skip
        """)
        result = db.execute(query, {"patient_id": patient_id, "limit": limit, "skip": skip})
    else:
        query = text("""
            SELECT id, patient_id, author_id, motivo, diagnostico, indicaciones, signed, created_at
            FROM consultations
            ORDER BY created_at DESC
            LIMIT :limit OFFSET :skip
        """)
        result = db.execute(query, {"limit": limit, "skip": skip})
    
    consultations = []
    for row in result:
        consultations.append({
            "id": str(row[0]),
            "patient_id": str(row[1]),
            "author_id": str(row[2]) if row[2] else None,
            "motivo": row[3],
            "diagnostico": row[4],
            "indicaciones": row[5],
            "signed": row[6],
            "created_at": str(row[7]) if row[7] else None
        })
    
    return consultations


@router.get("/{consultation_id}", response_model=dict)
async def get_consultation(
    consultation_id: UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get consultation by ID"""
    query = text("""
        SELECT id, patient_id, author_id, motivo, diagnostico, indicaciones, signed, created_at, signed_at
        FROM consultations
        WHERE id = :consultation_id
    """)
    
    result = db.execute(query, {"consultation_id": consultation_id})
    row = result.fetchone()
    
    if not row:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Consultation not found"
        )
    
    return {
        "id": str(row[0]),
        "patient_id": str(row[1]),
        "author_id": str(row[2]) if row[2] else None,
        "motivo": row[3],
        "diagnostico": row[4],
        "indicaciones": row[5],
        "signed": row[6],
        "created_at": str(row[7]) if row[7] else None,
        "signed_at": str(row[8]) if row[8] else None
    }


@router.post("/", response_model=dict, status_code=status.HTTP_201_CREATED)
async def create_consultation(
    consultation: ConsultationCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Create a new consultation
    
    Note: This is a base implementation. In production, you should:
    - Validate user has permission to create consultations (medic role)
    - Add proper validation
    - Generate signature hash
    - Add audit logging
    """
    from uuid import uuid4
    
    consultation_id = uuid4()
    now = datetime.utcnow()
    
    query = text("""
        INSERT INTO consultations (id, patient_id, author_id, motivo, diagnostico, indicaciones, signed, created_at, created_by)
        VALUES (:id, :patient_id, :author_id, :motivo, :diagnostico, :indicaciones, :signed, :created_at, :created_by)
        RETURNING id, patient_id, author_id, motivo, diagnostico, indicaciones, signed, created_at
    """)
    
    result = db.execute(query, {
        "id": consultation_id,
        "patient_id": consultation.patient_id,
        "author_id": current_user.id,
        "motivo": consultation.motivo,
        "diagnostico": consultation.diagnostico,
        "indicaciones": consultation.indicaciones,
        "signed": False,
        "created_at": now,
        "created_by": current_user.id
    })
    
    db.commit()
    
    row = result.fetchone()
    return {
        "id": str(row[0]),
        "patient_id": str(row[1]),
        "author_id": str(row[2]) if row[2] else None,
        "motivo": row[3],
        "diagnostico": row[4],
        "indicaciones": row[5],
        "signed": row[6],
        "created_at": str(row[7]) if row[7] else None
    }

