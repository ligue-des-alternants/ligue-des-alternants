#!/bin/bash
# ================================
# VPS Initial Setup Script
# ================================
# Usage: ssh user@45.155.170.6 'bash -s' < scripts/setup-vps.sh
# Or copy to VPS and run: sudo ./setup-vps.sh
#
# Target: Ubuntu 22.04 - 2 vCPU, 2GB RAM, 30GB SSD

set -e

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

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    error "Please run as root (sudo ./setup-vps.sh)"
fi

echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}  VPS Setup for Ligue des Alternants${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

# ================================
# 1. System Update
# ================================
log "Updating system packages..."
apt-get update
apt-get upgrade -y

# ================================
# 2. Install Essential Packages
# ================================
log "Installing essential packages..."
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    htop \
    ufw \
    fail2ban \
    unzip

# ================================
# 3. Setup Swap (important for 2GB RAM)
# ================================
log "Setting up swap file (2GB)..."
if [ ! -f /swapfile ]; then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

    # Optimize swap settings for low RAM
    echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf
    echo 'vm.vfs_cache_pressure=50' | tee -a /etc/sysctl.conf
    sysctl -p
    log "Swap file created and enabled"
else
    warn "Swap file already exists, skipping..."
fi

# ================================
# 4. Install Docker
# ================================
log "Installing Docker..."
if ! command -v docker &> /dev/null; then
    # Add Docker's official GPG key
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Add current user to docker group (if not root)
    if [ -n "$SUDO_USER" ]; then
        usermod -aG docker "$SUDO_USER"
        log "Added $SUDO_USER to docker group"
    fi

    # Start and enable Docker
    systemctl start docker
    systemctl enable docker
    log "Docker installed successfully"
else
    warn "Docker already installed, skipping..."
fi

# ================================
# 5. Configure Firewall (UFW)
# ================================
log "Configuring firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw --force enable
log "Firewall configured (SSH, HTTP, HTTPS allowed)"

# ================================
# 6. Configure Fail2Ban
# ================================
log "Configuring Fail2Ban..."
cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
EOF

systemctl restart fail2ban
systemctl enable fail2ban
log "Fail2Ban configured and enabled"

# ================================
# 7. Create Project Directory
# ================================
log "Creating project directory..."
mkdir -p /opt/ligue-alternants
mkdir -p /var/backups/ligue-alternants/database
mkdir -p /var/backups/ligue-alternants/uploads

if [ -n "$SUDO_USER" ]; then
    chown -R "$SUDO_USER":"$SUDO_USER" /opt/ligue-alternants
    chown -R "$SUDO_USER":"$SUDO_USER" /var/backups/ligue-alternants
fi

log "Project directory created at /opt/ligue-alternants"

# ================================
# 8. Setup Backup Cron Job
# ================================
log "Setting up backup cron job..."
CRON_JOB="0 3 * * * /opt/ligue-alternants/scripts/backup.sh >> /var/log/lda-backup.log 2>&1"

# Add cron job if it doesn't exist
(crontab -l 2>/dev/null | grep -v "ligue-alternants/scripts/backup.sh"; echo "$CRON_JOB") | crontab -
log "Backup cron job configured (runs daily at 3 AM)"

# ================================
# Summary
# ================================
echo ""
echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}  Setup Complete!${NC}"
echo -e "${CYAN}================================${NC}"
echo ""
echo -e "${GREEN}System configured with:${NC}"
echo "  ✓ System packages updated"
echo "  ✓ 2GB Swap file (for stability)"
echo "  ✓ Docker & Docker Compose"
echo "  ✓ UFW Firewall (SSH, HTTP, HTTPS)"
echo "  ✓ Fail2Ban (SSH protection)"
echo "  ✓ Project directory: /opt/ligue-alternants"
echo "  ✓ Backup directory: /var/backups/ligue-alternants"
echo "  ✓ Daily backup cron job (3 AM)"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Clone your repository to /opt/ligue-alternants"
echo "  2. Copy .env.production file with your secrets"
echo "  3. Run: docker compose -f docker-compose.prod.yml up -d"
echo "  4. Setup SSL with: ./scripts/setup-ssl.sh"
echo ""

if [ -n "$SUDO_USER" ]; then
    echo -e "${YELLOW}Note: Log out and back in for docker group to take effect${NC}"
fi
