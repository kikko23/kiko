# Scripts Kiko - Automatisation OBS & Streaming Local

Ce dossier contient des scripts bash pour simplifier la gestion de votre serveur de streaming local et de votre configuration OBS.

## 📋 Liste des scripts

### 🚀 setup.sh
**Configuration initiale du projet**

Premier script à exécuter pour installer toutes les dépendances nécessaires.

```bash
./setup.sh
```

**Fonctionnalités:**
- Détection automatique de l'OS (Linux/macOS/Windows)
- Installation de OBS Studio
- Installation de Nginx avec module RTMP
- Installation de FFmpeg et VLC
- Configuration des dossiers nécessaires
- Création d'assets de test
- Configuration des permissions

**Quand l'utiliser:** Au premier démarrage du projet

---

### 🎬 start_rtmp_server.sh
**Démarrage du serveur RTMP**

Démarre le serveur Nginx RTMP pour recevoir les streams d'OBS.

```bash
./start_rtmp_server.sh
```

**Fonctionnalités:**
- Vérifie l'installation de Nginx et du module RTMP
- Crée les dossiers nécessaires (/var/www/recordings, /tmp/hls)
- Démarre le service Nginx
- Vérifie que le port 1935 (RTMP) est ouvert
- Affiche les URLs de streaming et de visualisation
- Affiche les IPs locales pour accès réseau

**Sortie typique:**
```
✅ Serveur RTMP démarré avec succès!

Configuration OBS:
Service: Personnalisé
Serveur: rtmp://localhost/live
Clé: votre_nom_de_stream

Lecture du stream:
VLC: vlc rtmp://localhost/live/votre_nom_de_stream
FFplay: ffplay rtmp://localhost/live/votre_nom_de_stream

Stats: http://localhost:8080/stat
HLS: http://localhost:8080/hls/votre_nom_de_stream.m3u8
```

---

### 📊 monitor_stream.sh
**Monitoring en temps réel du stream**

Affiche les statistiques en temps réel de vos streams actifs.

```bash
./monitor_stream.sh
```

**Fonctionnalités:**
- Affiche les streams actifs
- Bande passante entrante/sortante
- Statistiques vidéo et audio
- Rafraîchissement toutes les 2 secondes
- Interface en terminal

**Exemple de sortie:**
```
📊 Statistiques serveur
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Streams actifs: 1

📺 Streams en cours:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Stream: monstream
  Bande passante entrante: 3.2 MB/s
  Bande passante sortante: 1.5 MB/s
  Vidéo: 3.0 MB/s
  Audio: 160 KB/s
```

**Quand l'utiliser:** Pendant le streaming pour surveiller les performances

---

### 🧪 test_stream.sh
**Tests du serveur RTMP**

Suite de tests pour valider votre configuration de streaming.

```bash
./test_stream.sh [nom_du_stream]
```

**Fonctionnalités:**
1. **Test de connexion** - Vérifie que le serveur RTMP accepte les connexions
2. **Stream de test** - Envoie une barre de couleur avec son de test
3. **Stream fichier** - Envoie un fichier vidéo vers le serveur
4. **Analyse stream** - Affiche les informations d'un stream actif
5. **Test de latence** - Mesure la latence du stream

**Menu interactif:**
```
Choisissez un test:

1) Tester la connexion (probe)
2) Envoyer un stream de test (barre de couleur + son)
3) Envoyer un fichier vidéo
4) Analyser un stream existant
5) Test de latence
```

**Exemples:**
```bash
# Test rapide de connexion
./test_stream.sh monstream

# Puis choisir option 1 dans le menu
```

---

### 📺 view_stream.sh
**Visualisation du stream**

Lance un lecteur vidéo pour visualiser le stream RTMP.

```bash
./view_stream.sh [nom_du_stream] [player]
```

**Paramètres:**
- `nom_du_stream`: Nom du stream (demandé si non fourni)
- `player`: vlc, ffplay, mpv, ou auto (défaut: auto)

**Fonctionnalités:**
- Détection automatique du lecteur disponible
- Configuration optimisée pour faible latence
- Support VLC, FFplay, MPV

**Exemples:**
```bash
# Détection automatique du player
./view_stream.sh monstream

# Forcer VLC
./view_stream.sh monstream vlc

# Forcer FFplay (faible latence)
./view_stream.sh monstream ffplay

# Mode interactif
./view_stream.sh
```

---

### 💾 backup_obs_config.sh
**Sauvegarde et restauration de configuration OBS**

Gère les sauvegardes de votre configuration OBS complète.

```bash
./backup_obs_config.sh [backup|restore|export|menu]
```

**Modes:**
- `backup`: Crée une sauvegarde de la configuration OBS
- `restore`: Restaure une sauvegarde précédente
- `export`: Exporte uniquement les scènes
- `menu`: Menu interactif (par défaut)

