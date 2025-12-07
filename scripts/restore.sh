#!/bin/bash
# ================================
# Restore Backup Script
# ================================
# Usage: ./scripts/restore.sh [backup_date]
# Example: ./scripts/restore.sh 2025-12-07_03-00-00

set -e

BACKUP_DIR="/var/backups/ligue-alternants"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" >&2
    exit 1
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1"
}

echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}  Backup Restore Tool${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

# List available backups if no date provided
if [ -z "$1" ]; then
    echo -e "${YELLOW}Available database backups:${NC}"
    ls -la "$BACKUP_DIR/database"/*.sql.gz 2>/dev/null || echo "  No database backups found"
    echo ""
    echo -e "${YELLOW}Available upload backups:${NC}"
    ls -la "$BACKUP_DIR/uploads"/*.tar.gz 2>/dev/null || echo "  No upload backups found"
    echo ""
    echo "Usage: $0 <backup_date>"
    echo "Example: $0 2025-12-07_03-00-00"
    exit 0
fi

BACKUP_DATE="$1"
DB_BACKUP="$BACKUP_DIR/database/postgres_${BACKUP_DATE}.sql.gz"
UPLOADS_BACKUP="$BACKUP_DIR/uploads/uploads_${BACKUP_DATE}.tar.gz"

# Verify backups exist
if [ ! -f "$DB_BACKUP" ]; then
    error "Database backup not found: $DB_BACKUP"
fi

if [ ! -f "$UPLOADS_BACKUP" ]; then
    warn "Uploads backup not found: $UPLOADS_BACKUP"
    warn "Continuing with database restore only..."
    RESTORE_UPLOADS=false
else
    RESTORE_UPLOADS=true
fi

# Confirmation
echo -e "${RED}WARNING: This will restore data from $BACKUP_DATE${NC}"
echo "  Database: $DB_BACKUP"
[ "$RESTORE_UPLOADS" = true ] && echo "  Uploads: $UPLOADS_BACKUP"
echo ""
read -p "Are you sure you want to continue? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    log "Restore cancelled"
    exit 0
fi

# ================================
# 1. Restore Database
# ================================
log "Restoring database..."

# Drop existing data and restore
gunzip -c "$DB_BACKUP" | docker exec -i lda-postgres psql -U "${DATABASE_USERNAME:-strapi}" -d "${DATABASE_NAME:-strapi}" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;" 2>/dev/null || true
gunzip -c "$DB_BACKUP" | docker exec -i lda-postgres psql -U "${DATABASE_USERNAME:-strapi}" -d "${DATABASE_NAME:-strapi}"

log "Database restored successfully"

# ================================
# 2. Restore Uploads
# ================================
if [ "$RESTORE_UPLOADS" = true ]; then
    log "Restoring uploads..."

    # Clear existing uploads
    docker exec lda-strapi rm -rf /app/public/uploads/*

    # Restore from backup
    gunzip -c "$UPLOADS_BACKUP" | docker cp - lda-strapi:/app/public/

    log "Uploads restored successfully"
fi

# ================================
# 3. Restart Strapi
# ================================
log "Restarting Strapi to apply changes..."
docker restart lda-strapi

echo ""
echo -e "${GREEN}✓ Restore completed successfully!${NC}"
echo ""
echo "Data restored from: $BACKUP_DATE"
