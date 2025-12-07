# Ligue des Alternants - Monorepo

Monorepo contenant le frontend (Astro) et le backend (Strapi v5) de la Ligue des Alternants.

🌐 **Site** : [liguedesalternants.fr](https://liguedesalternants.fr)

## 📚 Documentation

| Document                             | Description                                  |
| ------------------------------------ | -------------------------------------------- |
| [Guide CMS](docs/GUIDE_CMS.md)       | Guide d'utilisation de Strapi pour le client |
| [Déploiement](docs/DEPLOYMENT.md)    | Guide de déploiement sur VPS                 |
| [Développement](docs/DEVELOPMENT.md) | Guide de développement avec Docker           |

## 📁 Structure du projet

```
ligue-des-alternants/
├── apps/
│   ├── frontend/          # Application Astro + React
│   └── server/            # Backend Strapi v5
├── packages/
│   ├── eslint-config/     # Configuration ESLint partagée
│   ├── prettier-config/   # Configuration Prettier partagée
│   └── typescript-config/ # Configurations TypeScript partagées
├── .husky/                # Git hooks
├── .github/               # GitHub workflows
├── .prettierignore        # Fichiers ignorés par Prettier
├── .lintstagedrc.json     # Configuration lint-staged
├── commitlint.config.ts   # Configuration commitlint
├── pnpm-workspace.yaml    # Configuration workspace pnpm
└── package.json           # Scripts et dépendances racine
```

## 🚀 Démarrage rapide

### Prérequis

- Node.js >= 18.0.0
- pnpm >= 8.0.0

### Installation

```bash
# Cloner le repository
git clone <repo-url>
cd ligue-des-alternants

# Installer les dépendances
pnpm install
```

### Développement avec Docker (recommandé)

```bash
# Copier le fichier d'environnement
cp .env.example .env

# Lancer l'environnement Docker
docker compose up
```

- Frontend : http://localhost:4321 (hot-reload)
- Strapi Admin : http://localhost:1337/admin

### Développement sans Docker

```bash
# Lancer frontend + backend en parallèle
pnpm dev

# Lancer uniquement le frontend
pnpm dev:front

# Lancer uniquement le backend
pnpm dev:server
```

Le frontend sera accessible sur `http://localhost:4321` et le backend sur `http://localhost:1337`.

## 🏗️ Build

```bash
# Build complet
pnpm build

# Build frontend uniquement
pnpm build:front

# Build backend uniquement
pnpm build:server
```

## ✨ Qualité de code

### Linting

```bash
# Lint tout le monorepo
pnpm lint

# Lint avec auto-fix
pnpm lint:fix
```

### Formatage

```bash
# Formater tous les fichiers
pnpm format

# Vérifier le formatage
pnpm format:check
```

### Type checking

```bash
# Vérifier TypeScript sur tout le monorepo
pnpm typecheck
```

## 🔧 Technologies

### Frontend

- **Astro** 5.x - Framework web
- **React** 19.x - Composants interactifs
- **Tailwind CSS** 4.x - Styling
- **TypeScript** - Type safety

### Backend

- **Strapi** 5.x - Headless CMS
- **PostgreSQL** - Base de données (production)
- **SQLite** - Base de données (dev sans Docker)
- **TypeScript** - Type safety

### Infrastructure

- **Docker** - Conteneurisation
- **nginx** - Reverse proxy
- **Certbot** - Certificats SSL Let's Encrypt
- **GitHub Actions** - CI/CD

### Outils de développement

- **pnpm** - Gestionnaire de packages
- **ESLint** - Linting JavaScript/TypeScript
- **Prettier** - Formatage de code
- **Husky** - Git hooks
- **lint-staged** - Lint des fichiers modifiés
- **commitlint** - Validation des messages de commit

## 📝 Convention de commits

Ce projet utilise [Conventional Commits](https://www.conventionalcommits.org/). Format :

```
type(scope?): description

[body optionnel]
[footer optionnel]
```

Types acceptés :

- `feat` - Nouvelle fonctionnalité
- `fix` - Correction de bug
- `docs` - Documentation
- `style` - Formatage, point-virgules manquants, etc.
- `refactor` - Refactorisation du code
- `perf` - Amélioration des performances
- `test` - Ajout de tests
- `chore` - Tâches de maintenance

Exemples :

```bash
git commit -m "feat: ajoute la page actualités"
git commit -m "fix(frontend): corrige le responsive du header"
git commit -m "docs: met à jour le README"
```

## 🔒 Pre-commit hooks

Les hooks Git suivants sont configurés :

1. **pre-commit** : Exécute lint-staged
   - Lint des fichiers JS/TS/Astro modifiés
   - Formatage automatique des fichiers modifiés

2. **commit-msg** : Vérifie le format du message avec commitlint

## 🤝 Contribution

1. Créer une branche depuis `main`
2. Faire vos modifications
3. Commit avec les conventions
4. Push et créer une Pull Request

## 🚀 Déploiement

Le projet est déployé sur un VPS Ubuntu via Docker. Voir [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) pour les détails.

### Déploiement automatique

Le workflow GitHub Actions déploie automatiquement après un merge sur `main` (si activé) ou manuellement via l'onglet Actions.

### Déploiement manuel

```bash
# Sur le VPS
cd /opt/ligue-alternants
docker compose -f docker-compose.prod.yml up -d
```
