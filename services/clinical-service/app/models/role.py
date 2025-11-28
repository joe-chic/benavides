"""
Role model
"""
from sqlalchemy import Column, String, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.core.database import Base
import uuid


class Role(Base):
    """Role model"""
    __tablename__ = "roles"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(100), unique=True, nullable=False, index=True)
    description = Column(String(1000))
    
    # Relationships
    user_roles = relationship("UserRole", back_populates="role")


class UserRole(Base):
    """UserRole model - many-to-many relationship between users and roles"""
    __tablename__ = "user_roles"
    
    role_id = Column(UUID(as_uuid=True), ForeignKey("roles.id"), primary_key=True)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), primary_key=True)
    assigned_at = Column(String)  # Using String for now, can be DateTime
    assigned_by = Column(UUID(as_uuid=True))
    
    # Relationships
    role = relationship("Role", back_populates="user_roles")
    # Note: User relationship removed to avoid circular dependency issues
    # We query UserRole directly in endpoints instead

