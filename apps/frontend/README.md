# Ligue des Alternants - Frontend

Site pour la Ligue des Alternants, construite avec Astro, React, et Tailwind CSS.

## 🚀 Stack Technique

- **[Astro](https://astro.build)** - Framework web moderne
- **[React](https://react.dev)** - Composants interactifs
- **[Tailwind CSS](https://tailwindcss.com)** - Styling utilitaire
- **[TypeScript](https://www.typescriptlang.org/)** - Typage statique

## 📋 Prérequis

- **Node.js** 18+
- **pnpm** (gestionnaire de paquets)

## 🛠️ Installation

```bash
# Cloner le projet
git clone <repository-url>
cd lda-frontend

# Installer les dépendances
pnpm install
```

## 🏃 Scripts Disponibles

### Développement

```bash
# Lancer le serveur de développement
pnpm dev
# → http://localhost:4321
```

### Build & Preview

```bash
# Construire pour la production
pnpm build

# Prévisualiser le build de production
pnpm preview
```

### Linting & Formatage

```bash
# Vérifier le code avec ESLint
pnpm lint

# Corriger automatiquement les erreurs ESLint
pnpm lint:fix

# Formater le code avec Prettier
pnpm format

# Vérifier le formatage sans modifier
pnpm format:check
```

## 🎯 Git Hooks & Qualité du Code

Ce projet utilise **Husky**, **lint-staged** et **commitlint** pour garantir la qualité du code.

### Hooks Automatiques

#### Pre-commit

Avant chaque commit, **lint-staged** exécute automatiquement :

- ✅ **ESLint** sur les fichiers `.js`, `.ts`, `.tsx`, `.astro`
- ✅ **Prettier** sur tous les fichiers stagés
- ✅ Correction automatique des erreurs

#### Commit-msg

Les messages de commit doivent suivre la convention [Conventional Commits](https://www.conventionalcommits.org/).

**Format requis :**

```
<type>(<scope>): <subject>
```

**Exemples valides :**

```bash
feat: add user authentication
fix(ui): correct button alignment
docs: update installation guide
chore(deps): upgrade dependencies
```

**Types autorisés :** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`, `revert`

📖 Voir [COMMIT_CONVENTIONS.md](./.github/COMMIT_CONVENTIONS.md) pour plus de détails.

### Désactiver temporairement les hooks (non recommandé)

```bash
# Bypass pre-commit et commit-msg
git commit --no-verify -m "message"
```

## CI/CD

Le projet utilise **GitHub Actions** pour automatiser les vérifications de qualité.

### Workflows

#### CI (`ci.yml`)

Déclenché à chaque push sur `main` et sur les pull requests :

1. **Lint & Format Check**
   - ✅ Vérifie le code avec ESLint
   - ✅ Vérifie le formatage avec Prettier
2. **Build**
   - ✅ Construit le projet
   - ✅ Upload les artifacts (dist/)

#### Commitlint (`commitlint.yml`)

Déclenché sur les pull requests :

- ✅ Valide tous les messages de commit de la PR
- ✅ Garantit le respect des Conventional Commits

## 🔧 Configuration VS Code

Le projet inclut des configurations VS Code recommandées :

### Extensions Recommandées

Lors de l'ouverture du projet, VS Code proposera d'installer :

- Astro Language Support
- ESLint
- Prettier
- Tailwind CSS IntelliSense
