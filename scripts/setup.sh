#!/bin/bash

# Script de configuration complète du projet de streaming
# Usage: ./setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "======================================"
echo "  Configuration du projet Kiko"
echo "  Streaming local avec OBS Studio"
echo "======================================"
echo ""

# Détecter l'OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    PKG_MANAGER="apt"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    PKG_MANAGER="brew"
else
    OS="windows"
    PKG_MANAGER="choco"
fi

echo "OS détecté: $OS"
echo ""

# Fonction d'installation
install_package() {
    local package=$1
    echo "📦 Installation de $package..."

    case $PKG_MANAGER in
        apt)
            sudo apt update
            sudo apt install -y $package
            ;;
        brew)
            brew install $package
            ;;
        choco)
            choco install -y $package
            ;;
    esac
}

# Vérifier et installer les dépendances
echo "🔍 Vérification des dépendances..."
echo ""

# OBS Studio
if ! command -v obs &> /dev/null; then
    echo "OBS Studio n'est pas installé"
    read -p "Installer OBS Studio? (y/n): " install_obs
    if [ "$install_obs" = "y" ]; then
        if [ "$OS" = "linux" ]; then
            sudo add-apt-repository -y ppa:obsproject/obs-studio
            install_package obs-studio
        else
            install_package obs
        fi
    fi
else
    echo "✅ OBS Studio installé"
fi

# Nginx avec RTMP
if ! command -v nginx &> /dev/null; then
    echo "Nginx n'est pas installé"
    read -p "Installer Nginx avec module RTMP? (y/n): " install_nginx
    if [ "$install_nginx" = "y" ]; then
        if [ "$OS" = "linux" ]; then
            install_package nginx
            install_package libnginx-mod-rtmp
        elif [ "$OS" = "macos" ]; then
            brew tap denji/nginx
            brew install nginx-full --with-rtmp-module
        fi
    fi
else
    echo "✅ Nginx installé"
fi

# FFmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo "FFmpeg n'est pas installé"
    read -p "Installer FFmpeg? (y/n): " install_ffmpeg
    if [ "$install_ffmpeg" = "y" ]; then
        install_package ffmpeg
    fi
else
    echo "✅ FFmpeg installé"
fi

# VLC (optionnel)
if ! command -v vlc &> /dev/null; then
    echo "VLC n'est pas installé"
    read -p "Installer VLC? (recommandé pour voir les streams) (y/n): " install_vlc
    if [ "$install_vlc" = "y" ]; then
        install_package vlc
    fi
else
    echo "✅ VLC installé"
fi

echo ""
echo "======================================"
echo "  Configuration des dossiers"
echo "======================================"
echo ""

# Créer les dossiers nécessaires
echo "📁 Création des dossiers..."
mkdir -p "$PROJECT_DIR/assets"
mkdir -p "$PROJECT_DIR/recordings"
mkdir -p "$PROJECT_DIR/configs"
mkdir -p "$PROJECT_DIR/scenes"
mkdir -p "$PROJECT_DIR/scripts"

# Rendre les scripts exécutables
echo "⚡ Configuration des permissions..."
chmod +x "$SCRIPT_DIR"/*.sh

echo "✅ Dossiers créés"

echo ""
echo "======================================"
echo "  Configuration Nginx RTMP"
echo "======================================"
echo ""

if command -v nginx &> /dev/null; then
    echo "Configuration de Nginx pour RTMP..."

    # Créer les dossiers pour Nginx
    sudo mkdir -p /var/www/recordings
    sudo mkdir -p /tmp/hls
    sudo chown -R www-data:www-data /var/www/recordings 2>/dev/null || \
        sudo chown -R $(whoami) /var/www/recordings

    echo ""
    echo "⚠️  Configuration manuelle requise:"
    echo ""
    echo "Ajoutez le contenu de configs/nginx-rtmp.conf"
    echo "à votre fichier /etc/nginx/nginx.conf"
    echo ""
    read -p "Ouvrir le fichier de configuration? (y/n): " open_config

    if [ "$open_config" = "y" ]; then
        if [ "$OS" = "linux" ]; then
            sudo ${EDITOR:-nano} /etc/nginx/nginx.conf
        elif [ "$OS" = "macos" ]; then
            ${EDITOR:-nano} /usr/local/etc/nginx/nginx.conf
        fi
    fi
else
    echo "⚠️  Nginx non installé, configuration ignorée"
fi

echo ""
echo "======================================"
echo "  Configuration OBS Studio"
echo "======================================"
echo ""

OBS_CONFIG_DIR=""
if [ "$OS" = "linux" ]; then
    OBS_CONFIG_DIR="$HOME/.config/obs-studio"
elif [ "$OS" = "macos" ]; then
    OBS_CONFIG_DIR="$HOME/Library/Application Support/obs-studio"
fi

if [ -d "$OBS_CONFIG_DIR" ]; then
    echo "✅ Configuration OBS trouvée: $OBS_CONFIG_DIR"
    echo ""
    echo "Les scènes prédéfinies sont disponibles dans:"
    echo "  $PROJECT_DIR/scenes/"
    echo ""
    echo "Pour les importer, utilisez OBS:"
    echo "  Collection de scènes → Importer"
else
    echo "⚠️  Configuration OBS non trouvée"
    echo "Lancez OBS une fois pour créer la configuration"
fi

echo ""
echo "======================================"
echo "  Création des assets par défaut"
echo "======================================"
echo ""

# Créer des fichiers de démo si FFmpeg est installé
if command -v ffmpeg &> /dev/null; then
    echo "Création d'assets de démo..."

    # Créer une image de test
    if [ ! -f "$PROJECT_DIR/assets/test-pattern.png" ]; then
        ffmpeg -f lavfi -i testsrc=size=1920x1080:rate=1 \
            -frames:v 1 "$PROJECT_DIR/assets/test-pattern.png" -y 2>/dev/null
        echo "✅ Créé: test-pattern.png"
    fi

    # Créer un son de test
    if [ ! -f "$PROJECT_DIR/assets/test-tone.mp3" ]; then
        ffmpeg -f lavfi -i sine=frequency=440:duration=5 \
            "$PROJECT_DIR/assets/test-tone.mp3" -y 2>/dev/null
        echo "✅ Créé: test-tone.mp3"
    fi
fi

echo ""
echo "======================================"
echo "  Configuration terminée!"
echo "======================================"
echo ""
echo "📚 Prochaines étapes:"
echo ""
echo "1. Lisez la documentation:"
echo "   - docs/OBS_GUIDE.md"
echo "   - docs/STREAMING_LOCAL.md"
echo ""
echo "2. Démarrez le serveur RTMP:"
echo "   cd scripts && ./start_rtmp_server.sh"
echo ""
echo "3. Configurez OBS:"
echo "   - Service: Personnalisé"
echo "   - Serveur: rtmp://localhost/live"
echo "   - Clé: votre_stream"
echo ""
echo "4. Testez le stream:"
echo "   cd scripts && ./test_stream.sh"
echo ""
echo "5. Visualisez le stream:"
echo "   cd scripts && ./view_stream.sh votre_stream"
echo ""
echo "📖 Documentation complète: $PROJECT_DIR/README.md"
echo ""
echo "✨ Bon streaming!"
echo ""
