# Farmacias Benavides - Clinical System

Full-stack application for Farmacias Benavides clinical data management, including:
- PostgreSQL database with normalized schema
- FastAPI microservice for clinical data management
- Android mobile application

## Quick Start

### Prerequisites
- Docker and Docker Compose
- Android Studio (for Android app development)

### Starting the Services

1. **Start all services:**
   ```bash
   docker compose up --build
   ```

2. **Initialize the database (if needed):**
   
   **On Windows (PowerShell):**
   ```powershell
   .\scripts\init-db.ps1
   ```
   
   **On Linux/Mac:**
   ```bash
   chmod +x scripts/init-db.sh
   ./scripts/init-db.sh
   ```
   
   Or manually:
   ```bash
   # Load schema
   Get-Content db/schema/schema.sql | docker compose exec -T postgres psql -U postgres -d benavides
   
   # Load dummy data
   Get-Content db/dummy-data/dummy.sql | docker compose exec -T postgres psql -U postgres -d benavides
   ```

### Important Notes

**Database Initialization:**
- PostgreSQL initialization scripts in `/docker-entrypoint-initdb.d/` **only run when the database is first created** (when the volume is empty)
- If the `postgres_data` volume already exists, the initialization scripts will **NOT** run automatically
- To force re-initialization, remove the volume first:
  ```bash
  docker compose down -v  # Removes volumes
  docker compose up --build  # Recreates everything
  ```

**Services:**
- **PostgreSQL**: `localhost:5432`
- **FastAPI Service**: `http://localhost:8000`
- **API Documentation**: `http://localhost:8000/docs`

## Project Structure

```
.
├── db/
│   ├── schema/
│   │   └── schema.sql          # Database schema
│   └── dummy-data/
│       └── dummy.sql           # Dummy data for testing
├── services/
│   └── clinical-service/       # FastAPI microservice
├── android-app/                # Android application
└── docker-compose.yml          # Docker services configuration
```

## Testing

### Test Credentials

Use these credentials to test the login:
- **Username**: `dr.garcia`
- **Password**: Any password (base implementation accepts any password for existing users)

See `android-app/TEST_CREDENTIALS.md` for more test users.

### API Testing

1. Open http://localhost:8000/docs
2. Try the `/api/v1/auth/login` endpoint with:
   ```json
   {
     "username": "dr.garcia",
     "password": "test123"
   }
   ```

## Development

### Database Schema

The database schema is defined in `db/schema/schema.sql`. It follows 3NF normalization and includes:
- User management
- Patient records (with encrypted PII)
- Clinical histories
- Appointments and consultations
- Prescriptions and pharmacy operations

### FastAPI Service

Located in `services/clinical-service/`, provides:
- JWT authentication (access and refresh tokens)
- Patient management endpoints
- Consultation management
- Prescription management

### Android App

Located in `android-app/`, includes:
- Login screen
- Create account screen
- Reset password screen
- API integration with Retrofit

## Troubleshooting

### Database not initialized

If you see "relation does not exist" errors:
1. Check if tables exist: `docker compose exec postgres psql -U postgres -d benavides -c "\dt"`
2. If empty, run the initialization script: `.\scripts\init-db.ps1` (Windows) or `./scripts/init-db.sh` (Linux/Mac)
3. Or manually load the schema and dummy data

### Services not connecting

1. Verify services are running: `docker compose ps`
2. Check logs: `docker compose logs clinical-service`
3. Verify network connectivity between containers

### Android app can't connect

1. **Emulator**: Use `http://10.0.2.2:8000` (already configured)
2. **Physical device**: Update `RetrofitClient.kt` with your computer's IP address
3. Ensure `android:usesCleartextTraffic="true"` is in AndroidManifest.xml

## License

[Add your license here]
