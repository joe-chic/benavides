#!/bin/bash
# Bash script to initialize or re-initialize the database
# This script ensures the schema and dummy data are loaded

echo "Initializing database..."

# Check if containers are running
if ! docker compose ps postgres -q > /dev/null 2>&1; then
    echo "PostgreSQL container is not running. Starting containers..."
    docker compose up -d postgres
    sleep 5
fi

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
max_attempts=30
attempt=0
while [ $attempt -lt $max_attempts ]; do
    if docker compose exec -T postgres pg_isready -U postgres > /dev/null 2>&1; then
        echo "PostgreSQL is ready!"
        break
    fi
    attempt=$((attempt + 1))
    if [ $attempt -ge $max_attempts ]; then
        echo "PostgreSQL failed to become ready after $max_attempts attempts"
        exit 1
    fi
    sleep 1
done

# Check if tables exist
echo "Checking if database is initialized..."
table_count=$(docker compose exec -T postgres psql -U postgres -d benavides -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>&1 | tr -d ' ')

if [ "$table_count" = "0" ]; then
    echo "Database is empty. Loading schema..."
    docker compose exec -T postgres psql -U postgres -d benavides < db/schema/schema.sql
    
    echo "Loading dummy data..."
    docker compose exec -T postgres psql -U postgres -d benavides < db/dummy-data/dummy.sql
    
    echo "Database initialized successfully!"
else
    echo "Database already has $table_count tables. Skipping initialization."
    echo "To force re-initialization, run: docker compose down -v"
fi

echo "Done!"

