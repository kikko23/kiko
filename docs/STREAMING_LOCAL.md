# Guide complet du Streaming Local avec OBS

## Introduction
Ce guide explique comment configurer un système de streaming local complet, permettant de diffuser du contenu sur votre réseau local ou de créer un serveur de streaming personnel.

## Architectures possibles

### Architecture 1: RTMP Local
```
OBS → Serveur RTMP (Nginx) → Client(s) VLC/navigateur
```

### Architecture 2: SRT
```
OBS (Caller) → Client SRT (Listener)
```

### Architecture 3: NDI
```
OBS avec NDI → Applications compatibles NDI
```

### Architecture 4: Enregistrement + Serveur Web
```
OBS → Fichier vidéo → Serveur HTTP → Navigateur
```

## Méthode 1: Serveur RTMP avec Nginx (Recommandé)

### Avantages
- Stable et éprouvé
- Multiple viewers simultanés
- Faible latence (2-5 secondes)
- Compatible avec tous les lecteurs

### Installation complète

#### Linux (Ubuntu/Debian)
```bash
# Installer Nginx avec module RTMP
sudo apt update
sudo apt install nginx libnginx-mod-rtmp

# Créer la configuration RTMP
sudo nano /etc/nginx/nginx.conf
```

Configuration Nginx complète:
```nginx
# À la fin du fichier nginx.conf
rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        # Application pour streaming en direct
        application live {
            live on;
            record off;

            # Autoriser seulement depuis localhost
            allow publish 127.0.0.1;
            deny publish all;

            # Tout le monde peut voir
            allow play all;
        }

        # Application avec enregistrement
        application recorded {
            live on;
            record all;
            record_path /var/www/recordings;
            record_unique on;

            allow publish 127.0.0.1;
            deny publish all;
        }
    }
}

# Configuration HTTP pour HLS
http {
    server {
        listen 8080;

        location /hls {
            types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
            root /tmp;
            add_header Cache-Control no-cache;
            add_header Access-Control-Allow-Origin *;
        }

        location /stat {
            rtmp_stat all;
            rtmp_stat_stylesheet stat.xsl;
        }
    }
}
```

```bash
# Créer le dossier d'enregistrements
sudo mkdir -p /var/www/recordings
sudo chown www-data:www-data /var/www/recordings

# Redémarrer Nginx
sudo systemctl restart nginx

# Vérifier le statut
sudo systemctl status nginx
```

#### Windows
```bash
# Télécharger Nginx-RTMP pour Windows
# https://github.com/illuspas/nginx-rtmp-win32

# Décompresser et éditer nginx.conf avec la même configuration
# Lancer: nginx.exe
```

#### macOS
```bash
# Installer via Homebrew
brew tap denji/nginx
brew install nginx-full --with-rtmp-module

# Configuration similaire à Linux
```

### Configuration OBS pour RTMP

