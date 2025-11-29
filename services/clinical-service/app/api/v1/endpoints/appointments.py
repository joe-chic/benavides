"""
Appointment endpoints
"""
from typing import List, Optional
from uuid import UUID

from fastapi import APIRouter, Depends
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.api.v1.endpoints.auth import get_current_user
from app.core.database import get_db
from app.models.user import User

router = APIRouter()


@router.get("/", response_model=List[dict])
async def get_appointments(
    skip: int = 0,
    limit: int = 100,
    patient_id: Optional[UUID] = None,
    search: Optional[str] = None,
    status_filter: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """
    Return appointments for the authenticated context.
    """
    base_query = """
        SELECT
            a.id,
            a.patients_id,
            a.medico_id,
            a.fecha_hora,
            a.motivo,
            a.status,
            a.created_at,
            a.updated_at,
            a.created_by,
            u.display_name AS doctor_name
        FROM appointments a
        LEFT JOIN users u ON a.medico_id = u.id
        WHERE 1=1
    """

    params: dict = {"skip": skip, "limit": limit}

    if patient_id:
        base_query += " AND a.patients_id = :patient_id"
        params["patient_id"] = str(patient_id)

    if status_filter:
        base_query += " AND LOWER(a.status) = :status_filter"
        params["status_filter"] = status_filter.lower()

    if search:
        base_query += """
            AND (
                LOWER(a.motivo) LIKE :search
                OR LOWER(a.status) LIKE :search
                OR LOWER(COALESCE(u.display_name, '')) LIKE :search
            )
        """
        params["search"] = f"%{search.lower()}%"

    base_query += " ORDER BY a.fecha_hora DESC LIMIT :limit OFFSET :skip"

    result = db.execute(text(base_query), params)

    appointments = []
    for row in result:
        appointments.append(
            {
                "id": str(row[0]),
                "patient_id": str(row[1]) if row[1] else None,
                "doctor_id": str(row[2]) if row[2] else None,
                "appointment_datetime": row[3].isoformat() if row[3] else None,
                "reason": row[4],
                "status": row[5],
                "created_at": row[6].isoformat() if row[6] else None,
                "updated_at": row[7].isoformat() if row[7] else None,
                "created_by": str(row[8]) if row[8] else None,
                "doctor_name": row[9],
            }
        )

    return appointments


