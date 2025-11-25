#!/bin/bash

# Script de monitoring du stream RTMP
# Usage: ./monitor_stream.sh

set -e

STATS_URL="http://localhost:8080/stat"
REFRESH_INTERVAL=2

echo "======================================"
echo "  Monitoring du Stream RTMP"
echo "======================================"
echo ""
echo "Appuyez sur Ctrl+C pour quitter"
echo ""

# Fonction pour formater les octets
format_bytes() {
    local bytes=$1
    if [ $bytes -lt 1024 ]; then
        echo "${bytes} B/s"
    elif [ $bytes -lt 1048576 ]; then
        echo "$(($bytes / 1024)) KB/s"
    else
        echo "$(($bytes / 1048576)) MB/s"
    fi
}

# Vérifier si le serveur RTMP est actif
if ! netstat -tuln 2>/dev/null | grep -q ':1935' && ! ss -tuln 2>/dev/null | grep -q ':1935'; then
    echo "❌ Serveur RTMP non actif sur le port 1935"
    echo "Démarrez-le avec: ./start_rtmp_server.sh"
    exit 1
fi

# Vérifier si curl est installé
if ! command -v curl &> /dev/null; then
    echo "❌ curl n'est pas installé"
    echo "Installation: sudo apt install curl"
    exit 1
fi

# Loop de monitoring
while true; do
    clear
    echo "======================================"
    echo "  Monitoring du Stream RTMP"
    echo "======================================"
    echo ""
    echo "Heure: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""

    # Récupérer les stats
    if curl -s "$STATS_URL" > /dev/null 2>&1; then
        STATS=$(curl -s "$STATS_URL")

        # Extraire les informations
        ACTIVE_STREAMS=$(echo "$STATS" | grep -o "<name>[^<]*</name>" | sed 's/<[^>]*>//g' | wc -l)

        echo "📊 Statistiques serveur"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Streams actifs: $ACTIVE_STREAMS"

        # Afficher les streams actifs
        if [ $ACTIVE_STREAMS -gt 0 ]; then
            echo ""
            echo "📺 Streams en cours:"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

            # Parser le XML pour obtenir les infos des streams
            echo "$STATS" | grep -A 20 "<stream>" | while IFS= read -r line; do
                if echo "$line" | grep -q "<name>"; then
                    NAME=$(echo "$line" | sed 's/<[^>]*>//g' | xargs)
                    echo ""
                    echo "Stream: $NAME"
                fi
                if echo "$line" | grep -q "<bw_in>"; then
                    BW=$(echo "$line" | sed 's/<[^>]*>//g' | xargs)
                    echo "  Bande passante entrante: $(format_bytes $BW)"
                fi
                if echo "$line" | grep -q "<bw_out>"; then
                    BW=$(echo "$line" | sed 's/<[^>]*>//g' | xargs)
                    echo "  Bande passante sortante: $(format_bytes $BW)"
                fi
                if echo "$line" | grep -q "<bw_video>"; then
                    BW=$(echo "$line" | sed 's/<[^>]*>//g' | xargs)
                    echo "  Vidéo: $(format_bytes $BW)"
                fi
                if echo "$line" | grep -q "<bw_audio>"; then
                    BW=$(echo "$line" | sed 's/<[^>]*>//g' | xargs)
                    echo "  Audio: $(format_bytes $BW)"
                fi
            done
        else
            echo ""
            echo "Aucun stream actif"
            echo ""
            echo "Pour streamer:"
            echo "  OBS → rtmp://localhost/live/nom_stream"
            echo ""
            echo "Pour voir:"
            echo "  vlc rtmp://localhost/live/nom_stream"
        fi

        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Stats détaillées: $STATS_URL"
    else
        echo "❌ Impossible de récupérer les statistiques"
        echo "Vérifiez que Nginx est configuré avec rtmp_stat"
    fi

    echo ""
    echo "Actualisation dans ${REFRESH_INTERVAL}s..."
    sleep $REFRESH_INTERVAL
done
