# 💻 Guide de développement local avec Docker

Ce guide explique comment configurer et utiliser l'environnement de développement Docker.

## 📋 Prérequis

- **Docker Desktop** : [Télécharger](https://www.docker.com/products/docker-desktop/)
- **Git** : Pour cloner le repository

> 💡 **Note** : Vous n'avez pas besoin d'installer Node.js, pnpm ou PostgreSQL. Docker s'occupe de tout !

---

## 🚀 Démarrage rapide

### 1. Cloner le repository

```bash
git clone https://github.com/ligue-des-alternants/ligue-des-alternants.git
cd ligue-des-alternants
```

### 2. Copier le fichier d'environnement

```bash
cp .env.example .env
```

### 3. Lancer l'environnement de développement

```bash
docker compose up
```

C'est tout ! 🎉

### 4. Accéder aux applications

| Application      | URL                         | Description                |
| ---------------- | --------------------------- | -------------------------- |
| **Frontend**     | http://localhost:4321       | Site Astro avec hot-reload |
| **Strapi Admin** | http://localhost:1337/admin | Interface d'administration |
| **Strapi API**   | http://localhost:1337/api   | API REST                   |

---

## 📦 Commandes Docker

### Démarrer les services

```bash
# Démarrer en mode interactif (logs visibles)
docker compose up

# Démarrer en arrière-plan
docker compose up -d

# Démarrer un service spécifique
docker compose up frontend
docker compose up strapi
```

### Arrêter les services

```bash
# Arrêter (garde les volumes)
docker compose down

# Arrêter et supprimer les volumes (⚠️ supprime les données)
docker compose down -v
```

### Voir les logs

```bash
# Tous les services
docker compose logs -f

# Un service spécifique
docker compose logs -f strapi
docker compose logs -f frontend
docker compose logs -f postgres
```

### Reconstruire les images

```bash
# Reconstruire après modification du Dockerfile
docker compose build

# Reconstruire et relancer
docker compose up --build
```

### Accéder à un container

```bash
# Terminal dans Strapi
docker compose exec strapi sh

# Terminal dans PostgreSQL
docker compose exec postgres psql -U strapi -d strapi
```

---

## 🔄 Hot-reload

Les modifications de code sont automatiquement détectées :

| Dossier               | Effet                                  |
| --------------------- | -------------------------------------- |
| `apps/frontend/src/`  | Rechargement automatique du navigateur |
| `apps/server/src/`    | Redémarrage automatique de Strapi      |
| `apps/server/config/` | Redémarrage automatique de Strapi      |

---

## 🗄️ Base de données

### Accéder à PostgreSQL

```bash
docker compose exec postgres psql -U strapi -d strapi
```

### Commandes SQL utiles

```sql
-- Lister les tables
\dt

-- Voir la structure d'une table
\d news_items

-- Quitter
\q
```

### Réinitialiser la base de données

```bash
# Arrêter et supprimer le volume PostgreSQL
docker compose down -v

# Relancer (crée une nouvelle base vide)
docker compose up
```

---

## 🛠️ Développement sans Docker

Si vous préférez développer sans Docker (installation locale), utilisez les commandes pnpm :

### Prérequis

- Node.js 20.x
- pnpm 10.x

### Installation

```bash
# Installer les dépendances
pnpm install

# Lancer les deux apps en parallèle
pnpm dev

# Ou lancer séparément
pnpm dev:front   # Frontend uniquement
pnpm dev:server  # Strapi uniquement
```

> ⚠️ **Note** : En mode local, Strapi utilise SQLite au lieu de PostgreSQL.

---

## 🐛 Dépannage

### Les containers ne démarrent pas

```bash
# Vérifier les logs d'erreur
docker compose logs

# Reconstruire les images
docker compose build --no-cache

# Supprimer tout et recommencer
docker compose down -v
docker compose up --build
```

### Port déjà utilisé

```bash
# Voir ce qui utilise le port 1337
netstat -ano | findstr :1337

# Voir ce qui utilise le port 4321
netstat -ano | findstr :4321
```

Modifiez les ports dans `docker-compose.yml` si nécessaire.

### Strapi ne trouve pas la base de données

Vérifiez que PostgreSQL est démarré :

```bash
docker compose ps postgres
docker compose logs postgres
```

### Hot-reload ne fonctionne pas

1. Vérifiez que les volumes sont correctement montés
2. Redémarrez les containers : `docker compose restart`
3. Sur Windows, activez les "file change events" dans Docker Desktop

### Problème de mémoire Docker

Docker Desktop utilise beaucoup de RAM. Ajustez les limites dans :

- **Windows/Mac** : Docker Desktop > Settings > Resources > Memory

---

## 📁 Structure des volumes Docker

```yaml
# Volumes de développement (montés depuis le système hôte)
- ./apps/frontend/src:/app/apps/frontend/src # Code frontend
- ./apps/server/src:/app/apps/server/src # Code Strapi
- ./apps/server/public/uploads:/app/.../uploads # Fichiers uploadés

# Volumes persistants (gérés par Docker)
- postgres_data_dev:/var/lib/postgresql/data # Données PostgreSQL
```

---

## 🔧 Configuration IDE

### VS Code

Extensions recommandées :

- **Docker** : Gestion des containers
- **Astro** : Syntaxe Astro
- **ESLint** : Linting JavaScript/TypeScript
- **Prettier** : Formatage du code
- **Tailwind CSS IntelliSense** : Autocomplétion Tailwind

### Fichiers à ignorer

Le `.gitignore` inclut déjà les fichiers à ne pas committer :

- `.env` (contient vos secrets locaux)
- `node_modules/`
- `apps/server/.tmp/` (base SQLite locale)
- `apps/server/public/uploads/` (fichiers uploadés)

---

_Documentation mise à jour le 7 décembre 2025_
