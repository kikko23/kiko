#!/bin/bash

# Script de démarrage du serveur RTMP
# Usage: ./start_rtmp_server.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "======================================"
echo "  Démarrage du serveur RTMP"
echo "======================================"
echo ""

# Vérifier si Nginx est installé
if ! command -v nginx &> /dev/null; then
    echo "❌ Nginx n'est pas installé!"
    echo ""
    echo "Installation:"
    echo "  Ubuntu/Debian: sudo apt install nginx libnginx-mod-rtmp"
    echo "  macOS: brew install nginx-full --with-rtmp-module"
    exit 1
fi

# Vérifier si le module RTMP est chargé
if ! nginx -V 2>&1 | grep -q "rtmp"; then
    echo "⚠️  Module RTMP non détecté dans Nginx"
    echo "Assurez-vous d'avoir installé libnginx-mod-rtmp"
fi

# Créer les dossiers nécessaires
echo "📁 Création des dossiers..."
sudo mkdir -p /var/www/recordings
sudo mkdir -p /tmp/hls
sudo chown -R www-data:www-data /var/www/recordings 2>/dev/null || sudo chown -R $(whoami) /var/www/recordings

# Copier la configuration si nécessaire
if [ -f "$PROJECT_DIR/configs/nginx-rtmp.conf" ]; then
    echo "📝 Configuration RTMP trouvée"
    echo "Pour l'utiliser, ajoutez ce contenu à /etc/nginx/nginx.conf"
    echo "Ou incluez-le avec: include $PROJECT_DIR/configs/nginx-rtmp.conf;"
fi

# Démarrer Nginx
echo ""
echo "🚀 Démarrage de Nginx..."
sudo systemctl start nginx

# Vérifier que Nginx est démarré
sleep 2
if ! sudo systemctl is-active --quiet nginx; then
    echo "❌ Échec du démarrage de Nginx"
    echo "Vérifiez les logs: sudo journalctl -u nginx -n 50"
    exit 1
fi

# Vérifier que le port RTMP écoute
if netstat -tuln 2>/dev/null | grep -q ':1935' || ss -tuln 2>/dev/null | grep -q ':1935'; then
    echo "✅ Serveur RTMP démarré avec succès!"
    echo ""
    echo "======================================"
    echo "  Configuration OBS"
    echo "======================================"
    echo ""
    echo "Service: Personnalisé"
    echo "Serveur: rtmp://localhost/live"
    echo "Clé: votre_nom_de_stream"
    echo ""
    echo "======================================"
    echo "  Lecture du stream"
    echo "======================================"
    echo ""
    echo "VLC: vlc rtmp://localhost/live/votre_nom_de_stream"
    echo "FFplay: ffplay rtmp://localhost/live/votre_nom_de_stream"
    echo ""
    echo "Stats: http://localhost:8080/stat"
    echo "HLS: http://localhost:8080/hls/votre_nom_de_stream.m3u8"
    echo ""
    echo "======================================"
else
    echo "⚠️  Le port 1935 (RTMP) n'est pas ouvert"
    echo "Vérifiez la configuration Nginx et les logs"
    echo ""
    echo "Logs: sudo tail -f /var/log/nginx/error.log"
fi

# Afficher les IPs locales
echo ""
echo "======================================"
echo "  Accès réseau local"
echo "======================================"
echo ""
echo "Vos adresses IP:"
if command -v ip &> /dev/null; then
    ip addr show | grep "inet " | grep -v "127.0.0.1" | awk '{print "  " $2}'
else
    ifconfig | grep "inet " | grep -v "127.0.0.1" | awk '{print "  " $2}'
fi
echo ""
echo "Utilisez: rtmp://[IP_CI-DESSUS]/live/votre_nom"
echo ""
