"""
Patient endpoints
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

router = APIRouter()


class PatientResponse(BaseModel):
    """Patient response schema"""
    id: UUID
    curp_hash: str
    date_of_birth: Optional[str] = None
    gender: Optional[str] = None
    created_at: Optional[str] = None
    
    class Config:
        from_attributes = True


@router.get("/", response_model=List[dict])
async def get_patients(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get list of patients
    
    Note: This is a base implementation. In production, you should:
    - Add proper filtering and search
    - Implement pagination
    - Add role-based access control
    - Add data encryption/decryption for PII
    """
    query = text("""
        SELECT id, curp_hash, date_of_birth, gender, created_at
        FROM patients
        ORDER BY created_at DESC
        LIMIT :limit OFFSET :skip
    """)
    
    result = db.execute(query, {"limit": limit, "skip": skip})
    patients = []
    for row in result:
        patients.append({
            "id": str(row[0]),
            "curp_hash": row[1],
            "date_of_birth": str(row[2]) if row[2] else None,
            "gender": row[3],
            "created_at": str(row[4]) if row[4] else None
        })
    
    return patients


@router.get("/{patient_id}", response_model=dict)
async def get_patient(
    patient_id: UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get patient by ID
    
    Note: PII data is encrypted and should be decrypted in production
    """
    query = text("""
        SELECT 
            p.id,
            p.curp_hash,
            p.date_of_birth,
            p.gender,
            p.created_at,
            pp.address_id
        FROM patients p
        LEFT JOIN patient_pii pp ON p.id = pp.patient_id
        WHERE p.id = :patient_id
    """)
    
    result = db.execute(query, {"patient_id": patient_id})
    row = result.fetchone()
    
    if not row:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Patient not found"
        )
    
    return {
        "id": str(row[0]),
        "curp_hash": row[1],
        "date_of_birth": str(row[2]) if row[2] else None,
        "gender": row[3],
        "created_at": str(row[4]) if row[4] else None,
        "address_id": str(row[5]) if row[5] else None
    }


@router.get("/{patient_id}/clinical-history", response_model=dict)
async def get_patient_clinical_history(
    patient_id: UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get patient clinical history"""
    # Get clinical history
    history_query = text("""
        SELECT id, status, opened_at, closed_at
        FROM clinical_histories
        WHERE patient_id = :patient_id
        ORDER BY opened_at DESC
        LIMIT 1
    """)
    
    history_result = db.execute(history_query, {"patient_id": patient_id})
    history_row = history_result.fetchone()
    
    if not history_row:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Clinical history not found"
        )
    
    history_id = history_row[0]
    
    # Get allergies
    allergies_query = text("""
        SELECT id, substance_code_id, reaction, severity, status
        FROM patient_allergies
        WHERE clinical_history_id = :history_id
    """)
    
    allergies_result = db.execute(allergies_query, {"history_id": history_id})
    allergies = [
        {
            "id": str(row[0]),
            "substance_code_id": str(row[1]) if row[1] else None,
            "reaction": row[2],
            "severity": row[3],
            "status": row[4]
        }
        for row in allergies_result
    ]
    
    # Get conditions
    conditions_query = text("""
        SELECT id, code_id, onset_date, verification_status
        FROM patient_conditions
        WHERE clinical_history_id = :history_id
    """)
    
    conditions_result = db.execute(conditions_query, {"history_id": history_id})
    conditions = [
        {
            "id": str(row[0]),
            "code_id": str(row[1]) if row[1] else None,
            "onset_date": str(row[2]) if row[2] else None,
            "verification_status": row[3]
        }
        for row in conditions_result
    ]
    
    # Get medications
    medications_query = text("""
        SELECT id, medication_code_id, dose, frequency, medication_status
        FROM patient_medications
        WHERE clinical_history_id = :history_id
    """)
    
    medications_result = db.execute(medications_query, {"history_id": history_id})
    medications = [
        {
            "id": str(row[0]),
            "medication_code_id": str(row[1]) if row[1] else None,
            "dose": row[2],
            "frequency": row[3],
            "medication_status": row[4]
        }
        for row in medications_result
    ]
    
    return {
        "clinical_history": {
            "id": str(history_id),
            "status": history_row[1],
            "opened_at": str(history_row[2]) if history_row[2] else None,
            "closed_at": str(history_row[3]) if history_row[3] else None
        },
        "allergies": allergies,
        "conditions": conditions,
        "medications": medications
    }

