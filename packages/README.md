# Packages internes

Ce monorepo utilise des packages internes pour partager les configurations entre les applications.

## 📦 Packages disponibles

### @ligue-des-alternants/eslint-config

Configurations ESLint partagées pour le monorepo.

**Configurations disponibles :**

- `base` - Configuration de base pour tout projet
- `react` - Configuration pour React + Astro (frontend)
- `node` - Configuration pour Node.js (serveur Strapi)

**Usage :**

```js
// apps/frontend/eslint.config.mjs
import config from '@ligue-des-alternants/eslint-config/react';

export default config;
```

**Dépendances incluses :**

- `@eslint/js`
- `typescript-eslint`
- `eslint-config-prettier`
- `eslint-plugin-react` (react config)
- `eslint-plugin-react-hooks` (react config)
- `eslint-plugin-jsx-a11y` (react config)
- `eslint-plugin-astro` (react config)
- `globals`

---

### @ligue-des-alternants/prettier-config

Configuration Prettier partagée pour le monorepo.

**Usage :**

Dans `package.json` :

```json
{
  "prettier": "@ligue-des-alternants/prettier-config"
}
```

Ou dans `.prettierrc.json` :

```json
"@ligue-des-alternants/prettier-config"
```

**Plugins inclus :**

- `prettier-plugin-astro` - Support des fichiers Astro
- `@trivago/prettier-plugin-sort-imports` - Tri automatique des imports
- `prettier-plugin-tailwindcss` - Tri des classes Tailwind

**Configuration :**

- Semi-colons activés
- Single quotes
- 2 espaces d'indentation
- Print width : 100
- Trailing commas : ES5
- Line endings : LF

---

### @ligue-des-alternants/typescript-config

Configurations TypeScript partagées pour le monorepo.

**Configurations disponibles :**

- `base` - Configuration de base stricte
- `react` - Configuration pour React (étend base)
- `node` - Configuration pour Node.js/Strapi

**Usage :**

```json
{
  "extends": "@ligue-des-alternants/typescript-config/react"
}
```

**Config `base` :**

- Mode strict activé
- Variables et paramètres non utilisés détectés
- Skip lib check
- ESM par défaut
- Target ES2022

**Config `react` :**

- Étend `base`
- JSX : react-jsx
- Includes DOM types
- noEmit : true (build géré par Astro/Vite)

**Config `node` :**

- CommonJS
- Node module resolution
- Strict : false (pour compatibilité Strapi)
- Target ES2019

---

## 🔧 Ajouter un package interne

Pour créer un nouveau package de configuration :

1. **Créer le dossier :**

   ```bash
   mkdir -p packages/mon-package
   ```

2. **Créer le package.json :**

   ```json
   {
     "name": "@ligue-des-alternants/mon-package",
     "version": "0.0.0",
     "private": true,
     "main": "index.js"
   }
   ```

3. **Le workspace est automatiquement détecté** grâce à `packages/*` dans `pnpm-workspace.yaml`

4. **Utiliser dans une app :**
   ```json
   {
     "dependencies": {
       "@ligue-des-alternants/mon-package": "workspace:*"
     }
   }
   ```

---

## 📝 Maintenance

### Mettre à jour les dépendances d'un package

```bash
# Depuis le package
cd packages/eslint-config
pnpm add -D nouvelle-dep

# Ou depuis la racine
pnpm --filter @ligue-des-alternants/eslint-config add -D nouvelle-dep
```

### Voir les dépendances d'un package

```bash
pnpm --filter @ligue-des-alternants/eslint-config list
```

### Rebuilder tous les packages

```bash
pnpm -r build
```

---

## ⚠️ Notes importantes

1. **Les packages internes sont privés** (`"private": true`) et ne seront jamais publiés sur npm

2. **Les versions sont `workspace:*`** pour toujours utiliser la version locale

3. **Les peer dependencies** doivent être installées dans l'app qui utilise le package

4. **Pas de build nécessaire** - Les configs sont directement importables (JSON/MJS)

---

## 🎯 Avantages de cette approche

✅ **Centralisation** - Une seule source de vérité pour les configs  
✅ **Réutilisabilité** - Facile d'ajouter de nouvelles apps  
✅ **Versioning** - Chaque package a sa propre version  
✅ **Type safety** - Meilleur support TypeScript  
✅ **Évolutivité** - Structure scalable pour un grand monorepo  
✅ **Isolation** - Dépendances isolées par package
