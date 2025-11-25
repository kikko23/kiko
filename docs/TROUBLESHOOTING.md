# Guide de dépannage OBS Studio & Streaming Local

## Table des matières
1. [Problèmes de connexion](#problèmes-de-connexion)
2. [Problèmes de qualité](#problèmes-de-qualité)
3. [Problèmes audio](#problèmes-audio)
4. [Problèmes de performance](#problèmes-de-performance)
5. [Problèmes OBS](#problèmes-obs)
6. [Problèmes serveur RTMP](#problèmes-serveur-rtmp)

## Problèmes de connexion

### OBS ne peut pas se connecter au serveur RTMP

**Symptômes:**
- Message "Failed to connect to server"
- OBS indique qu'il ne peut pas démarrer le stream

**Solutions:**

1. **Vérifier que le serveur RTMP est démarré**
   ```bash
   # Linux/Mac
   sudo systemctl status nginx
   # ou
   netstat -tuln | grep 1935

   # Windows
   netstat -an | findstr 1935
   ```

2. **Vérifier la configuration OBS**
   - Service: Personnalisé
   - Serveur: `rtmp://localhost/live` (pas `rtmp://localhost:1935/live`)
   - Clé de stream: n'importe quoi (ex: `monstream`)

3. **Vérifier le pare-feu**
   ```bash
   # Linux
   sudo ufw status
   sudo ufw allow 1935/tcp

   # Windows
   # Panneau de configuration → Pare-feu Windows → Règles entrantes
   # Autoriser le port 1935 TCP
   ```

4. **Vérifier les logs Nginx**
   ```bash
   sudo tail -f /var/log/nginx/error.log
   ```

5. **Tester la connexion manuellement**
   ```bash
   ffmpeg -re -f lavfi -i testsrc=size=640x480:rate=30 \
     -f flv rtmp://localhost/live/test
   ```

### Impossible de voir le stream avec VLC

**Symptômes:**
- VLC affiche "Impossible de lire le média"
- Écran noir dans VLC

**Solutions:**

1. **Vérifier que le stream est actif**
   ```bash
   # Vérifier les streams actifs
   curl http://localhost:8080/stat
   ```

2. **Utiliser la bonne URL**
   - Format correct: `rtmp://localhost/live/NOM_DU_STREAM`
   - Le nom doit correspondre à la clé dans OBS

3. **Augmenter le cache réseau dans VLC**
   - Outils → Préférences → Entrée/Codecs
   - Mise en cache réseau: 1000-3000ms

4. **Tester avec ffplay**
   ```bash
   ffplay rtmp://localhost/live/NOM_DU_STREAM
   ```

### Latence très élevée (>10 secondes)

**Solutions:**

1. **Réduire le buffer dans OBS**
   - Paramètres → Avancé → Réseau
   - Activer "Réduire la latence réseau au minimum"

2. **Utiliser le mode zerolatency**
   - Paramètres → Sortie → Streaming
   - x264: Accordage → zerolatency

3. **Réduire le keyframe interval**
   - Paramètres → Sortie → Streaming
   - Intervalle d'image clé: 1 seconde

4. **Utiliser SRT au lieu de RTMP**
   - SRT a une latence < 1 seconde
   - Voir `docs/STREAMING_LOCAL.md`

## Problèmes de qualité

### Image pixelisée/floue

**Solutions:**

1. **Augmenter le bitrate**
   - 720p 30fps: 2500-4000 Kbps
   - 1080p 30fps: 4000-6000 Kbps
   - 1080p 60fps: 6000-8000 Kbps

2. **Changer le preset d'encodage**
   - x264: medium ou slow (meilleure qualité, plus de CPU)
   - NVENC: Quality ou Max Quality

3. **Vérifier la résolution**
   - Paramètres → Vidéo
   - Résolution de sortie doit correspondre à votre objectif

4. **Changer le profile x264**
   - Paramètres → Sortie
   - Profile: high (meilleure qualité)

### Frames perdues (dropped frames)

**Symptômes:**
- Statistiques OBS montrent beaucoup de frames perdues
- Stream saccadé côté viewer

**Solutions:**

1. **Vérifier la charge réseau**
   ```bash
   # Tester la bande passante réseau
   iperf3 -s  # Sur le serveur
   iperf3 -c IP_SERVEUR  # Sur le client
   ```

2. **Réduire le bitrate**
   - Commencer à 2500 Kbps et augmenter progressivement

3. **Activer le CBR (Constant Bitrate)**
   - Paramètres → Sortie
   - Contrôle du débit: CBR

4. **Vérifier les autres processus réseau**
   - Fermer les téléchargements
   - Désactiver les mises à jour automatiques

### Couleurs incorrectes

**Solutions:**

1. **Vérifier l'espace colorimétrique**
   - Paramètres → Vidéo → Avancé
   - Espace: 709 (HD) ou 601 (SD)
   - Gamme: Limited/Partial

2. **Vérifier le format pixel**
   - Paramètres → Sortie → Streaming
   - Format pixel: yuv420p

## Problèmes audio

### Pas de son dans le stream

**Solutions:**

1. **Vérifier le mixeur audio dans OBS**
   - Assurez-vous que les sources audio ne sont pas coupées (icône speaker)
   - Vérifier les niveaux (barres vertes/jaunes)

2. **Vérifier les paramètres audio**
   - Paramètres → Audio
   - Audio du bureau: Sélectionner le bon périphérique
   - Micro: Sélectionner le bon périphérique

3. **Tester avec ffprobe**
   ```bash
   ffprobe rtmp://localhost/live/STREAM
   # Doit afficher "Stream #0:1: Audio"
   ```

4. **Redémarrer les sources audio**
   - Clic droit sur la source audio → Redémarrer

### Audio désynchronisé (décalage audio/vidéo)

**Solutions:**

1. **Ajouter un décalage manuel**
   - Paramètres → Audio → Périphériques
   - Clic sur ⚙️ → Décalage de synchronisation
   - Ajouter +/- millisecondes selon besoin

2. **Utiliser l'horodatage système**
   - Paramètres → Avancé
   - Activer "Horodatage basé sur le temps du système"

3. **Vérifier le taux d'échantillonnage**
   - Tous les périphériques doivent être à 48 kHz
   - Paramètres → Audio → Taux d'échantillonnage: 48 kHz

### Crackling/Popping audio

**Solutions:**

1. **Augmenter le buffer audio**
   - Windows: Panneau de configuration du son
   - Propriétés du périphérique → Avancé
   - Augmenter la taille du buffer

2. **Réduire la charge CPU**
   - Fermer applications inutiles
   - Réduire preset d'encodage

3. **Vérifier les pilotes audio**
   - Mettre à jour les drivers audio
   - Utiliser les drivers du fabricant, pas génériques Windows

### Volume trop faible/élevé

**Solutions:**

1. **Ajuster dans le mixeur OBS**
   - Utiliser le slider de volume pour chaque source
   - Viser les niveaux jaunes, éviter le rouge

2. **Ajouter des filtres**
   - Clic droit sur la source audio → Filtres
   - Ajouter: Compresseur (égaliser les volumes)
   - Ajouter: Gain (augmenter le volume)

3. **Normaliser l'audio**
   - Filtre → Normaliseur

## Problèmes de performance

### Encodage surchargé (Encoding overloaded)

**Symptômes:**
- Carré rouge dans OBS avec "Encodage surchargé"
- FPS réduit
- Stream saccadé

**Solutions:**

1. **Réduire preset x264**
   ```
   ultrafast > superfast > veryfast > faster > fast > medium
   Plus rapide = moins de charge CPU
   ```

2. **Utiliser encodeur hardware**
   - NVENC (Nvidia GPU)
   - QuickSync (Intel CPU avec GPU intégré)
   - AMF (AMD GPU)

3. **Réduire résolution/FPS**
   - Passer de 1080p à 720p
   - Passer de 60 FPS à 30 FPS

4. **Limiter les sources actives**
   - Désactiver les sources inutilisées
   - Réduire les sources navigateur
   - Limiter les filtres et effets

5. **Mode de performance Windows**
   ```
   Paramètres → Système → Alimentation
   Mode de performance: Performances optimales
   ```

6. **Priorité du processus**
   - Windows: Gestionnaire des tâches
   - Clic droit OBS → Priorité → Haute

### OBS lag/ralentit

**Solutions:**

1. **Désactiver l'aperçu**
   - Clic droit sur l'aperçu → Désactiver l'aperçu

2. **Réduire la charge GPU**
   - Paramètres → Avancé
   - Rendu: DirectX 11 (Windows) ou OpenGL (Linux)

3. **Fermer applications gourmandes**
   - Chrome avec beaucoup d'onglets
   - Discord avec overlay
   - Autres streams/vidéos

4. **Vérifier température CPU/GPU**
   ```bash
   # Linux
   sensors

   # Windows: Utiliser HWMonitor ou MSI Afterburner
   ```

### Jeu lag quand OBS stream

**Solutions:**

1. **Utiliser encodeur GPU**
   - Libère le CPU pour le jeu
   - NVENC, QuickSync, ou AMF

2. **Limiter FPS du jeu**
   - Laisser de la marge CPU pour OBS
   - 144 FPS → 120 FPS par exemple

3. **Capture de jeu au lieu de capture d'écran**
   - Plus performant
   - Source → Capture de jeu

4. **Mode multi-processus GPU (Nvidia)**
   - Paramètres → Avancé
   - Cocher "Mode multi-adaptateur"

## Problèmes OBS

### OBS crash au démarrage

**Solutions:**

1. **Mettre à jour les drivers graphiques**
   - Nvidia: GeForce Experience
   - AMD: AMD Software
   - Intel: Intel Driver & Support Assistant

2. **Exécuter en administrateur**
   - Clic droit OBS → Exécuter en tant qu'administrateur

3. **Supprimer le cache**
   ```bash
   # Windows
   %appdata%\obs-studio\plugin_config\

   # Linux
   ~/.config/obs-studio/plugin_config/

   # Supprimer le dossier et relancer
   ```

4. **Vérifier les logs**
   - OBS → Aide → Fichiers de log
   - Chercher "error" ou "crash"

### Sources ne s'affichent pas

**Solutions:**

1. **Vérifier visibilité**
   - Icône œil à côté de la source doit être ouvert

2. **Vérifier ordre des sources**
   - Glisser-déposer pour réorganiser
   - Sources en haut sont devant

3. **Actualiser la source**
   - Clic droit → Actualiser

4. **Recréer la source**
   - Supprimer et recréer

### Capture de jeu ne fonctionne pas

**Solutions:**

1. **Vérifier mode de capture**
   - Mode: "Capturer n'importe quelle fenêtre en plein écran"
   - ou sélectionner le jeu spécifique

2. **Exécuter jeu et OBS en admin**
   - Tous les deux doivent avoir même niveau de privilèges

3. **Désactiver overlay anticheat**
   - Certains anticheats bloquent OBS

4. **Utiliser capture d'écran en dernier recours**
   - Moins performant mais fonctionne toujours

## Problèmes serveur RTMP

### Nginx ne démarre pas

**Solutions:**

1. **Vérifier syntaxe configuration**
   ```bash
   sudo nginx -t
   ```

2. **Vérifier que le port 1935 est libre**
   ```bash
   sudo netstat -tuln | grep 1935
   # Si occupé:
   sudo lsof -i :1935
   sudo kill PID
   ```

3. **Vérifier les permissions**
   ```bash
   sudo chown -R www-data:www-data /var/www/recordings
   sudo chmod 755 /var/www/recordings
   ```

4. **Vérifier les logs**
   ```bash
   sudo tail -50 /var/log/nginx/error.log
   ```

### Module RTMP non trouvé

**Solutions:**

1. **Installer le module RTMP**
   ```bash
   # Ubuntu/Debian
   sudo apt install libnginx-mod-rtmp

   # Vérifier
   nginx -V 2>&1 | grep rtmp
   ```

2. **Recompiler Nginx avec RTMP**
   ```bash
   # Si le module n'est pas disponible dans les repos
   # Voir: https://github.com/arut/nginx-rtmp-module
   ```

### Enregistrements ne sont pas sauvegardés

**Solutions:**

1. **Vérifier permissions dossier**
   ```bash
   ls -la /var/www/recordings
   sudo chmod 777 /var/www/recordings  # Temporairement pour tester
   ```

2. **Vérifier espace disque**
   ```bash
   df -h
   ```

3. **Vérifier configuration Nginx**
   ```nginx
   application recorded {
       live on;
       record all;
       record_path /var/www/recordings;
       record_unique on;
   }
   ```

## Commandes de diagnostic

### Informations système
```bash
# Version OBS
obs --version

# Processeur
lscpu  # Linux
wmic cpu get name  # Windows

# Carte graphique
lspci | grep VGA  # Linux
wmic path win32_VideoController get name  # Windows

# RAM
free -h  # Linux
wmic ComputerSystem get TotalPhysicalMemory  # Windows
```

### Test réseau
```bash
# Latence
ping localhost

# Bande passante
iperf3 -s  # Serveur
iperf3 -c IP  # Client

# Ports ouverts
netstat -tuln
```

### Logs OBS
```bash
# Emplacement logs
# Windows: %appdata%\obs-studio\logs
# Linux: ~/.config/obs-studio/logs
# Mac: ~/Library/Application Support/obs-studio/logs

# Voir dernier log
tail -100 ~/.config/obs-studio/logs/[dernier_fichier].txt
```

### Stats streaming
```bash
# Stats RTMP
curl http://localhost:8080/stat

# Analyser stream
ffprobe -v error -show_format -show_streams rtmp://localhost/live/stream

# Tester débit
ffmpeg -i rtmp://localhost/live/stream -f null - 2>&1 | grep bitrate
```

## Ressources supplémentaires

- [OBS Forum](https://obsproject.com/forum/)
- [OBS Discord](https://discord.gg/obsproject)
- [r/obs Reddit](https://reddit.com/r/obs)
- [Log Analyzer](https://obsproject.com/tools/analyzer)

## Obtenir de l'aide

Lors d'une demande d'aide, fournir:

1. **Version OBS** (`obs --version`)
2. **Système d'exploitation** (Windows 10/11, Ubuntu 22.04, etc.)
3. **Matériel** (CPU, GPU, RAM)
4. **Fichier log OBS** (dernier log)
5. **Description du problème**
6. **Ce qui a déjà été essayé**

Format exemple:
```
OBS: 30.0.0
OS: Ubuntu 22.04
CPU: AMD Ryzen 5 5600X
GPU: Nvidia RTX 3060
RAM: 16 GB

Problème: Stream pixelisé même avec bitrate élevé
Essayé: Changé preset, augmenté bitrate à 6000
Log: [lien vers pastebin avec le log]
```
