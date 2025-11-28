"""
Authentication schemas
"""
from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime
from uuid import UUID


class Token(BaseModel):
    """Token response schema"""
    access_token: str
    refresh_token: str
    token_type: str = "bearer"


class TokenData(BaseModel):
    """Token data schema"""
    user_id: Optional[UUID] = None
    username: Optional[str] = None


class LoginRequest(BaseModel):
    """Login request schema - accepts email for login"""
    email: EmailStr
    password: str


class RefreshTokenRequest(BaseModel):
    """Refresh token request schema"""
    refresh_token: str


class UserResponse(BaseModel):
    """User response schema"""
    id: UUID
    username: str
    email: EmailStr
    display_name: Optional[str] = None
    mfa_enabled: bool
    created_at: Optional[datetime] = None
    roles: list[str] = []  # List of role names
    
    class Config:
        from_attributes = True