**Fonctionnalités:**
- Sauvegarde complète (scènes, profils, paramètres)
- Restauration avec sauvegarde de sécurité automatique
- Export des scènes uniquement
- Liste des sauvegardes disponibles
- Archives compressées (.tar.gz)

**Exemples:**
```bash
# Mode menu interactif
./backup_obs_config.sh

# Sauvegarde directe
./backup_obs_config.sh backup

# Restauration
./backup_obs_config.sh restore

# Export des scènes
./backup_obs_config.sh export
```

**Emplacement des sauvegardes:** `../backups/`

---

## 🔧 Utilisation typique

### Premier lancement
```bash
# 1. Configuration initiale
./setup.sh

# 2. Démarrer le serveur RTMP
./start_rtmp_server.sh

# 3. Configurer OBS avec les paramètres affichés

# 4. Tester la connexion
./test_stream.sh test
```

### Workflow quotidien
```bash
# Démarrer le serveur
./start_rtmp_server.sh

# Monitorer dans un terminal
./monitor_stream.sh

# Visualiser dans un autre terminal
./view_stream.sh monstream

# Faire une sauvegarde après configuration
./backup_obs_config.sh backup
```

### Dépannage
```bash
# Tester si le serveur fonctionne
./test_stream.sh test

# Vérifier les streams actifs
./monitor_stream.sh

# Consulter la doc de dépannage
cat ../docs/TROUBLESHOOTING.md
```

## 📦 Prérequis

### Obligatoires
- **Bash** 4.0+
- **Nginx** avec module RTMP
- **OBS Studio**

### Recommandés
- **FFmpeg** (pour tests et analyse)
- **VLC** ou **FFplay** (pour visualisation)
- **curl** (pour monitoring)
- **netstat** ou **ss** (pour vérification ports)

Installation des prérequis:
```bash
# Ubuntu/Debian
sudo apt install nginx libnginx-mod-rtmp ffmpeg vlc curl net-tools

# macOS
brew install nginx-full --with-rtmp-module
brew install ffmpeg vlc
```

## ⚙️ Configuration

### Variables d'environnement
Vous pouvez personnaliser certains comportements avec des variables d'environnement:

```bash
# Port RTMP personnalisé (défaut: 1935)
export RTMP_PORT=1935

# Port HTTP pour stats (défaut: 8080)
export HTTP_PORT=8080

# Intervalle de rafraîchissement monitoring (défaut: 2s)
export REFRESH_INTERVAL=2
```

### Personnalisation des scripts

Les scripts sont conçus pour être modifiés. Variables communes en début de fichier:

```bash
# Exemple dans start_rtmp_server.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Vous pouvez modifier les chemins selon votre config
```

## 🐛 Dépannage

### Script ne démarre pas
```bash
# Vérifier les permissions
ls -l *.sh

# Rendre exécutable
chmod +x *.sh
```

### Erreurs de commandes non trouvées
```bash
# Vérifier installation
which nginx ffmpeg vlc

# Installer les packages manquants
sudo apt install [package-manquant]
```

### Problèmes de permissions
```bash
# Certains scripts nécessitent sudo
sudo ./start_rtmp_server.sh

# Ou ajouter votre user au groupe www-data
sudo usermod -a -G www-data $USER
```

### Logs et debugging
```bash
# Activer mode verbose bash
bash -x ./script.sh

# Vérifier logs système
sudo journalctl -u nginx -n 50

# Vérifier logs Nginx
sudo tail -f /var/log/nginx/error.log
```

## 📝 Développement

### Ajouter un nouveau script

Template de base:
```bash
#!/bin/bash

# Description du script
# Usage: ./mon_script.sh [args]

set -e  # Arrêter en cas d'erreur

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "======================================"
echo "  Titre du script"
echo "======================================"
echo ""

# Votre code ici

echo ""
echo "✨ Terminé!"
```

### Bonnes pratiques
- Toujours utiliser `set -e` pour arrêter en cas d'erreur
- Vérifier les prérequis avec `command -v`
- Afficher des messages clairs avec emoji
- Fournir des exemples d'utilisation
- Gérer les erreurs avec des messages explicites

## 🤝 Contribution

Pour améliorer ces scripts:

1. Testez sur votre système
2. Documentez vos modifications
3. Ajoutez des commentaires dans le code
4. Mettez à jour ce README si nécessaire

## 📚 Ressources

- [Documentation complète](../docs/OBS_GUIDE.md)
- [Guide streaming local](../docs/STREAMING_LOCAL.md)
- [Dépannage](../docs/TROUBLESHOOTING.md)
- [Nginx RTMP Module](https://github.com/arut/nginx-rtmp-module)

## 📄 Licence

Ces scripts sont fournis tels quels pour le projet Kiko.
Utilisez-les et modifiez-les librement pour vos besoins.
