# 📚 Guide d'utilisation du CMS Strapi

Bienvenue dans le guide d'utilisation du système de gestion de contenu (CMS) de **Ligue des Alternants**. Ce guide vous explique comment gérer le contenu de votre site web.

## 🔐 Connexion à l'interface d'administration

1. Ouvrez votre navigateur et accédez à : **https://liguedesalternants.fr/admin**
2. Entrez vos identifiants (email et mot de passe)
3. Cliquez sur **Se connecter**

> 💡 **Conseil** : Utilisez un mot de passe fort et ne le partagez pas.

---

## 📰 Gérer les actualités

Les actualités apparaissent sur la page d'accueil et dans la section "Actualités" du site.

### Créer une nouvelle actualité

1. Dans le menu de gauche, cliquez sur **Content Manager** (Gestionnaire de contenu)
2. Sélectionnez **News Item** (Actualité)
3. Cliquez sur le bouton **+ Create new entry** (Créer une nouvelle entrée)
4. Remplissez les champs :
   - **Title** (Titre) : Le titre de votre actualité
   - **Slug** : L'URL de l'article (générée automatiquement à partir du titre)
   - **Summary** (Résumé) : Un court texte d'accroche (affiché sur la page d'accueil)
   - **Content** (Contenu) : Le contenu complet de l'article
   - **Cover** (Image de couverture) : L'image principale de l'actualité
   - **PublishedAt** (Date de publication) : La date affichée sur l'article
5. Cliquez sur **Save** (Enregistrer)
6. Cliquez sur **Publish** (Publier) pour rendre l'article visible sur le site

### Modifier une actualité existante

1. Dans **Content Manager** > **News Item**, cliquez sur l'actualité à modifier
2. Effectuez vos modifications
3. Cliquez sur **Save** puis **Publish** pour appliquer les changements

### Dépublier ou supprimer une actualité

- **Dépublier** : Cliquez sur le bouton **Unpublish** (Dépublier) pour retirer l'article du site sans le supprimer
- **Supprimer** : Cliquez sur l'icône de corbeille (⚠️ action irréversible)

---

## 🖼️ Gérer les médias (images, documents)

### Ajouter des images

1. Cliquez sur **Media Library** (Médiathèque) dans le menu de gauche
2. Cliquez sur **+ Add new assets** (Ajouter de nouveaux fichiers)
3. Glissez-déposez vos images ou cliquez pour les sélectionner
4. Cliquez sur **Upload** (Téléverser)

### Bonnes pratiques pour les images

| Type d'image                    | Dimensions recommandées | Format            |
| ------------------------------- | ----------------------- | ----------------- |
| Image de couverture (actualité) | 1200 x 630 px           | JPG, PNG          |
| Photo dans un article           | 800 x 600 px max        | JPG, PNG          |
| Logo ou icône                   | 200 x 200 px            | PNG (transparent) |

> 💡 **Conseil** : Compressez vos images avant de les uploader pour améliorer la vitesse du site. Vous pouvez utiliser [TinyPNG](https://tinypng.com/) gratuitement.

### Organiser les médias

- Créez des dossiers pour organiser vos fichiers (ex: "Actualités 2025", "Événements")
- Renommez les fichiers de manière descriptive (ex: "assemblee-generale-2025.jpg")

---

## ✏️ L'éditeur de texte riche

L'éditeur de contenu permet de formater vos textes facilement :

### Raccourcis clavier

| Action   | Raccourci  |
| -------- | ---------- |
| Gras     | `Ctrl + B` |
| Italique | `Ctrl + I` |
| Lien     | `Ctrl + K` |
| Annuler  | `Ctrl + Z` |
| Rétablir | `Ctrl + Y` |

### Fonctionnalités disponibles

- **Titres** : Utilisez les niveaux H2, H3, H4 pour structurer votre texte
- **Listes** : Listes à puces ou numérotées
- **Liens** : Ajoutez des liens vers d'autres pages ou sites externes
- **Images** : Insérez des images depuis la médiathèque
- **Citations** : Mettez en valeur des citations importantes

---

## 📅 Planifier une publication

Vous pouvez programmer la publication d'une actualité :

1. Créez votre actualité et remplissez tous les champs
2. Cliquez sur **Save** (sans publier)
3. Dans le champ **PublishedAt**, définissez la date souhaitée
4. L'article sera visible sur le site à partir de cette date

> ⚠️ **Note** : La planification nécessite que l'article soit publié manuellement une fois la date atteinte.

---

## 🔄 Sauvegardes et récupération

Les données du site sont sauvegardées automatiquement chaque nuit. En cas de problème, contactez votre développeur pour restaurer une version précédente.

---

## ❓ FAQ

### Je ne vois pas mes modifications sur le site

1. Vérifiez que vous avez bien cliqué sur **Publish** après avoir sauvegardé
2. Videz le cache de votre navigateur (`Ctrl + F5`)
3. Attendez quelques minutes, le site peut mettre du temps à se mettre à jour

### J'ai oublié mon mot de passe

1. Sur la page de connexion, cliquez sur **Forgot password?** (Mot de passe oublié)
2. Entrez votre adresse email
3. Suivez les instructions dans l'email reçu

### Mon image est trop lourde

1. Utilisez [TinyPNG](https://tinypng.com/) pour compresser l'image
2. Redimensionnez l'image si nécessaire (max 1920 px de large)
3. Réessayez l'upload

### Je veux ajouter une nouvelle section au site

Contactez votre développeur. L'ajout de nouvelles sections nécessite des modifications techniques.

---

## 📞 Support

En cas de problème technique ou de question, contactez :

- **Développeur** : Thomas ROBERT
- **Email** : thomas_3004@hotmail.fr

---

_Guide mis à jour le 7 décembre 2025_
