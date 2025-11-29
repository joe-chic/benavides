"""
Prescription endpoints
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


class PrescriptionItemCreate(BaseModel):
    """Prescription item creation schema"""
    medication_name: str
    dose: Optional[str] = None
    form: Optional[str] = None
    frequency: Optional[str] = None
    duration: Optional[str] = None
    observations: Optional[str] = None


class PrescriptionCreate(BaseModel):
    """Prescription creation schema"""
    patient_id: UUID
    consultation_id: Optional[UUID] = None
    items: List[PrescriptionItemCreate]


@router.get("/", response_model=List[dict])
async def get_prescriptions(
    skip: int = 0,
    limit: int = 100,
    patient_id: Optional[UUID] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get list of prescriptions with medic name, item count, and status"""
    if patient_id:
        query = text("""
            SELECT 
                p.id, 
                p.prescription_code, 
                p.patient_id, 
                p.consultation_id, 
                p.signed_by, 
                p.signed_at, 
                p.created_at,
                u.display_name as medic_name,
                (SELECT COUNT(*) FROM prescription_items WHERE prescription_id = p.id) as item_count,
                CASE 
                    WHEN p.signed_by IS NULL THEN 'cancelada'
                    WHEN EXISTS (SELECT 1 FROM dispensations WHERE prescription_id = p.id AND status = 'dispensed') THEN 'dispensada'
                    WHEN p.created_at < NOW() - INTERVAL '30 days' THEN 'vencida'
                    ELSE 'vigente'
                END as status
            FROM prescriptions p
            LEFT JOIN users u ON p.signed_by = u.id
            WHERE p.patient_id = :patient_id
            ORDER BY p.created_at DESC
            LIMIT :limit OFFSET :skip
        """)
        result = db.execute(query, {"patient_id": patient_id, "limit": limit, "skip": skip})
    else:
        query = text("""
            SELECT 
                p.id, 
                p.prescription_code, 
                p.patient_id, 
                p.consultation_id, 
                p.signed_by, 
                p.signed_at, 
                p.created_at,
                u.display_name as medic_name,
                (SELECT COUNT(*) FROM prescription_items WHERE prescription_id = p.id) as item_count,
                CASE 
                    WHEN p.signed_by IS NULL THEN 'cancelada'
                    WHEN EXISTS (SELECT 1 FROM dispensations WHERE prescription_id = p.id AND status = 'dispensed') THEN 'dispensada'
                    WHEN p.created_at < NOW() - INTERVAL '30 days' THEN 'vencida'
                    ELSE 'vigente'
                END as status
            FROM prescriptions p
            LEFT JOIN users u ON p.signed_by = u.id
            ORDER BY p.created_at DESC
            LIMIT :limit OFFSET :skip
        """)
        result = db.execute(query, {"limit": limit, "skip": skip})
    
    prescriptions = []
    for row in result:
        # Calculate expiration date (30 days from creation)
        expiration_date = None
        if row[6]:  # created_at
            try:
                from datetime import datetime, timedelta
                created_at = datetime.fromisoformat(str(row[6]).replace('Z', '+00:00'))
                expiration_date = (created_at + timedelta(days=30)).strftime('%d/%m/%Y')
            except:
                pass
        
        prescriptions.append({
            "id": str(row[0]),
            "prescription_code": row[1],
            "patient_id": str(row[2]),
            "consultation_id": str(row[3]) if row[3] else None,
            "signed_by": str(row[4]) if row[4] else None,
            "signed_at": str(row[5]) if row[5] else None,
            "created_at": str(row[6]) if row[6] else None,
            "medic_name": row[7] if row[7] else None,
            "item_count": row[8] if row[8] else 0,
            "status": row[9] if row[9] else "vigente",
            "expiration_date": expiration_date
        })
    
    return prescriptions


@router.get("/{prescription_id}", response_model=dict)
async def get_prescription(
    prescription_id: UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get prescription by ID with items"""
    # Get prescription
    query = text("""
        SELECT id, prescription_code, patient_id, consultation_id, signed_by, signed_at, created_at
        FROM prescriptions
        WHERE id = :prescription_id
    """)
    
    result = db.execute(query, {"prescription_id": prescription_id})
    row = result.fetchone()
    
    if not row:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Prescription not found"
        )
    
    # Get prescription items
    items_query = text("""
        SELECT id, medication_name, dose, form, frequency, duration, observations
        FROM prescription_items
        WHERE prescription_id = :prescription_id
    """)
    
    items_result = db.execute(items_query, {"prescription_id": prescription_id})
    items = [
        {
            "id": str(item_row[0]),
            "medication_name": item_row[1],
            "dose": item_row[2],
            "form": item_row[3],
            "frequency": item_row[4],
            "duration": item_row[5],
            "observations": item_row[6]
        }
        for item_row in items_result
    ]
    
    return {
        "id": str(row[0]),
        "prescription_code": row[1],
        "patient_id": str(row[2]),
        "consultation_id": str(row[3]) if row[3] else None,
        "signed_by": str(row[4]) if row[4] else None,
        "signed_at": str(row[5]) if row[5] else None,
        "created_at": str(row[6]) if row[6] else None,
        "items": items
    }


@router.post("/", response_model=dict, status_code=status.HTTP_201_CREATED)
async def create_prescription(
    prescription: PrescriptionCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Create a new prescription
    
    Note: This is a base implementation. In production, you should:
    - Validate user has permission (medic role)
    - Generate prescription code properly
    - Add drug interaction checks
    - Add allergy checks
    - Add audit logging
    """
    from uuid import uuid4
    
    prescription_id = uuid4()
    now = datetime.utcnow()
    
    # Generate prescription code
    prescription_code = f"RX-{now.year}-{str(prescription_id)[:8].upper()}"
    
    # Create prescription
    query = text("""
        INSERT INTO prescriptions (id, prescription_code, patient_id, consultation_id, created_at)
        VALUES (:id, :prescription_code, :patient_id, :consultation_id, :created_at)
        RETURNING id, prescription_code, patient_id, consultation_id, created_at
    """)
    
    result = db.execute(query, {
        "id": prescription_id,
        "prescription_code": prescription_code,
        "patient_id": prescription.patient_id,
        "consultation_id": prescription.consultation_id,
        "created_at": now
    })
    
    # Create prescription items
    for item in prescription.items:
        item_id = uuid4()
        item_query = text("""
            INSERT INTO prescription_items (id, prescription_id, medication_name, dose, form, frequency, duration, observations)
            VALUES (:id, :prescription_id, :medication_name, :dose, :form, :frequency, :duration, :observations)
        """)
        
        db.execute(item_query, {
            "id": item_id,
            "prescription_id": prescription_id,
            "medication_name": item.medication_name,
            "dose": item.dose,
            "form": item.form,
            "frequency": item.frequency,
            "duration": item.duration,
            "observations": item.observations
        })
    
    db.commit()
    
    row = result.fetchone()
    return {
        "id": str(row[0]),
        "prescription_code": row[1],
        "patient_id": str(row[2]),
        "consultation_id": str(row[3]) if row[3] else None,
        "created_at": str(row[4]) if row[4] else None
    }

