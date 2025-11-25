# Guide Complet OBS Studio pour Streaming Local

## Table des matières
1. [Installation](#installation)
2. [Configuration de base](#configuration-de-base)
3. [Streaming local](#streaming-local)
4. [Sources et scènes](#sources-et-scènes)
5. [Paramètres optimaux](#paramètres-optimaux)
6. [Plugins essentiels](#plugins-essentiels)
7. [Troubleshooting](#troubleshooting)

## Installation

### Windows
```bash
# Via Chocolatey
choco install obs-studio

# Ou télécharger depuis: https://obsproject.com/download
```

### Linux (Ubuntu/Debian)
```bash
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install obs-studio
```

### macOS
```bash
# Via Homebrew
brew install --cask obs

# Ou télécharger depuis: https://obsproject.com/download
```

## Configuration de base

### Premier lancement
1. Ouvrir OBS Studio
2. Assistant de configuration automatique:
   - Choisir "Optimiser pour l'enregistrement"
   - Sélectionner votre résolution de base (1920x1080 recommandé)
   - Définir votre FPS (30 ou 60)

### Paramètres essentiels

#### Vidéo
```
Résolution de base: 1920x1080
Résolution de sortie: 1920x1080 (ou 1280x720 pour moins de charge)
FPS: 30 ou 60 (30 pour moins de charge CPU/GPU)
```

#### Sortie - Streaming
```
Encodeur: x264 (CPU) ou NVENC/AMD (GPU)
Débit: 2500-6000 Kbps pour local
Préréglage CPU: veryfast ou faster
Profile: main
```

#### Audio
```
Taux d'échantillonnage: 48 kHz
Canaux: Stéréo
Débit audio: 160 kbps
```

## Streaming local

### Option 1: Serveur RTMP avec Nginx

#### Installation Nginx avec RTMP
```bash
# Linux
sudo apt install nginx libnginx-mod-rtmp

# Configuration dans /etc/nginx/nginx.conf
rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        application live {
            live on;
            record off;
        }
    }
}
```

#### Configuration OBS
```
Type: Serveur de streaming personnalisé
Serveur: rtmp://localhost/live
Clé de stream: votre_cle_secrete
```

### Option 2: SRT (Simple Reliable Transport)
```
Mode: Listener
Port: 9998
```

### Option 3: Enregistrement local puis lecture
```
Format: mp4 ou mkv
Chemin: /home/user/videos/
Qualité: Identique au stream
```

## Sources et scènes

### Types de sources essentielles

#### 1. Capture d'écran
```
- Capture d'affichage: Capture tout l'écran
- Capture de fenêtre: Capture une fenêtre spécifique
- Capture de jeu: Pour les jeux (meilleure performance)
```

#### 2. Caméra
```
- Périphérique de capture vidéo
- Résolution: 1920x1080 ou 1280x720
- FPS: Correspondant à votre stream
```

#### 3. Audio
```
- Capture audio d'entrée: Microphone
- Capture audio de sortie: Son du système
```

#### 4. Sources visuelles
```
- Image: Logo, overlay
- Texte: Informations dynamiques
- Navigateur: Widgets web, alerts
- Couleur: Fond uni
```

### Exemple de scène complète

#### Scène "Gaming"
```
1. Capture de jeu (plein écran)
2. Webcam (coin inférieur droit, 320x240)
3. Overlay PNG (bordure)
4. Texte (nom du stream, en haut)
5. Audio micro + audio jeu
```

#### Scène "Pause"
```
1. Image de fond
2. Texte "De retour bientôt"
3. Musique (source média)
```

## Paramètres optimaux

### Pour streaming local haute qualité
```
Encodeur: x264
Preset: medium
Profile: high
Débit: 6000-10000 Kbps
Keyframe: 2 secondes
```

### Pour streaming local performance
```
Encodeur: NVENC (si GPU Nvidia) ou QuickSync (Intel)
Preset: quality
Débit: 3000-5000 Kbps
Résolution: 1280x720
FPS: 30
```

### Pour enregistrement local
```
Format: mkv (le plus sûr)
Encodeur: x264 ou hardware
Débit: 15000-40000 Kbps (plus élevé = meilleure qualité)
```

## Plugins essentiels

### 1. Advanced Scene Switcher
```
Automatisation du changement de scènes
Installation: Via OBS ou GitHub
```

### 2. Source Record
```
Enregistrer des sources individuelles
Utile pour clips séparés
```

### 3. Move Transition
```
Animations fluides entre sources
GitHub: exeldro/obs-move-transition
```

### 4. StreamFX
```
Filtres avancés, shaders
Effets visuels professionnels
```

### 5. VLC Video Source
```
Support de formats vidéo supplémentaires
Playlists
```

## Raccourcis clavier essentiels

```
Commencer/Arrêter streaming: Configurable
Commencer/Arrêter enregistrement: Configurable
Mode studio: Configurable
Scène précédente: Configurable
Scène suivante: Configurable
Couper le micro: Configurable
```

Configuration dans: Fichier → Paramètres → Raccourcis clavier

## Optimisations performance

### Réduire la charge CPU
1. Utiliser encodeur hardware (NVENC, QuickSync, AMF)
2. Réduire le preset x264 (ultrafast, superfast, veryfast)
3. Réduire la résolution de sortie
4. Réduire le FPS à 30
5. Fermer applications inutiles

### Réduire la charge GPU
1. Désactiver l'aperçu quand non nécessaire
2. Utiliser encodeur CPU (x264)
3. Réduire le nombre de sources navigateur
4. Limiter les filtres et effets

## Troubleshooting

### Stream saccadé
- Vérifier le débit réseau
- Réduire la qualité d'encodage
- Changer de preset encodeur
- Vérifier la charge CPU/GPU

### Audio désynchronisé
- Utiliser le décalage audio dans les propriétés
- Activer "Horodatage basé sur le temps du système"
- Vérifier le taux d'échantillonnage (48 kHz partout)

### OBS crash
- Mettre à jour les drivers graphiques
- Désactiver les plugins un par un
- Exécuter OBS en administrateur
- Vérifier les logs: Aide → Fichiers de log

### Latence élevée
- Réduire le buffer audio
- Utiliser SRT au lieu de RTMP
- Vérifier la charge réseau
- Optimiser les paramètres d'encodage

## Fichiers de configuration OBS

### Emplacement
```
Windows: %appdata%\obs-studio
Linux: ~/.config/obs-studio
macOS: ~/Library/Application Support/obs-studio
```

### Fichiers importants
```
basic/scenes/*.json: Scènes
basic/profiles/*: Profils
global.ini: Configuration globale
```

## Commandes utiles

### Ligne de commande OBS
```bash
# Démarrer avec un profil spécifique
obs --profile "MonProfil"

# Démarrer avec une collection de scènes
obs --collection "MesScenes"

# Démarrer streaming automatiquement
obs --startstreaming

# Mode portable
obs --portable
```

## Ressources supplémentaires

### Documentation officielle
- https://obsproject.com/wiki/
- https://github.com/obsproject/obs-studio

### Communauté
- Reddit: r/obs
- Discord: OBS Studio Community
- Forum: https://obsproject.com/forum/

### Tutoriels vidéo
- Chaîne YouTube OBS officielle
- EposVox (expert OBS)

## Bonnes pratiques

1. **Toujours tester avant un stream important**
2. **Faire des sauvegardes de vos scènes**
3. **Utiliser des profils différents pour différents usages**
4. **Monitorer les stats OBS (charge CPU, FPS perdus)**
5. **Garder OBS et les drivers à jour**
6. **Utiliser des raccourcis clavier pour efficacité**
7. **Prévisualiser avec le mode studio**
8. **Organiser vos sources en groupes**
