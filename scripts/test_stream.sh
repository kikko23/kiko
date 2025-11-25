#!/bin/bash

# Script de test du stream RTMP
# Usage: ./test_stream.sh [stream_name]

STREAM_NAME=${1:-test}
RTMP_URL="rtmp://localhost/live/$STREAM_NAME"

echo "======================================"
echo "  Test du Stream RTMP"
echo "======================================"
echo ""
echo "Stream: $STREAM_NAME"
echo "URL: $RTMP_URL"
echo ""

# Vérifier ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo "❌ ffmpeg n'est pas installé"
    echo "Installation: sudo apt install ffmpeg"
    exit 1
fi

# Vérifier que le serveur RTMP est actif
if ! netstat -tuln 2>/dev/null | grep -q ':1935' && ! ss -tuln 2>/dev/null | grep -q ':1935'; then
    echo "❌ Serveur RTMP non actif"
    echo "Démarrez-le avec: ./start_rtmp_server.sh"
    exit 1
fi

# Menu de choix
echo "Choisissez un test:"
echo ""
echo "1) Tester la connexion (probe)"
echo "2) Envoyer un stream de test (barre de couleur + son)"
echo "3) Envoyer un fichier vidéo"
echo "4) Analyser un stream existant"
echo "5) Test de latence"
echo ""
read -p "Votre choix [1-5]: " choice

case $choice in
    1)
        echo ""
        echo "🔍 Test de connexion..."
        if timeout 5 ffmpeg -f lavfi -i testsrc=duration=1:size=1280x720:rate=30 \
            -f flv "$RTMP_URL" -y 2>&1 | grep -q "Stream #"; then
            echo "✅ Connexion réussie!"
        else
            echo "❌ Échec de connexion"
        fi
        ;;

    2)
        echo ""
        echo "📺 Envoi d'un stream de test..."
        echo "Appuyez sur Ctrl+C pour arrêter"
        echo ""
        ffmpeg -re -f lavfi -i testsrc=size=1280x720:rate=30 \
            -f lavfi -i sine=frequency=1000:sample_rate=48000 \
            -c:v libx264 -preset veryfast -b:v 2500k -maxrate 2500k -bufsize 5000k \
            -pix_fmt yuv420p -g 60 \
            -c:a aac -b:a 128k -ar 48000 \
            -f flv "$RTMP_URL"
        ;;

    3)
        echo ""
        read -p "Chemin du fichier vidéo: " VIDEO_FILE
        if [ ! -f "$VIDEO_FILE" ]; then
            echo "❌ Fichier non trouvé"
            exit 1
        fi

        echo ""
        echo "📹 Envoi du fichier: $VIDEO_FILE"
        echo "Appuyez sur Ctrl+C pour arrêter"
        echo ""
        ffmpeg -re -i "$VIDEO_FILE" \
            -c:v libx264 -preset veryfast -b:v 3000k -maxrate 3000k -bufsize 6000k \
            -c:a aac -b:a 160k -ar 48000 \
            -f flv "$RTMP_URL"
        ;;

    4)
        echo ""
        echo "🔍 Analyse du stream..."
        echo ""
        ffprobe -v error -show_format -show_streams "$RTMP_URL" 2>&1 | grep -E "(codec|bitrate|width|height|fps)"
        ;;

    5)
        echo ""
        echo "⏱️  Test de latence"
        echo ""
        echo "Instructions:"
        echo "1. Démarrez votre stream dans OBS"
        echo "2. Ajoutez une source de texte avec l'heure actuelle"
        echo "3. Ce script va lire le stream et calculer la latence"
        echo ""
        read -p "Stream démarré? (y/n): " ready

        if [ "$ready" != "y" ]; then
            exit 0
        fi

        echo ""
        echo "Démarrage du player..."
        START=$(date +%s%N)

        # Lancer ffplay en arrière-plan
        timeout 10 ffplay -loglevel quiet -autoexit "$RTMP_URL" &
        PLAYER_PID=$!

        # Attendre que le premier frame soit affiché
        sleep 3

        END=$(date +%s%N)
        LATENCY=$(( ($END - $START) / 1000000 ))

        echo "Latence de démarrage: ${LATENCY}ms"
        echo ""
        echo "Note: La latence réelle du stream est généralement"
        echo "de 2-5 secondes avec RTMP (bufferisation)"
        ;;

    *)
        echo "❌ Choix invalide"
        exit 1
        ;;
esac

echo ""
echo "Test terminé"
