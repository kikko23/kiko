#!/bin/bash

# Script pour visualiser un stream RTMP
# Usage: ./view_stream.sh [stream_name] [player]

STREAM_NAME=${1:-}
PLAYER=${2:-auto}

echo "======================================"
echo "  Visualiseur de Stream RTMP"
echo "======================================"
echo ""

# Si aucun nom de stream fourni, demander
if [ -z "$STREAM_NAME" ]; then
    read -p "Nom du stream: " STREAM_NAME
fi

RTMP_URL="rtmp://localhost/live/$STREAM_NAME"

echo "Stream: $STREAM_NAME"
echo "URL: $RTMP_URL"
echo ""

# Déterminer le player à utiliser
if [ "$PLAYER" = "auto" ]; then
    if command -v vlc &> /dev/null; then
        PLAYER="vlc"
    elif command -v ffplay &> /dev/null; then
        PLAYER="ffplay"
    elif command -v mpv &> /dev/null; then
        PLAYER="mpv"
    else
        echo "❌ Aucun player trouvé"
        echo ""
        echo "Installez un des players suivants:"
        echo "  VLC: sudo apt install vlc"
        echo "  FFplay: sudo apt install ffmpeg"
        echo "  MPV: sudo apt install mpv"
        exit 1
    fi
fi

echo "Player: $PLAYER"
echo ""

# Vérifier que le serveur RTMP est actif
if ! netstat -tuln 2>/dev/null | grep -q ':1935' && ! ss -tuln 2>/dev/null | grep -q ':1935'; then
    echo "⚠️  Serveur RTMP non détecté sur le port 1935"
    echo "Le serveur est-il démarré?"
    echo ""
    read -p "Continuer quand même? (y/n): " continue
    if [ "$continue" != "y" ]; then
        exit 1
    fi
fi

# Lancer le player
echo "🎬 Lancement du player..."
echo "Appuyez sur Ctrl+C pour quitter"
echo ""

case $PLAYER in
    vlc)
        vlc --network-caching=300 "$RTMP_URL"
        ;;

    ffplay)
        ffplay -fflags nobuffer -flags low_delay -framedrop \
            -strict experimental "$RTMP_URL"
        ;;

    mpv)
        mpv --no-cache --untimed --profile=low-latency "$RTMP_URL"
        ;;

    *)
        echo "❌ Player inconnu: $PLAYER"
        echo "Players supportés: vlc, ffplay, mpv"
        exit 1
        ;;
esac
