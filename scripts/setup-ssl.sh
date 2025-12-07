#!/bin/bash
# ================================
# SSL Certificate Setup Script
# ================================
# Usage: ./scripts/setup-ssl.sh
# Run after initial deployment to obtain SSL certificates

set -e

# Configuration
DOMAIN="liguedesalternants.fr"
EMAIL="${SSL_EMAIL:-admin@liguedesalternants.fr}"

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

echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}  SSL Certificate Setup${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

# Check if running from project directory
if [ ! -f "docker-compose.prod.yml" ]; then
    error "Please run this script from the project root directory"
fi

# ================================
# 1. Verify DNS
# ================================
log "Verifying DNS resolution for $DOMAIN..."
RESOLVED_IP=$(dig +short "$DOMAIN" | head -1)

if [ -z "$RESOLVED_IP" ]; then
    error "Could not resolve $DOMAIN. Please ensure DNS A record is configured."
fi

log "Domain resolves to: $RESOLVED_IP"

# ================================
# 2. Obtain SSL Certificate
# ================================
log "Obtaining SSL certificate from Let's Encrypt..."

docker compose -f docker-compose.prod.yml run --rm certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email "$EMAIL" \
    --agree-tos \
    --no-eff-email \
    -d "$DOMAIN" \
    -d "www.$DOMAIN"

if [ $? -eq 0 ]; then
    log "SSL certificate obtained successfully!"
else
    error "Failed to obtain SSL certificate. Check that:"
    echo "  1. DNS A record points to this server"
    echo "  2. Port 80 is accessible from the internet"
    echo "  3. Nginx is running and serving /.well-known/acme-challenge/"
fi

# ================================
# 3. Update Nginx Configuration
# ================================
log "Updating Nginx configuration for HTTPS..."

echo ""
echo -e "${YELLOW}IMPORTANT: Manual step required!${NC}"
echo ""
echo "Edit nginx/nginx.conf and:"
echo "  1. Uncomment the HTTPS server block"
echo "  2. Uncomment the HTTP to HTTPS redirect"
echo "  3. Comment out or remove the temporary HTTP location blocks"
echo ""
echo "Then restart nginx with:"
echo "  docker compose -f docker-compose.prod.yml restart nginx"
echo ""

# ================================
# 4. Test Certificate Renewal
# ================================
log "Testing certificate renewal..."

docker compose -f docker-compose.prod.yml run --rm certbot renew --dry-run

if [ $? -eq 0 ]; then
    log "Certificate renewal test passed!"
else
    warn "Certificate renewal test failed. Check certbot configuration."
fi

echo ""
echo -e "${GREEN}✓ SSL setup complete!${NC}"
echo ""
echo "Your site should be accessible at:"
echo "  https://$DOMAIN"
echo "  https://www.$DOMAIN"