1. **Paramètres → Stream**
   - Service: Personnalisé
   - Serveur: `rtmp://localhost/live` ou `rtmp://IP_LOCAL/live`
   - Clé de stream: `monstream` (peut être n'importe quoi)

2. **Paramètres → Sortie**
   - Mode: Avancé
   - Onglet Streaming
   - Encodeur vidéo: x264 ou NVENC
   - Contrôle du débit: CBR
   - Débit: 3000-6000 Kbps
   - Intervalle d'image clé: 2
   - Préréglage: veryfast (x264) ou Quality (NVENC)
   - Profile: main
   - Accordage: zerolatency

3. **Paramètres → Vidéo**
   - Résolution de base: 1920x1080
   - Résolution de sortie: 1920x1080 ou 1280x720
   - FPS: 30 ou 60

### Lecture du stream RTMP

#### VLC
```bash
# Ouvrir le stream
vlc rtmp://localhost/live/monstream

# Ou via GUI: Média → Ouvrir un flux réseau
# URL: rtmp://localhost/live/monstream
```

#### FFplay
```bash
ffplay rtmp://localhost/live/monstream
```

#### Page web HTML
```html
<!DOCTYPE html>
<html>
<head>
    <title>Mon Stream Local</title>
    <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
</head>
<body>
    <video id="video" controls width="1280" height="720"></video>

    <script>
        // Pour RTMP, utiliser un player comme Video.js avec RTMP plugin
        // Ou convertir en HLS (voir section suivante)
    </script>
</body>
</html>
```

## Méthode 2: SRT (Faible latence)

### Avantages
- Très faible latence (< 1 seconde)
- Résiste mieux aux pertes de paquets
- Pas besoin de serveur intermédiaire

### Configuration OBS

1. **Paramètres → Stream**
   - Service: Personnalisé
   - Serveur: `srt://IP_CLIENT:9998`
   - Options: `?mode=caller`

OU mode Listener:
   - Serveur: `srt://0.0.0.0:9998?mode=listener`

### Lecture SRT

#### FFplay
```bash
ffplay srt://localhost:9998?mode=caller
```

#### VLC (version 3.0+)
```bash
vlc srt://@:9998
```

## Méthode 3: NDI (Réseau local)

### Avantages
- Latence ultra-faible
- Qualité excellente
- Multi-sources faciles

### Installation

#### Plugin OBS NDI
```bash
# Télécharger depuis:
# https://github.com/obs-ndi/obs-ndi/releases

# Installer également NDI Tools:
# https://ndi.tv/tools/
```

### Configuration
1. Installer le plugin NDI dans OBS
2. Redémarrer OBS
3. Outils → NDI Output Settings
4. Activer "Main Output"

### Réception
- Utiliser NDI Studio Monitor (gratuit)
- VLC avec plugin NDI
- Autres applications compatibles NDI

## Méthode 4: WebRTC (Ultra faible latence)

### Utiliser OBS.Ninja (gratuit)

1. Aller sur https://obs.ninja
2. Créer une room
3. Ajouter comme source navigateur dans OBS
4. Partager le lien de visualisation

### Serveur WebRTC local
```bash
# Installer Janus Gateway
# https://github.com/meetecho/janus-gateway

# Configuration complexe mais latence < 500ms possible
```

## Méthode 5: RTMP → HLS (Compatible web)

### Configuration Nginx pour HLS

Ajouter à la configuration RTMP:
```nginx
application live {
    live on;
    hls on;
    hls_path /tmp/hls;
    hls_fragment 2s;
    hls_playlist_length 6s;
}
```

### Page HTML de lecture
```html
<!DOCTYPE html>
<html>
<head>
    <title>Stream HLS Local</title>
    <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
</head>
<body>
    <video id="video" controls width="1280" height="720"></video>

    <script>
        const video = document.getElementById('video');
        const videoSrc = 'http://localhost:8080/hls/monstream.m3u8';

        if (Hls.isSupported()) {
            const hls = new Hls();
            hls.loadSource(videoSrc);
            hls.attachMedia(video);
        } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
            video.src = videoSrc;
        }
    </script>
</body>
</html>
```

## Comparaison des méthodes

| Méthode | Latence | Qualité | Difficulté | Multi-viewers | Usage |
|---------|---------|---------|------------|---------------|-------|
| RTMP | 2-5s | Élevée | Moyenne | ✓ | Production |
| SRT | <1s | Élevée | Facile | ✗ | Point-à-point |
| NDI | <100ms | Maximale | Facile | ✓ | Réseau local |
| HLS | 6-30s | Élevée | Difficile | ✓ | Web |
| WebRTC | <500ms | Moyenne | Difficile | ✓ | Interactive |

## Scripts d'automatisation

### Script de démarrage Nginx RTMP
```bash
#!/bin/bash
# start_rtmp.sh

echo "Démarrage du serveur RTMP..."
sudo systemctl start nginx

# Vérifier si le port 1935 est ouvert
if netstat -tuln | grep -q ':1935'; then
    echo "✓ Serveur RTMP démarré sur port 1935"
    echo "✓ URL de streaming: rtmp://localhost/live/VOTRE_CLE"
    echo "✓ Viewer avec VLC: vlc rtmp://localhost/live/VOTRE_CLE"
else
    echo "✗ Erreur: Le serveur RTMP n'a pas démarré"
    exit 1
fi
```

### Script de monitoring
```bash
#!/bin/bash
# monitor_stream.sh

while true; do
    clear
    echo "=== Monitoring Stream RTMP ==="
    echo "$(date)"
    echo ""

    # Stats Nginx
    curl -s http://localhost:8080/stat | grep -E "bw_(in|out)|bytes_(in|out)"

    sleep 2
done
```

### Script de test de latence
```bash
#!/bin/bash
# test_latency.sh

echo "Test de latence du stream..."

# Timestamp OBS
echo "Démarrer le stream dans OBS avec un timer à l'écran"
echo "Appuyez sur Enter quand prêt..."
read

# Mesure
START=$(date +%s%N)
ffplay -loglevel quiet -autoexit rtmp://localhost/live/test &
PLAYER_PID=$!

sleep 5
kill $PLAYER_PID 2>/dev/null

END=$(date +%s%N)
LATENCY=$(( ($END - $START) / 1000000 ))

echo "Latence estimée: ${LATENCY}ms"
```

## Troubleshooting

### RTMP ne fonctionne pas
```bash
# Vérifier si Nginx écoute
sudo netstat -tuln | grep 1935

# Vérifier les logs
sudo tail -f /var/log/nginx/error.log

# Tester la connexion
ffplay rtmp://localhost/live/test
```

### Qualité médiocre
- Augmenter le débit (bitrate)
- Changer le preset encodeur
- Vérifier la charge CPU/GPU
- Augmenter la résolution

### Latence trop élevée
- Utiliser SRT ou NDI
- Réduire le buffer
- Activer zerolatency
- Réduire le keyframe interval

### Pas de son
- Vérifier les sources audio dans OBS
- Vérifier le mixeur audio
- Tester avec ffplay pour diagnostiquer

## Configuration réseau local

### Trouver votre IP locale
```bash
# Linux/Mac
ip addr show
# ou
ifconfig

# Windows
ipconfig
```

### Accès depuis autres devices
```
OBS Server: rtmp://IP_LOCAL/live
Exemple: rtmp://192.168.1.100/live/monstream

Viewer: Utiliser la même URL dans VLC
```

### Pare-feu
```bash
# Ubuntu/Debian
sudo ufw allow 1935/tcp

# Windows: Autoriser le port 1935 dans le pare-feu Windows
```

## Optimisations avancées

### Nginx tuning
```nginx
worker_processes auto;
events {
    worker_connections 1024;
}

rtmp {
    server {
        # Augmenter pour meilleure qualité
        chunk_size 8192;

        # Buffer plus petit = moins de latence
        buflen 1s;
    }
}
```

### OBS tuning pour faible latence
```
Accordage: zerolatency
Keyframe interval: 1
Buffer: Désactivé
```

## Ressources
- [Nginx RTMP Module](https://github.com/arut/nginx-rtmp-module)
- [SRT Alliance](https://www.srtalliance.org/)
- [NDI](https://ndi.tv/)
- [HLS.js](https://github.com/video-dev/hls.js/)
