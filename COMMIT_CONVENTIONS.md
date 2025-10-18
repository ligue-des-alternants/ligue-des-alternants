# Conventions de Commit

Ce projet utilise [Conventional Commits](https://www.conventionalcommits.org/) pour standardiser les messages de commit.

## Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

## Types autorisés

- **feat**: Nouvelle fonctionnalité
- **fix**: Correction de bug
- **docs**: Documentation uniquement
- **style**: Changements de formatage (espaces, virgules, etc.)
- **refactor**: Refactoring de code (ni bug fix ni nouvelle feature)
- **perf**: Amélioration des performances
- **test**: Ajout ou modification de tests
- **chore**: Tâches de maintenance (dépendances, config, etc.)
- **ci**: Changements CI/CD
- **build**: Changements du système de build
- **revert**: Annulation d'un commit précédent

## Exemples

### ✅ Bons exemples

```bash
feat: add user authentication
feat(auth): implement JWT tokens
fix: correct calculation in total price
fix(cart): prevent duplicate items
docs: update installation instructions
style: format code with prettier
refactor: simplify user validation logic
perf: optimize image loading
test: add unit tests for user service
chore: update dependencies
chore(deps): upgrade astro to v5.14.6
ci: add github actions workflow
```

### ❌ Mauvais exemples

```bash
# Type manquant
update user profile

# Type invalide
Update: fix user profile

# Sujet commençant par une majuscule
feat: Add user profile

# Sujet se terminant par un point
feat: add user profile.

# Message trop vague
fix: fix bug
```

## Scope (optionnel)

Le scope précise la partie du projet affectée :

```bash
feat(auth): ...
fix(ui): ...
docs(readme): ...
chore(deps): ...
```

## Breaking Changes

Pour les changements incompatibles, ajouter `!` après le type ou `BREAKING CHANGE:` dans le footer :

```bash
feat!: remove support for Node 16

# ou

feat: redesign API endpoints

BREAKING CHANGE: API endpoints have changed from /api/v1 to /api/v2
```

## Body (optionnel)

Décrit en détail les changements :

```bash
feat: add user search functionality

Allow users to search by name, email, or username.
Implements fuzzy matching and pagination.
```

## Footer (optionnel)

Références aux issues ou breaking changes :

```bash
fix: correct login redirect

Fixes #123
Closes #456
```

## Utilisation avec Husky

Les commits sont automatiquement vérifiés avant d'être créés. Si le message ne suit pas le format, le commit sera rejeté.

### Tester un message de commit

```bash
# Sera accepté ✅
git commit -m "feat: add dark mode"

# Sera rejeté ❌
git commit -m "Added dark mode"
```
