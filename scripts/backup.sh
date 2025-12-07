#!/bin/bash
# ================================
# Backup Script - PostgreSQL & Uploads
# ================================
# Usage: ./scripts/backup.sh
# Recommended: Run daily via cron
# crontab -e → 0 3 * * * /path/to/project/scripts/backup.sh

set -e

# Configuration
BACKUP_DIR="/var/backups/ligue-alternants"
RETENTION_DAYS=7
DATE=$(date +%Y-%m-%d_%H-%M-%S)
PROJECT_DIR=$(dirname "$(dirname "$(readlink -f "$0")")")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" >&2
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1"
}

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR/database"
mkdir -p "$BACKUP_DIR/uploads"

log "Starting backup process..."

# ================================
# 1. Backup PostgreSQL Database
# ================================
log "Backing up PostgreSQL database..."

DB_BACKUP_FILE="$BACKUP_DIR/database/postgres_${DATE}.sql.gz"

docker exec lda-postgres pg_dump -U "${DATABASE_USERNAME:-strapi}" "${DATABASE_NAME:-strapi}" | gzip > "$DB_BACKUP_FILE"

if [ -f "$DB_BACKUP_FILE" ]; then
    DB_SIZE=$(du -h "$DB_BACKUP_FILE" | cut -f1)
    log "Database backup completed: $DB_BACKUP_FILE ($DB_SIZE)"
else
    error "Database backup failed!"
    exit 1
fi

# ================================
# 2. Backup Strapi Uploads
# ================================
log "Backing up Strapi uploads..."

UPLOADS_BACKUP_FILE="$BACKUP_DIR/uploads/uploads_${DATE}.tar.gz"

# Get the volume path or copy from container
docker cp lda-strapi:/app/public/uploads - | gzip > "$UPLOADS_BACKUP_FILE"

if [ -f "$UPLOADS_BACKUP_FILE" ]; then
    UPLOADS_SIZE=$(du -h "$UPLOADS_BACKUP_FILE" | cut -f1)
    log "Uploads backup completed: $UPLOADS_BACKUP_FILE ($UPLOADS_SIZE)"
else
    error "Uploads backup failed!"
    exit 1
fi

# ================================
# 3. Clean old backups
# ================================
log "Cleaning backups older than $RETENTION_DAYS days..."

# Clean old database backups
find "$BACKUP_DIR/database" -name "postgres_*.sql.gz" -type f -mtime +$RETENTION_DAYS -delete
DB_CLEANED=$(find "$BACKUP_DIR/database" -name "postgres_*.sql.gz" -type f -mtime +$RETENTION_DAYS 2>/dev/null | wc -l)

# Clean old uploads backups
find "$BACKUP_DIR/uploads" -name "uploads_*.tar.gz" -type f -mtime +$RETENTION_DAYS -delete
UPLOADS_CLEANED=$(find "$BACKUP_DIR/uploads" -name "uploads_*.tar.gz" -type f -mtime +$RETENTION_DAYS 2>/dev/null | wc -l)

log "Cleaned $DB_CLEANED old database backups and $UPLOADS_CLEANED old upload backups"

# ================================
# 4. Show backup status
# ================================
log "Backup summary:"
echo "  Database backups: $(ls -1 "$BACKUP_DIR/database"/*.sql.gz 2>/dev/null | wc -l) files"
echo "  Uploads backups: $(ls -1 "$BACKUP_DIR/uploads"/*.tar.gz 2>/dev/null | wc -l) files"
echo "  Total backup size: $(du -sh "$BACKUP_DIR" | cut -f1)"

log "Backup process completed successfully!"
