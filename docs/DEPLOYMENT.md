# 🚀 Guide de déploiement - VPS

Ce guide explique comment déployer le projet sur un VPS Ubuntu 22.04.

## 📋 Prérequis

- **VPS** : Ubuntu 22.04, 2 vCPU, 2GB RAM minimum, 30GB SSD
- **Accès SSH** : Clé SSH configurée sur le serveur
- **Domaine** : DNS configuré pour pointer vers le VPS (A record)
- **GitHub** : Secrets configurés pour le déploiement automatique

## 🔧 Configuration initiale du VPS

### 1. Première connexion

```bash
ssh user@45.155.170.6
```

### 2. Exécuter le script de configuration

Le script installe Docker, configure le firewall, le swap et les sauvegardes :

```bash
# Option 1 : Depuis votre machine locale
ssh user@45.155.170.6 'bash -s' < scripts/setup-vps.sh

# Option 2 : Sur le VPS après clonage du repo
sudo ./scripts/setup-vps.sh
```

Le script configure automatiquement :

- ✅ Mise à jour système
- ✅ Docker & Docker Compose
- ✅ Swap 2GB (pour stabilité avec 2GB RAM)
- ✅ Firewall UFW (SSH, HTTP, HTTPS)
- ✅ Fail2Ban (protection SSH)
- ✅ Dossiers projet et sauvegardes
- ✅ Cron job pour sauvegardes quotidiennes

### 3. Cloner le repository

```bash
cd /opt/ligue-alternants
git clone https://github.com/ligue-des-alternants/ligue-des-alternants.git .
```

### 4. Configurer les variables d'environnement

```bash
# Générer les secrets Strapi
./scripts/generate-secrets.sh

# Copier et éditer le fichier d'environnement
cp .env.production.example .env.production
nano .env.production
```

Remplissez les valeurs générées par le script.

### 5. Premier déploiement

```bash
# Lancer les services
docker compose -f docker-compose.prod.yml up -d

# Vérifier les logs
docker compose -f docker-compose.prod.yml logs -f
```

### 6. Configurer SSL (HTTPS)

Une fois le site accessible en HTTP :

```bash
./scripts/setup-ssl.sh
```

Puis décommentez le bloc HTTPS dans `nginx/nginx.conf` et redémarrez nginx :

```bash
docker compose -f docker-compose.prod.yml restart nginx
```

---

## 🔑 Configuration GitHub Secrets

Pour activer le déploiement automatique via GitHub Actions, configurez ces secrets dans votre repository :

| Secret            | Description                      | Exemple                                  |
| ----------------- | -------------------------------- | ---------------------------------------- |
| `SSH_PRIVATE_KEY` | Clé SSH privée pour accès au VPS | `-----BEGIN OPENSSH PRIVATE KEY-----...` |
| `VPS_HOST`        | Adresse IP du VPS                | `45.155.170.6`                           |
| `VPS_USER`        | Utilisateur SSH                  | `deploy`                                 |
| `STRAPI_URL`      | URL publique de Strapi           | `https://liguedesalternants.fr`          |

### Générer une clé SSH dédiée au déploiement

```bash
# Sur votre machine locale
ssh-keygen -t ed25519 -C "github-deploy" -f ~/.ssh/lda-deploy

# Copier la clé publique sur le VPS
ssh-copy-id -i ~/.ssh/lda-deploy.pub user@45.155.170.6

# Afficher la clé privée (à copier dans GitHub Secrets)
cat ~/.ssh/lda-deploy
```

---

## 🔄 Déploiement automatique

Le déploiement se déclenche :

- **Manuellement** : Depuis l'onglet Actions > Deploy > Run workflow
- **Automatiquement** : À chaque merge sur `main` (si activé dans le workflow)

### Workflow de déploiement

1. ✅ Exécution des tests CI (lint, format, typecheck)
2. 📦 Build des images Docker
3. 📤 Transfert des images vers le VPS
4. 🔄 Redémarrage des containers
5. ✅ Health checks

---

## 📊 Commandes utiles

### Gestion des containers

```bash
cd /opt/ligue-alternants

# Voir les logs
docker compose -f docker-compose.prod.yml logs -f

# Logs d'un service spécifique
docker compose -f docker-compose.prod.yml logs -f strapi

# Redémarrer un service
docker compose -f docker-compose.prod.yml restart strapi

# Arrêter tout
docker compose -f docker-compose.prod.yml down

# Relancer tout
docker compose -f docker-compose.prod.yml up -d
```

### Sauvegardes

```bash
# Sauvegarde manuelle
./scripts/backup.sh

# Voir les sauvegardes
ls -la /var/backups/ligue-alternants/

# Restaurer une sauvegarde
./scripts/restore.sh 2025-12-07_03-00-00
```

### Base de données

```bash
# Accéder à PostgreSQL
docker exec -it lda-postgres psql -U strapi -d ligue_alternants

# Export manuel
docker exec lda-postgres pg_dump -U strapi ligue_alternants > backup.sql
```

### Monitoring

```bash
# Utilisation des ressources
docker stats

# Espace disque
df -h

# Mémoire
free -h

# Processus
htop
```

---

## 🔥 Dépannage

### Le site ne répond pas

```bash
# Vérifier que les containers tournent
docker compose -f docker-compose.prod.yml ps

# Vérifier les logs nginx
docker compose -f docker-compose.prod.yml logs nginx

# Vérifier le firewall
sudo ufw status
```

### Strapi ne démarre pas

```bash
# Vérifier les logs
docker compose -f docker-compose.prod.yml logs strapi

# Vérifier la connexion à PostgreSQL
docker compose -f docker-compose.prod.yml exec strapi ping postgres
```

### Problème de mémoire

```bash
# Vérifier la mémoire
free -h

# Vérifier le swap
swapon --show

# Voir les containers qui consomment le plus
docker stats --no-stream
```

### Renouvellement SSL échoue

```bash
# Test de renouvellement
docker compose -f docker-compose.prod.yml run --rm certbot renew --dry-run

# Renouvellement forcé
docker compose -f docker-compose.prod.yml run --rm certbot renew --force-renewal
```

---

## 📁 Architecture des fichiers sur le VPS

```
/opt/ligue-alternants/
├── docker-compose.prod.yml
├── .env.production
├── nginx/
│   ├── nginx.conf
│   └── conf.d/
└── scripts/
    ├── backup.sh
    ├── restore.sh
    ├── setup-ssl.sh
    └── setup-vps.sh

/var/backups/ligue-alternants/
├── database/
│   └── postgres_YYYY-MM-DD_HH-MM-SS.sql.gz
└── uploads/
    └── uploads_YYYY-MM-DD_HH-MM-SS.tar.gz
```

---

_Documentation mise à jour le 7 décembre 2025_
