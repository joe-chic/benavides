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


@router.get("/{patient_id}/personal-info", response_model=dict)
async def get_patient_personal_info(
    patient_id: UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieve denormalized patient personal information (demo-friendly, no PII decryption)
    """
    query = text("""
        SELECT
            p.id,
            convert_from(pp.first_name_enc, 'UTF8') AS first_name,
            convert_from(pp.first_surname_enc, 'UTF8') AS first_surname,
            convert_from(pp.second_surname_enc, 'UTF8') AS second_surname,
            convert_from(pp.email_enc, 'UTF8') AS email,
            convert_from(pp.phone_enc, 'UTF8') AS phone,
            p.date_of_birth,
            p.gender,
            a.street_name,
            a.street_number,
            n.name AS neighborhood,
            c.name AS city,
            s.name AS state,
            pc.code AS postal_code,
            co.name AS country
        FROM patients p
        LEFT JOIN patient_pii pp ON p.id = pp.patient_id
        LEFT JOIN addresses a ON pp.address_id = a.id_address
        LEFT JOIN neighborhoods n ON a.id_neighborhood = n.id_neighborhood
        LEFT JOIN cities c ON n.id_city = c.id_city
        LEFT JOIN admin_subdivisions s ON c.id_area = s.id_area
        LEFT JOIN countries co ON s.id_country = co.id_country
        LEFT JOIN postal_codes pc ON a.id_postal_code = pc.id_postal_codes
        WHERE p.id = :patient_id
    """)

    result = db.execute(query, {"patient_id": patient_id})
    row = result.fetchone()

    if not row:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Patient personal information not found"
        )

    first_name = row[1] or ""
    first_surname = row[2] or ""
    second_surname = row[3] or ""

    full_name = " ".join(
        [part for part in [first_name, first_surname, second_surname] if part]
    ).strip() or None

    street = row[8] or ""
    number = row[9] or ""
    neighborhood = row[10] or ""
    address_line = ", ".join(
        [part for part in [
            f"{street} {number}".strip(),
            neighborhood
        ] if part]
    ) or None

    return {
        "patient_id": str(row[0]),
        "first_name": first_name or None,
        "first_surname": first_surname or None,
        "second_surname": second_surname or None,
        "full_name": full_name,
        "email": row[4],
        "phone": row[5],
        "date_of_birth": str(row[6]) if row[6] else None,
        "gender": row[7],
        "address_line": address_line,
        "city": row[11],
        "state": row[12],
        "postal_code": row[13],
        "country": row[14]
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
        SELECT pa.id,
               pa.substance_code_id,
               cc.display,
               pa.reaction,
               pa.severity,
               pa.status,
               pa.recorded_at
        FROM patient_allergies pa
        LEFT JOIN clinical_codes cc ON pa.substance_code_id = cc.id
        WHERE pa.clinical_history_id = :history_id
        ORDER BY pa.recorded_at DESC
    """)
    
    allergies_result = db.execute(allergies_query, {"history_id": history_id})
    allergies = [
        {
            "id": str(row[0]),
            "substance_code_id": str(row[1]) if row[1] else None,
            "substance_display": row[2],
            "reaction": row[3],
            "severity": row[4],
            "status": row[5],
            "recorded_at": str(row[6]) if row[6] else None
        }
        for row in allergies_result
    ]
    
    # Get conditions
    conditions_query = text("""
        SELECT pc.id,
               pc.code_id,
               cc.display,
               pc.onset_date,
               pc.verification_status,
               pc.recorded_at
        FROM patient_conditions pc
        LEFT JOIN clinical_codes cc ON pc.code_id = cc.id
        WHERE pc.clinical_history_id = :history_id
        ORDER BY pc.recorded_at DESC
    """)
    
    conditions_result = db.execute(conditions_query, {"history_id": history_id})
    conditions = [
        {
            "id": str(row[0]),
            "code_id": str(row[1]) if row[1] else None,
            "code_display": row[2],
            "onset_date": str(row[3]) if row[3] else None,
            "verification_status": row[4],
            "recorded_at": str(row[5]) if row[5] else None
        }
        for row in conditions_result
    ]
    
    # Get procedures
    procedures_query = text("""
        SELECT pp.id,
               pp.procedure_code_id,
               cc.display,
               pp.performed_on,
               pp.facility,
               pp.note,
               pp.recorded_at
        FROM patient_procedures pp
        LEFT JOIN clinical_codes cc ON pp.procedure_code_id = cc.id
        WHERE pp.clinical_history_id = :history_id
        ORDER BY COALESCE(pp.performed_on, pp.recorded_at) DESC
    """)
    procedures_result = db.execute(procedures_query, {"history_id": history_id})
    procedures = [
        {
            "id": str(row[0]),
            "procedure_code_id": str(row[1]) if row[1] else None,
            "procedure_display": row[2],
            "performed_on": str(row[3]) if row[3] else None,
            "facility": row[4],
            "note": row[5],
            "recorded_at": str(row[6]) if row[6] else None
        }
        for row in procedures_result
    ]

    # Get family history
    family_query = text("""
        SELECT fh.id,
               fh.relationship_type,
               fh.condition_code_id,
               cc.display,
               fh.note,
               fh.verification_status,
               fh.relative_age_of_consent,
               fh.relative_is_deceased,
               fh.recorded_at
        FROM family_history fh
        LEFT JOIN clinical_codes cc ON fh.condition_code_id = cc.id
        WHERE fh.clinical_history_id = :history_id
        ORDER BY fh.recorded_at DESC
    """)
    family_result = db.execute(family_query, {"history_id": history_id})
    family_history = [
        {
            "id": str(row[0]),
            "relationship_type": row[1],
            "condition_code_id": str(row[2]) if row[2] else None,
            "condition_display": row[3],
            "note": row[4],
            "verification_status": row[5],
            "relative_age_of_consent": row[6],
            "relative_is_deceased": row[7],
            "recorded_at": str(row[8]) if row[8] else None
        }
        for row in family_result
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
        "procedures": procedures,
        "family_history": family_history
    }

