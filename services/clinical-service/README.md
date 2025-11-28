# Farmacias Benavides - Clinical Service

FastAPI microservice for managing clinical data, patients, consultations, and prescriptions.

## Features

- JWT-based authentication with access and refresh tokens
- Patient management endpoints
- Consultation management
- Prescription management
- Clinical history access
- RESTful API design
- PostgreSQL database integration

## Setup

### Using Docker Compose (Recommended)

From the project root:

```bash
docker-compose up -d
```

This will start:
- PostgreSQL database on port 5432
- Clinical service API on port 8000

### Manual Setup

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Set environment variables (copy `.env.example` to `.env` and configure)

3. Run the service:
```bash
uvicorn app.main:app --reload
```

## API Documentation

Once the service is running, access:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Authentication

### Login
```bash
POST /api/v1/auth/login
{
  "username": "dr.garcia",
  "password": "password"
}
```

Returns:
```json
{
  "access_token": "...",
  "refresh_token": "...",
  "token_type": "bearer"
}
```

### Using the Token
Include the token in the Authorization header:
```
Authorization: Bearer <access_token>
```

### Refresh Token
```bash
POST /api/v1/auth/refresh
{
  "refresh_token": "..."
}
```

## Endpoints

### Authentication
- `POST /api/v1/auth/login` - Login and get tokens
- `POST /api/v1/auth/refresh` - Refresh access token
- `GET /api/v1/auth/me` - Get current user info

### Patients
- `GET /api/v1/patients/` - List patients
- `GET /api/v1/patients/{patient_id}` - Get patient details
- `GET /api/v1/patients/{patient_id}/clinical-history` - Get clinical history

### Consultations
- `GET /api/v1/consultations/` - List consultations
- `GET /api/v1/consultations/{consultation_id}` - Get consultation
- `POST /api/v1/consultations/` - Create consultation

### Prescriptions
- `GET /api/v1/prescriptions/` - List prescriptions
- `GET /api/v1/prescriptions/{prescription_id}` - Get prescription
- `POST /api/v1/prescriptions/` - Create prescription

## Development Notes

This is a base implementation. For production, you should:

1. **Authentication**:
   - Implement proper password verification
   - Add rate limiting
   - Add security logging
   - Implement MFA

2. **Authorization**:
   - Add role-based access control (RBAC)
   - Validate user permissions per endpoint

3. **Data Security**:
   - Implement PII encryption/decryption
   - Add data masking for sensitive fields
   - Implement audit logging

4. **Validation**:
   - Add comprehensive input validation
   - Add business rule validation
   - Add drug interaction checks
   - Add allergy warnings

5. **Performance**:
   - Add database indexing
   - Implement caching
   - Add pagination improvements
   - Optimize queries

6. **Monitoring**:
   - Add health checks
   - Add metrics collection
   - Add error tracking
   - Add request logging

## Project Structure

```
services/clinical-service/
├── app/
│   ├── api/
│   │   └── v1/
│   │       ├── endpoints/
│   │       │   ├── auth.py
│   │       │   ├── patients.py
│   │       │   ├── consultations.py
│   │       │   └── prescriptions.py
│   │       └── api.py
│   ├── core/
│   │   ├── config.py
│   │   ├── database.py
│   │   └── security.py
│   ├── models/
│   │   └── user.py
│   ├── schemas/
│   │   └── auth.py
│   └── main.py
├── Dockerfile
├── requirements.txt
└── README.md
```

