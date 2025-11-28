"""
User model
"""
from sqlalchemy import Column, String, Boolean, DateTime, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.core.database import Base
import uuid


class User(Base):
    """User model"""
    __tablename__ = "users"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    username = Column(String(100), unique=True, nullable=False, index=True)
    password_hash = Column(String(255))
    email = Column(String(255), unique=True, nullable=False, index=True)
    mfa_enabled = Column(Boolean, default=False)
    display_name = Column(String(255))
    created_at = Column(DateTime(timezone=True))
    created_by = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    
    # Relationships
    creator = relationship("User", remote_side=[id], backref="created_users")
    # Note: user_roles relationship is defined in UserRole model with back_populates

