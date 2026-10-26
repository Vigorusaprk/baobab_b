# Baobab Business

Application **marchands** de l'écosystème Baobabe (Kinshasa, RDC). Elle permet à un commerçant de gérer son commerce depuis son téléphone, sa tablette ou son ordinateur : commandes, réservations, offres, boutique et publicité.

> Baobab Business ne remplace pas les outils du commerçant : elle lui apporte des clients, il continue de travailler comme avant.

## Fonctionnalités

| Onglet | Ce qu'il fait |
|---|---|
| **Dashboard** | Chiffres du jour et de la veille, revenus du mois, commandes en attente, produits les plus vendus, dernières commandes. |
| **Stock (offres)** | Liste des offres, ajout et modification (nom, prix en USD, catégorie, description, photo), activation/désactivation, offres à commander, à réserver ou en boutique, capacité et date pour les réservations, disponibilités et créneaux. |
| **Commandes** | Commandes et réservations reçues, détail, changement de statut (en attente, confirmée, en préparation, prête, livrée, annulée). |
| **Stats** | Statistiques détaillées. |
| **Pub** | Emplacements et tarifs, demande de mise en avant, suivi des campagnes (en examen, validée, en diffusion, terminée, refusée), annulation. |
| **Boutique** | Page de la boutique (photo de couverture, description, contact, adresse, horaires, fermeture temporaire) et formulaire de modification. |

Il n'y a **pas d'inscription** dans l'app : l'accès commerçant est créé par l'équipe Baobabe.

## Responsive

| Largeur | Mise en page |
|---|---|
| < 600 px | Mobile : barre de navigation en bas |
| ≥ 600 px | Tablette / desktop : menu latéral |

Les formulaires sont centrés et limités en largeur pour rester lisibles sur grand écran.

## Technologies

- **Flutter** (Dart SDK `^3.11`), Material
- **flutter_bloc** pour l'état, **get_it** pour l'injection de dépendances, **go_router** pour la navigation
- **supabase_flutter** pour l'authentification, le stockage et les Edge Functions
- **dartz** (`Either`), **equatable**, **intl** (français), **fl_chart**, **image_picker**, **cached_network_image**

## Architecture

Clean architecture par fonctionnalité (`data`, `domain`, `presentation`).

```
lib/
├── core/
│   ├── merchant/      # MerchantApi (point d'entrée unique vers le serveur), parsing, upload photos
│   ├── di/            # service_locator.dart (get_it)
│   ├── routes/        # app_router.dart (go_router, onglets)
│   └── themes/        # AppColors
└── features/
    ├── auth/  dashboard/  inventory/  bookings/  stats/
    ├── availability/  ads/  shop/  profile/  main/
```

### Règle d'or : aucune requête directe aux tables

L'app n'appelle **jamais** `.from('table')`. Toutes les données passent par des **Edge Functions Supabase**, via `MerchantApi` (`lib/core/merchant/merchant_api.dart`). Le prix d'une campagne ou d'une commande est toujours calculé côté serveur, jamais envoyé par l'app.

| Fonction | Usage |
|---|---|
| `get-merchant-space` | Lecture : commerce, offres, commandes, réservations, statistiques |
| `create-offer`, `update-offer`, `update-offer-availability` | Offres et disponibilités |
| `update-order-status`, `update-reservation-status` | Statuts des commandes et réservations |
| `update-business` | Fiche de la boutique |
| `get-ad-campaigns`, `create-ad-campaign`, `update-ad-campaign` | Publicité |

`MerchantApi.space()` partage la requête en cours et garde la réponse 5 secondes, pour éviter plusieurs appels identiques à l'ouverture d'un écran.

## Authentification et rôles

- Un seul compte `auth.users` sert aux clients et aux commerçants.
- Un commerçant est un utilisateur lié à un commerce par une ligne `business_staff` active (rôles : `owner`, `manager`, `staff`, `kitchen`).
- Certaines actions sont réservées au propriétaire (modification de la boutique, campagnes).

## Installation

Prérequis : Flutter (stable), JDK 17, Android Studio ou VS Code.

```bash
git clone https://github.com/Vigorusaprk/baobab_b.git
cd baobab_b
flutter pub get
flutter run
```

Sous Windows, `JAVA_HOME` doit pointer vers le dossier du JDK (celui qui contient `bin`), par exemple `C:\Program Files\Android\Android Studio\jbr`. Vérifie avec `flutter doctor -v`.

## Configuration Supabase

L'URL et la clé publique (anon) sont dans `lib/core/constants/supabase_client.dart`. Ne mets **jamais** de clé `service_role` ni de fichier `.env` avec des secrets dans le dépôt.

## Conventions de code

- Fichiers de 100 lignes maximum : on découpe en widgets.
- Code commenté, en français.
- Prix en **dollars US ($)**.
- Les écrans ouverts avec `Navigator.push` doivent recevoir leur Bloc avec `BlocProvider.value(...)`.
- Thème : `AppColors` (beige `#F3EBDD`, vert `#254D32`, surface `#FAF8F3`).

## État du projet et à faire

- [x] Connexion à Supabase, données réelles (dashboard, commandes, stock)
- [x] Offres complètes avec upload de photo, disponibilités
- [x] Boutique (page + formulaire), publicité
- [ ] Rôles : masquer les écrans selon owner / manager / staff / kitchen
- [ ] Paiement Mobile Money des campagnes (le règlement ne doit s'activer que par confirmation de paiement)
- [ ] Notifications push (enregistrement du token FCM)
- [ ] Identifiant d'application définitif (remplacer `com.example.baobab_business`)
- [ ] Supprimer l'ancien dossier `backend/` et tout fichier `.env` du dépôt, puis renouveler les secrets concernés
- [ ] Remplacer le stockage du token dans SharedPreferences par la session Supabase
- [ ] Tests automatisés

## Écosystème Baobabe

| App | Rôle |
|---|---|
| **Baobabe** | App grand public : découverte, commandes, réservations |
| **Baobab Business** | App marchands (ce dépôt) |
| App livreurs | À venir |

## Licence

Projet privé. Tous droits réservés.