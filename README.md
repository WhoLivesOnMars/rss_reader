# Lecteur de flux RSS

## Présentation du projet
Ce projet est un lecteur de flux RSS développé dans le cadre d’un exercice technique.  
L’objectif est de proposer une application complète permettant d’ajouter, de consulter et de suivre plusieurs flux RSS en temps réel.  
Le projet est construit en deux parties :  
- une **API Ruby on Rails**, responsable de la récupération et du stockage des données,  
- une **interface frontend React**, qui permet à l’utilisateur d’interagir avec les flux.

---

## Fonctionnalités principales
- Ajout d’un nouveau flux RSS
- Lecture automatique et enregistrement des flux en base de données
- Affichage du contenu de chaque flux sur la même page
- Marquage des éléments comme lus ou non lus
- Pagination par groupes de 5 éléments
- Actualisation automatique des flux

---

## Technologies utilisées
**Backend**
- Ruby 3.4.7 / Rails 8.0.3
- Base de données : MySQL
- Gem `feedjira` pour la lecture des flux RSS
- Gem `whenever` pour la planification automatique
- Middleware `rack-cors` pour autoriser les requêtes depuis le front-end

**Frontend**
- React (avec Vite)
- Axios pour les requêtes API
- CSS modules pour le style
- Variables d’environnement via `.env.local`

---

## Installation et lancement

### 1. API Rails
```bash
cd rss_reader_api
bundle install
bin/rails db:create db:migrate
bin/rails s
```

Le serveur est accessible sur http://localhost:3000

**Tâche planifiée**

Le système interroge automatiquement les flux enregistrés à intervalles réguliers.
Pour activer le cron :
```bash
bundle exec whenever --update-crontab
sudo service cron restart
```

Les journaux se trouvent dans log/cron.log.

### 2. Interface React
```bash
cd ../rss_reader_front
npm install
cp .env.example .env.local
```

Fichier .env.local :
```bash
VITE_API_BASE_URL=http://localhost:3000/api/v1
```

Démarrage du front :
```bash
npm run dev
```

L’application est accessible sur http://localhost:5173

## Choix techniques
### Backend (Ruby on Rails)

- Application développée avec Ruby on Rails 8 et Ruby 3.4, demandé dans le sujet pour la partie serveur.
- Base de données MySQL, utilisée pour stocker les flux et les articles.
- Lecture et enregistrement des flux RSS réalisés avec Feedjira, permettant de gérer différents formats RSS et Atom.
- Tâche planifiée via whenever + cron, utilisée pour actualiser régulièrement les flux automatiquement.
- Middleware rack-cors, nécessaire pour autoriser les requêtes provenant du front-end exécuté sur un autre port (localhost:5173).
- Endpoints principaux : /feeds, /feed_items, /feed_items/:id/toggle_read.

### Frontend (React + Vite)

- Interface développée avec React et configurée via Vite, demandé dans le sujet pour la partie front-end.
- Requêtes asynchrones (AJAX) effectuées avec Axios vers l’API Rails, permettant de mettre à jour les données sans rechargement de page.
- Pagination par paquets de cinq éléments, implémentée selon les consignes pour faciliter la lecture.
- Variables d’environnement gérées via .env.local - simplifient la configuration de l’API selon l’environnement.

## Difficultés rencontrées

- Problème de CORS : les premières requêtes du front étaient bloquées par la politique de sécurité du navigateur.
  Solution : ajout du middleware rack-cors dans la configuration de Rails, avec les origines localhost et 127.0.0.1.

- Tâche cron non exécutée : la commande bundle exec n’était pas reconnue par le démon cron.
  Solution : création d’un script shell (fetch_feeds.sh) avec chemins absolus et écriture des logs dans log/cron_probe.txt.

- Variables d’environnement côté front : import.meta.env ne renvoyait rien.
  Solution : déplacement de la configuration dans un fichier .env.local, puis redémarrage du serveur Vite.

- Parsing de certains flux RSS : certains flux ne contenaient pas de guid ou avaient des champs HTML non standardisés.
  Solution : utilisation d’un identifiant de secours (entry_id || url || link) et nettoyage du texte avant affichage.