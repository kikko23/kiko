# Démarrage Rapide - Streaming Local en 10 minutes

Ce guide vous permet de configurer rapidement un système de streaming local avec OBS Studio.

## ⏱️ Durée estimée: 10-15 minutes

## 📋 Prérequis

- Un ordinateur sous Linux, macOS ou Windows
- Connexion Internet pour télécharger les logiciels
- 5 GB d'espace disque libre

## 🚀 Étape 1: Installation (5 min)

### Linux (Ubuntu/Debian)
```bash
# Cloner ou télécharger le projet
cd ~/kiko

# Exécuter le script de configuration
cd scripts
chmod +x setup.sh
./setup.sh
```

Le script installera automatiquement:
- OBS Studio
- Nginx avec module RTMP
- FFmpeg
- VLC

### macOS
```bash
# Installer Homebrew si nécessaire
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Puis exécuter le script setup
cd ~/kiko/scripts
chmod +x setup.sh
./setup.sh
```

### Windows
1. Télécharger et installer [OBS Studio](https://obsproject.com/download)
2. Télécharger [Nginx RTMP pour Windows](https://github.com/illuspas/nginx-rtmp-win32)
3. Extraire Nginx dans `C:\nginx`
4. Copier le contenu de `configs/nginx-rtmp.conf` dans `C:\nginx\conf\nginx.conf`

## 🎬 Étape 2: Démarrer le serveur RTMP (1 min)

```bash
cd ~/kiko/scripts
./start_rtmp_server.sh
```

Vous devriez voir:
```
✅ Serveur RTMP démarré avec succès!

Configuration OBS:
Serveur: rtmp://localhost/live
Clé: votre_stream
```

**Gardez cette fenêtre de terminal ouverte.**

## ⚙️ Étape 3: Configurer OBS (3 min)

### 3.1 Lancer OBS Studio
```bash
obs
```

### 3.2 Premier lancement - Assistant de configuration
Si c'est votre premier lancement:
1. Choisir "Optimiser pour l'enregistrement"
2. Résolution: 1920x1080 (ou votre résolution native)
3. FPS: 30
4. Cliquer "Suivant" jusqu'à la fin

### 3.3 Configuration du Stream

1. **Fichier → Paramètres → Stream**
   ```
   Service: Personnalisé
   Serveur: rtmp://localhost/live
   Clé de stream: monstream
   ```

2. **Paramètres → Sortie**
   - Mode: Simple
   - Débit vidéo: 3000 Kbps
   - Encodeur: x264 (ou NVENC si GPU Nvidia)

3. **Paramètres → Vidéo**
   ```
   Résolution de base: 1920x1080
   Résolution de sortie: 1920x1080
   FPS: 30
   ```

4. **Paramètres → Audio**
   ```
   Taux d'échantillonnage: 48 kHz
   Canaux: Stéréo
   ```

5. **Cliquer "Appliquer" puis "OK"**

### 3.4 Ajouter des sources

**Scène de bureau simple:**

1. Dans "Sources", cliquer le `+`
2. Ajouter "Capture d'écran"
   - Nom: "Mon écran"
   - OK → OK

3. (Optionnel) Ajouter webcam:
   - `+` → "Périphérique de capture vidéo"
   - Nom: "Webcam"
   - Sélectionner votre webcam
   - OK

4. Ajuster la taille de la webcam (coin inférieur droit recommandé)

## 🎥 Étape 4: Démarrer le Stream (1 min)

1. Dans OBS, cliquer sur **"Démarrer le streaming"**
2. Le bouton devrait devenir rouge: "Arrêter le streaming"
3. Vérifier dans OBS en bas à droite:
   - ⚫ 0 frames perdus = ✅ Bon
   - Débit (Kbps) doit être stable

## 📺 Étape 5: Visualiser le Stream (1 min)

### Option 1: Avec VLC
```bash
vlc rtmp://localhost/live/monstream
```

### Option 2: Avec le script
Ouvrir un nouveau terminal:
```bash
cd ~/kiko/scripts
./view_stream.sh monstream
```

### Option 3: Dans le navigateur
1. Ouvrir `configs/stream-viewer.html` dans votre navigateur
2. Ou aller sur `http://localhost:8080/hls/monstream.m3u8` (si HLS configuré)

**Vous devriez maintenant voir votre stream!**

## 🎉 Félicitations!

Votre système de streaming local est opérationnel!

## 📊 Monitoring (Optionnel)

Dans un nouveau terminal:
```bash
cd ~/kiko/scripts
./monitor_stream.sh
```

Cela affichera les statistiques en temps réel de votre stream.

## 🔧 Configuration avancée

### Améliorer la qualité

**Pour meilleure qualité (plus de charge CPU):**
```
OBS → Paramètres → Sortie
Mode: Avancé
Onglet Streaming:
  Débit: 6000 Kbps
  Préréglage: medium
  Profile: high
```

### Réduire la latence

**Pour latence minimale (~2 secondes):**
```
Paramètres → Sortie → Streaming
Accordage: zerolatency
Intervalle d'image clé: 1

Paramètres → Avancé
Réduire la latence réseau: ✅
```

### Ajouter plusieurs scènes

1. Dans "Scènes", cliquer le `+`
2. Créer "Pause", "Gaming", "Bureau", etc.
3. Basculer entre scènes pendant le stream

**Raccourcis clavier recommandés:**
```
Fichier → Paramètres → Raccourcis clavier

Démarrer/Arrêter streaming: F10
Scène suivante: Page Down
Scène précédente: Page Up
Couper le micro: F9
```

## 🌐 Accès depuis le réseau local

### Trouver votre IP locale

```bash
# Linux/Mac
ip addr show | grep inet

# Windows
ipconfig
```

Exemple: `192.168.1.100`

### Configurer OBS pour réseau local

```
Paramètres → Stream
Serveur: rtmp://192.168.1.100/live
Clé: monstream
```

### Visualiser depuis autre appareil

Sur un autre PC/téléphone/tablette sur le même réseau:
```
vlc rtmp://192.168.1.100/live/monstream
```

**Ou dans navigateur:** `http://192.168.1.100:8080/hls/monstream.m3u8`

### Ouvrir le pare-feu

```bash
# Linux
sudo ufw allow 1935/tcp
sudo ufw allow 8080/tcp

# Windows
Panneau de configuration → Pare-feu Windows
Règles entrantes → Nouvelle règle → Port → TCP → 1935, 8080
```

## 🎯 Cas d'usage courants

### 1. Streamer un jeu

**Sources recommandées:**
```
1. Capture de jeu (plein écran)
2. Webcam (320x180, coin bas droit)
3. Audio micro
4. Audio jeu
```

**Paramètres:**
```
Résolution: 1920x1080 ou 1280x720
FPS: 60 (si PC puissant) ou 30
Encodeur: NVENC (Nvidia) pour performances
Débit: 4000-6000 Kbps
```

### 2. Présentation/Tutorial

**Sources recommandées:**
```
1. Capture d'écran
2. Webcam (optionnel)
3. Audio micro
```

**Paramètres:**
```
Résolution: 1920x1080
FPS: 30
Encodeur: x264
Débit: 2500-3500 Kbps
```

### 3. Podcast vidéo

**Sources recommandées:**
```
1. Webcam (centrée, grande)
2. Fond uni ou image
3. Audio micro haute qualité
4. Texte (nom, sujet)
```

**Paramètres:**
```
Résolution: 1280x720
FPS: 30
Encodeur: x264
Débit: 2000-3000 Kbps
Priorité: Audio haute qualité (160 kbps)
```

## 🐛 Problèmes courants

### "Failed to connect to server"
```bash
# Vérifier que le serveur RTMP est démarré
sudo systemctl status nginx
# Ou
netstat -tuln | grep 1935

# Redémarrer si nécessaire
sudo systemctl restart nginx
```

### Stream pixelisé
```
Augmenter le débit dans OBS:
Paramètres → Sortie → Débit: 4000-6000 Kbps
```

### Encodage surchargé
```
Réduire la charge:
1. Passer à 720p au lieu de 1080p
2. Passer à 30 FPS au lieu de 60
3. Utiliser NVENC au lieu de x264
4. Réduire le preset x264 à "veryfast"
```

### Pas de son
```
Vérifier dans OBS:
1. Mixeur audio en bas
2. Barres audio doivent bouger
3. Icône speaker ne doit pas être barré
4. Paramètres → Audio → Périphériques corrects
```

### Latence très élevée (>10s)
```
1. Utiliser protocole SRT au lieu de RTMP
2. Réduire le buffer
3. Activer zerolatency
4. Voir docs/STREAMING_LOCAL.md pour SRT
```

## 📚 Prochaines étapes

Maintenant que votre système fonctionne, explorez:

1. **[OBS_GUIDE.md](OBS_GUIDE.md)** - Documentation complète OBS
2. **[STREAMING_LOCAL.md](STREAMING_LOCAL.md)** - Techniques avancées (SRT, NDI, HLS)
3. **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Résolution de problèmes
4. **Scènes prédéfinies** dans `scenes/` - Exemples à importer
5. **Scripts** dans `scripts/` - Automatisation

## 🔗 Liens utiles

- [OBS Studio Documentation](https://obsproject.com/wiki/)
- [OBS Forum](https://obsproject.com/forum/)
- [r/obs Reddit](https://reddit.com/r/obs)
- [Nginx RTMP Module](https://github.com/arut/nginx-rtmp-module)

## 💡 Conseils

1. **Toujours tester avant un stream important**
2. **Faire des sauvegardes** de votre config OBS:
   ```bash
   cd ~/kiko/scripts
   ./backup_obs_config.sh backup
   ```
3. **Monitorer les stats** pendant le stream
4. **Commencer simple** puis ajouter des fonctionnalités
5. **Documenter vos paramètres** qui fonctionnent bien

## 🎓 Exercices pratiques

### Exercice 1: Scènes multiples (10 min)
1. Créer 3 scènes: "Démarrage", "Principal", "Pause"
2. Configurer des transitions entre scènes
3. Assigner des raccourcis clavier
4. Tester en direct

### Exercice 2: Overlay personnalisé (15 min)
1. Créer une image PNG transparente avec votre logo
2. L'ajouter comme source image
3. Positionner en overlay sur votre stream
4. Ajuster l'opacité

### Exercice 3: Streaming réseau (20 min)
1. Configurer le streaming sur IP locale
2. Visualiser depuis un autre appareil
3. Tester la latence
4. Optimiser les paramètres

## ✅ Checklist de vérification

Avant de streamer en production:

- [ ] Serveur RTMP démarré et fonctionnel
- [ ] OBS configuré avec bons paramètres
- [ ] Test du stream effectué et visionné
- [ ] Audio vérifié (micro et desktop)
- [ ] Pas de frames perdues dans OBS
- [ ] Latence acceptable (<5s pour RTMP)
- [ ] Scènes configurées et testées
- [ ] Raccourcis clavier configurés
- [ ] Sauvegarde de la config OBS effectuée
- [ ] Plan B en cas de problème

Bon streaming! 🎉
