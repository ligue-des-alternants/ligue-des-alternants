#!/bin/bash
# ================================
# Generate Strapi Secrets
# ================================
# Usage: ./scripts/generate-secrets.sh
# Generates secure random secrets for Strapi production

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}  Strapi Secrets Generator${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

# Function to generate a random base64 string
generate_secret() {
    openssl rand -base64 32
}

# Function to generate a random hex string (for encryption key)
generate_hex() {
    openssl rand -hex 16
}

echo -e "${YELLOW}Copy these values to your .env.production file:${NC}"
echo ""

echo "# Strapi Security Keys - Generated on $(date)"
echo "# KEEP THESE SECRET - DO NOT COMMIT TO GIT"
echo ""

# Generate APP_KEYS (4 comma-separated keys)
KEY1=$(generate_secret)
KEY2=$(generate_secret)
KEY3=$(generate_secret)
KEY4=$(generate_secret)
echo "APP_KEYS=\"$KEY1,$KEY2,$KEY3,$KEY4\""

echo "API_TOKEN_SALT=$(generate_secret)"
echo "ADMIN_JWT_SECRET=$(generate_secret)"
echo "TRANSFER_TOKEN_SALT=$(generate_secret)"
echo "JWT_SECRET=$(generate_secret)"
echo "ENCRYPTION_KEY=$(generate_hex)"

echo ""
echo -e "${GREEN}✓ Secrets generated successfully!${NC}"
echo ""
echo -e "${YELLOW}Remember:${NC}"
echo "  1. Copy these to your .env.production file on the VPS"
echo "  2. Never commit these secrets to Git"
echo "  3. Store a backup of these secrets securely"
