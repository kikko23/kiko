# Profils de Configuration Recommandés pour OBS

Ce document contient des configurations optimisées pour différents cas d'usage.

## 📋 Table des matières

1. [Gaming - Performance](#gaming---performance)
2. [Gaming - Qualité](#gaming---qualité)
3. [Bureau/Tutorial - 1080p](#bureaututorial---1080p)
4. [Bureau/Tutorial - 720p](#bureaututorial---720p)
5. [Podcast Vidéo](#podcast-vidéo)
6. [Présentation Pro](#présentation-pro)
7. [IRL/Webcam Only](#irlwebcam-only)
8. [Multi-caméras](#multi-caméras)
9. [Faible latence](#faible-latence)
10. [Enregistrement local haute qualité](#enregistrement-local-haute-qualité)

---

## Gaming - Performance

**Objectif:** Streamer des jeux avec impact minimal sur les performances

### Paramètres Vidéo
```
Résolution de base: 1920x1080
Résolution de sortie: 1280x720 (720p)
Filtre de mise à l'échelle: Bilinéaire (plus rapide)
FPS: 30
```

### Paramètres Sortie
```
Mode: Avancé
Onglet Streaming:
  Encodeur: NVENC H.264 (ou QuickSync/AMD selon GPU)
  Contrôle du débit: CBR
  Débit: 3000 Kbps
  Intervalle d'image clé: 2
  Preset: Performance (ou Quality si possible)
  Profile: high
  Look-ahead: Désactivé (pour moins de latence)
  Psycho Visual Tuning: Désactivé
```

### Paramètres Audio
```
Taux d'échantillonnage: 48 kHz
Canaux: Stéréo
Débit audio Bureau: 160 kbps
Débit audio Micro: 128 kbps
```

### Paramètres Avancés
```
Priorité du processus: Haute
Rendu: Direct3D 11 (Windows) / Metal (macOS)
```

### Sources
1. Capture de jeu (mode plein écran)
2. Audio du bureau
3. Micro
4. (Optionnel) Webcam 320x180

**Matériel requis:** GPU Nvidia GTX 1660+, AMD RX 5600+, ou Intel avec QuickSync

---

## Gaming - Qualité

**Objectif:** Meilleure qualité visuelle pour le gaming

### Paramètres Vidéo
```
Résolution de base: 1920x1080
Résolution de sortie: 1920x1080 (1080p)
Filtre de mise à l'échelle: Lancz (qualité)
FPS: 60
```

### Paramètres Sortie
```
Mode: Avancé
Onglet Streaming:
  Encodeur: NVENC H.264
  Contrôle du débit: CBR
  Débit: 6000 Kbps
  Intervalle d'image clé: 2
  Preset: Quality
  Profile: high
  Look-ahead: Activé
  Psycho Visual Tuning: Activé
```

### Paramètres Audio
```
Taux d'échantillonnage: 48 kHz
Canaux: Stéréo
Débit audio Bureau: 192 kbps
Débit audio Micro: 160 kbps
```

### Filtres Recommandés
**Pour la webcam:**
- Chroma Key (si fond vert)
- Correction de couleur
- Netteté

**Pour le micro:**
- Suppression de bruit
- Compresseur
- Gain (si nécessaire)

**Matériel requis:** GPU Nvidia RTX 2060+, CPU 6 cores+, 16 GB RAM

---

## Bureau/Tutorial - 1080p

**Objectif:** Tutoriels, présentations, partage d'écran

### Paramètres Vidéo
```
Résolution de base: 1920x1080
Résolution de sortie: 1920x1080
Filtre: Lancz
FPS: 30
```

### Paramètres Sortie
```
Mode: Simple
Encodeur: x264
Débit: 3500 Kbps
Préréglage: veryfast
```

OU Mode Avancé:
```
Encodeur: x264
Contrôle: CBR
Débit: 3500 Kbps
Intervalle clé: 2
Préréglage CPU: veryfast
Accordage: zerolatency
Profile: main
```

### Paramètres Audio
```
Taux d'échantillonnage: 48 kHz
Canaux: Stéréo
Débit audio Bureau: 160 kbps
Débit audio Micro: 160 kbps (important pour voix claire)
```

### Sources Recommandées
1. Capture d'écran (moniteur principal)
2. Webcam (optionnel, coin)
3. Logo/Watermark
4. Texte (titre, informations)
5. Audio micro (haute qualité)

### Filtres Audio Micro
1. Suppression de bruit (-30 dB)
2. Porte de bruit (-40 dB)
3. Compresseur (Ratio: 3:1, Threshold: -18 dB)
4. Égaliseur (boost 2-4 kHz pour clarté voix)
5. Limiteur (-3 dB)

**Matériel requis:** CPU moderne 4+ cores, Micro USB de qualité

---

## Bureau/Tutorial - 720p

**Objectif:** Même chose mais moins gourmand

### Paramètres Vidéo
```
Résolution de base: 1920x1080
Résolution de sortie: 1280x720
FPS: 30
```

### Paramètres Sortie
```
Encodeur: x264
Débit: 2500 Kbps
Préréglage: veryfast
```

Reste identique au profil 1080p mais avec charge CPU/bande passante réduite.

---

## Podcast Vidéo

**Objectif:** Discussion, interview, podcast avec vidéo

### Paramètres Vidéo
```
Résolution de base: 1920x1080
Résolution de sortie: 1280x720
FPS: 30 (suffisant pour visages)
```

### Paramètres Sortie
```
Encodeur: x264
Débit: 2500 Kbps (pas besoin de plus)
Préréglage: medium (qualité image visages)
Profile: main
```

### Paramètres Audio (PRIORITÉ)
```
Taux d'échantillonnage: 48 kHz
Canaux: Stéréo

Micro hôte:
  Débit: 192 kbps
  Filtres:
    - Suppression de bruit
    - Compresseur (ratio 4:1)
    - Égaliseur (voix radio)
    - Limiteur

Micro invité(s):
  Débit: 160 kbps
  Mêmes filtres

Musique de fond (optionnel):
  Débit: 128 kbps
  Volume: -20 dB quand on parle
```

### Scènes Recommandées
1. **Intro** - Logo + musique
2. **Hôte seul** - Webcam centrée grande
3. **Hôte + Invité** - Split screen
4. **Tous** - Multi-caméras mosaïque
5. **Partage d'écran** - Pour montrer contenu
6. **Pause** - Image + musique
7. **Outro** - Remerciements + prochains épisodes

### Sources
- Webcam(s) haute qualité
- Sources texte (noms, sujets)
- Logos
- Fond professionnel (uni ou flou)
- Musique intro/outro
- Timer (durée épisode)

**Matériel recommandé:**
- Micros USB professionnels (Blue Yeti, Audio-Technica AT2020)
- Webcam 1080p (Logitech C920+)
- Éclairage (ring light)
- Fond uni ou green screen

---

## Présentation Pro

**Objectif:** Webinaires, présentations d'entreprise

### Paramètres Vidéo
```
Résolution: 1920x1080
FPS: 30
```

### Paramètres Sortie
```
Encodeur: x264
Débit: 4000 Kbps
Préréglage: medium
Profile: high
```

### Scènes Type
1. **Accueil** - Logo entreprise + titre
2. **Présentateur seul** - Webcam + nom + titre
3. **Slides plein écran** - Capture PowerPoint
4. **Picture-in-Picture** - Slides + présentateur coin
5. **Démo** - Capture d'écran application
6. **Questions** - Layout discussion

### Sources Professionnelles
- Logo entreprise (haute résolution)
- Webcam HD avec bon éclairage
- Capture PowerPoint/Keynote
- Texte: Nom, titre, entreprise
- Timer de présentation
- Indicateur Q&A
- Fond professionnel

### Transitions
```
Durée: 300ms
Type: Fondu
Entre toutes les scènes
```

### Audio Prioritaire
- Micro-cravate ou micro studio
- Suppression de bruit agressive
- Compresseur pour volume constant
- Pas de musique de fond (distraction)

**Setup recommandé:**
- Éclairage 3 points
- Fond neutre ou logo subtil
- Micro-cravate sans fil
- Contrôleur Stream Deck pour transitions

---

## IRL/Webcam Only

**Objectif:** Stream type vlog, just chatting

### Paramètres Vidéo
```
Résolution: 1920x1080 ou 1280x720
FPS: 30
```

### Paramètres Sortie
```
Encodeur: NVENC ou x264
Débit: 2500-3000 Kbps
Preset: Quality (NVENC) ou fast (x264)
```

### Sources
1. Webcam (plein écran ou grande)
2. Micro
3. Overlay (bordure, nom)
4. Chat (si applicable)
5. Musique de fond douce (-25 dB)
6. Alertes/Notifications

### Scènes
1. **Principal** - Caméra + overlay
2. **BRB** - Image + musique
3. **Ending** - Merci + réseaux sociaux

### Optimisations
- Fond esthétique (étagères, plantes, posters)
- Éclairage soigné (pas de contre-jour)
- Cadrage flattering (règle des tiers)
- Micro proche et de qualité

---

## Multi-caméras

**Objectif:** Production multi-angles

### Paramètres Vidéo
```
Résolution: 1920x1080
FPS: 30
```

### Paramètres Sortie
```
Encodeur: NVENC (moins de charge)
Débit: 5000 Kbps
```

### Configuration
**Caméras:**
1. Caméra principale (face)
2. Caméra secondaire (profil/wide)
3. Caméra overhead (pour démonstrations)
4. Capture d'écran

**Scènes:**
1. Vue 1 (caméra principale plein écran)
2. Vue 2 (caméra secondaire plein écran)
3. Vue 3 (overhead)
4. Split 2 caméras
5. Picture-in-picture (principale + secondaire)
6. Toutes caméras (grille)

**Plugin Recommandé:**
- Advanced Scene Switcher (changement auto)
- Source Copy (synchroniser filtres)

**Astuce:** Utiliser les groupes pour appliquer filtres/effets à toutes caméras

---

## Faible latence

**Objectif:** Latence minimale (<2s) pour interaction temps réel

### Paramètres Vidéo
```
Résolution: 1280x720 (moins de traitement)
FPS: 30
```

### Paramètres Sortie - Streaming
```
Encodeur: NVENC ou x264
Débit: 3000 Kbps
Intervalle clé: 1 seconde (au lieu de 2)
Accordage: zerolatency
Profile: baseline (au lieu de high)
```

### Paramètres Avancés
```
Réseau:
  Activer "TCP pacing"
  Activer "Réduire la latence réseau au minimum"

Process Priority: Haute
```

### Configuration Serveur (SRT)
Au lieu de RTMP, utiliser SRT:
```
Service: Personnalisé
Serveur: srt://IP:9998
Options: ?mode=caller&latency=200
```

### Lecture côté client
```bash
# VLC ou FFplay avec options faible latence
ffplay -fflags nobuffer -flags low_delay -framedrop \
  srt://localhost:9998
```

**Latence attendue:** 500-1500ms (vs 3-5s en RTMP)

---

## Enregistrement local haute qualité

**Objectif:** Enregistrer en local avec qualité maximale

### Paramètres Sortie - Enregistrement
```
Mode: Avancé
Onglet Enregistrement:
  Type: Standard
  Format: mkv (plus sûr que mp4)
  Encodeur: NVENC H.264 (ou x264)
  Contrôle: CQP (Constant Quality)
  CQ Level: 18 (très haute qualité, 14-18 = quasi-lossless)
  Intervalle clé: 0 (automatique)
  Preset: Quality (NVENC) ou medium/slow (x264)
  Profile: high
```

OU pour qualité extrême:
```
Encodeur: x264
Contrôle: CRF
CRF: 15-18
Préréglage: slow ou slower
Profile: high
```

### Paramètres Audio
```
Pistes audio:
  Piste 1: Master (tout mixé)
  Piste 2: Bureau seul
  Piste 3: Micro seul
  Piste 4: Musique/autres

Débit: 320 kbps (audio haute qualité)
Format: AAC ou FLAC (lossless)
```

### Avantages multi-pistes
- Édition post-production facilitée
- Ajuster volumes séparément
- Remplacer audio si problème

### Espace disque requis
```
CQP 18, 1080p 60fps:
~10-20 GB/heure selon contenu

CQP 15, 1080p 60fps:
~20-40 GB/heure
```

**Recommandation:** Enregistrer sur SSD rapide, pas HDD

---

## 🎯 Comment choisir son profil

### Par matériel

**PC entrée de gamme** (4 cores, GPU intégré):
- Bureau/Tutorial 720p
- IRL/Webcam 720p

**PC milieu de gamme** (6 cores, GPU dédié):
- Gaming Performance
- Bureau/Tutorial 1080p
- Podcast Vidéo

**PC haut de gamme** (8+ cores, RTX GPU):
- Gaming Qualité
- Multi-caméras
- Enregistrement haute qualité

### Par usage

**Interaction en direct:** Faible latence
**Archive/VOD:** Enregistrement haute qualité
**Démonstration:** Bureau/Tutorial
**Divertissement:** Gaming
**Professionnel:** Présentation Pro

### Par bande passante

**Upload <5 Mbps:** 720p 30fps, 2500 Kbps
**Upload 5-10 Mbps:** 1080p 30fps, 4000 Kbps
**Upload >10 Mbps:** 1080p 60fps, 6000 Kbps

---

## 📝 Templates de configuration

Les profils ci-dessus peuvent être sauvegardés dans OBS:

1. Configurer selon un profil
2. **Profil → Nouveau** → Nommer (ex: "Gaming-Performance")
3. Recommencer pour chaque profil
4. Basculer avec **Profil → [Nom]**

Chaque profil garde:
- Paramètres sortie
- Paramètres vidéo/audio
- Paramètres avancés

**Note:** Les scènes sont dans les "Collections de scènes" (séparé des profils)

---

## 🔧 Scripts pour profils

Créer des presets rapidement:

```bash
# Voir backup_obs_config.sh pour sauvegarder/restaurer
cd scripts/
./backup_obs_config.sh backup
```

Cela sauvegarde TOUT (profils + scènes).

---

## 📊 Tableau récapitulatif

| Profil | Résolution | FPS | Encodeur | Débit | CPU | Use Case |
|--------|-----------|-----|----------|-------|-----|----------|
| Gaming Perf | 720p | 30 | NVENC | 3000 | Faible | Jeux compétitifs |
| Gaming Qualité | 1080p | 60 | NVENC | 6000 | Moyen | Jeux AAA showcase |
| Bureau 1080p | 1080p | 30 | x264 | 3500 | Moyen | Tutoriels, code |
| Bureau 720p | 720p | 30 | x264 | 2500 | Faible | Tutoriels simple |
| Podcast | 720p | 30 | x264 | 2500 | Faible | Discussion |
| Présentation | 1080p | 30 | x264 | 4000 | Moyen | Entreprise |
| IRL | 1080p | 30 | NVENC | 3000 | Faible | Webcam |
| Multi-cam | 1080p | 30 | NVENC | 5000 | Élevé | Production |
| Faible latence | 720p | 30 | NVENC | 3000 | Faible | Interactif |
| Recording HQ | 1080p | 60 | x264 CRF | Local | Élevé | Archive |

---

Utilisez ces profils comme base et ajustez selon vos besoins spécifiques et votre matériel!
