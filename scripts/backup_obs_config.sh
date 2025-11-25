#!/bin/bash

# Script de sauvegarde/restauration de configuration OBS
# Usage: ./backup_obs_config.sh [backup|restore]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$PROJECT_DIR/backups"

# Détecter l'OS et le dossier OBS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OBS_CONFIG_DIR="$HOME/.config/obs-studio"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OBS_CONFIG_DIR="$HOME/Library/Application Support/obs-studio"
else
    OBS_CONFIG_DIR="$APPDATA/obs-studio"
fi

ACTION=${1:-menu}

# Fonction de sauvegarde
backup_config() {
    echo "======================================"
    echo "  Sauvegarde configuration OBS"
    echo "======================================"
    echo ""

    if [ ! -d "$OBS_CONFIG_DIR" ]; then
        echo "❌ Configuration OBS non trouvée"
        echo "Chemin: $OBS_CONFIG_DIR"
        exit 1
    fi

    # Créer le dossier de backup
    mkdir -p "$BACKUP_DIR"

    # Nom du backup avec timestamp
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_FILE="$BACKUP_DIR/obs_config_$TIMESTAMP.tar.gz"

    echo "📁 Source: $OBS_CONFIG_DIR"
    echo "💾 Destination: $BACKUP_FILE"
    echo ""

    # Créer l'archive
    echo "📦 Création de l'archive..."
    tar -czf "$BACKUP_FILE" -C "$(dirname "$OBS_CONFIG_DIR")" "$(basename "$OBS_CONFIG_DIR")"

    if [ $? -eq 0 ]; then
        SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
        echo "✅ Sauvegarde créée avec succès!"
        echo "   Taille: $SIZE"
        echo "   Fichier: $BACKUP_FILE"
    else
        echo "❌ Erreur lors de la sauvegarde"
        exit 1
    fi

    # Lister les éléments sauvegardés
    echo ""
    echo "📋 Contenu de la sauvegarde:"
    tar -tzf "$BACKUP_FILE" | head -20
    echo "..."

    echo ""
    echo "✨ Sauvegarde terminée!"
}

# Fonction de restauration
restore_config() {
    echo "======================================"
    echo "  Restauration configuration OBS"
    echo "======================================"
    echo ""

    # Lister les backups disponibles
    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
        echo "❌ Aucune sauvegarde trouvée dans $BACKUP_DIR"
        exit 1
    fi

    echo "Sauvegardes disponibles:"
    echo ""
    select BACKUP_FILE in "$BACKUP_DIR"/*.tar.gz "Annuler"; do
        case $BACKUP_FILE in
            "Annuler")
                echo "Annulé"
                exit 0
                ;;
            *.tar.gz)
                break
                ;;
            *)
                echo "❌ Sélection invalide"
                exit 1
                ;;
        esac
    done

    echo ""
    echo "📁 Sauvegarde sélectionnée: $BACKUP_FILE"
    echo "📂 Destination: $OBS_CONFIG_DIR"
    echo ""

    # Avertissement
    echo "⚠️  ATTENTION:"
    echo "Cette opération va remplacer votre configuration OBS actuelle!"
    echo ""
    read -p "Continuer? (tapez 'yes' pour confirmer): " confirm

    if [ "$confirm" != "yes" ]; then
        echo "Annulé"
        exit 0
    fi

    # Sauvegarder la config actuelle avant de restaurer
    if [ -d "$OBS_CONFIG_DIR" ]; then
        echo ""
        echo "💾 Sauvegarde de sécurité de la config actuelle..."
        SAFETY_BACKUP="$BACKUP_DIR/obs_config_before_restore_$(date +%Y%m%d_%H%M%S).tar.gz"
        tar -czf "$SAFETY_BACKUP" -C "$(dirname "$OBS_CONFIG_DIR")" "$(basename "$OBS_CONFIG_DIR")"
        echo "✅ Sauvegarde de sécurité: $SAFETY_BACKUP"
    fi

    # Restaurer
    echo ""
    echo "📦 Restauration en cours..."

    # Supprimer la config existante
    if [ -d "$OBS_CONFIG_DIR" ]; then
        rm -rf "$OBS_CONFIG_DIR"
    fi

    # Extraire le backup
    tar -xzf "$BACKUP_FILE" -C "$(dirname "$OBS_CONFIG_DIR")"

    if [ $? -eq 0 ]; then
        echo "✅ Restauration réussie!"
        echo ""
        echo "📝 Notes:"
        echo "  - Redémarrez OBS pour appliquer les changements"
        echo "  - Vérifiez vos paramètres audio/vidéo"
        echo "  - Vérifiez vos chemins de fichiers"
    else
        echo "❌ Erreur lors de la restauration"

        # Restaurer le backup de sécurité
        if [ -f "$SAFETY_BACKUP" ]; then
            echo "🔄 Restauration du backup de sécurité..."
            tar -xzf "$SAFETY_BACKUP" -C "$(dirname "$OBS_CONFIG_DIR")"
        fi
        exit 1
    fi

    echo ""
    echo "✨ Restauration terminée!"
}

# Fonction d'export des scènes
export_scenes() {
    echo "======================================"
    echo "  Export des scènes OBS"
    echo "======================================"
    echo ""

    SCENES_SOURCE="$OBS_CONFIG_DIR/basic/scenes"
    SCENES_DEST="$PROJECT_DIR/scenes/exported"

    if [ ! -d "$SCENES_SOURCE" ]; then
        echo "❌ Dossier de scènes non trouvé"
        exit 1
    fi

    mkdir -p "$SCENES_DEST"

    echo "📁 Export des scènes..."
    cp -r "$SCENES_SOURCE"/*.json "$SCENES_DEST/" 2>/dev/null

    if [ $? -eq 0 ]; then
        echo "✅ Scènes exportées vers: $SCENES_DEST"
        ls -lh "$SCENES_DEST"
    else
        echo "❌ Aucune scène à exporter"
    fi

    echo ""
}

# Menu principal
show_menu() {
    echo "======================================"
    echo "  Gestion configuration OBS"
    echo "======================================"
    echo ""
    echo "Configuration OBS: $OBS_CONFIG_DIR"
    echo ""
    echo "1) Sauvegarder la configuration"
    echo "2) Restaurer une sauvegarde"
    echo "3) Exporter les scènes"
    echo "4) Lister les sauvegardes"
    echo "5) Quitter"
    echo ""
    read -p "Votre choix [1-5]: " choice

    case $choice in
        1) backup_config ;;
        2) restore_config ;;
        3) export_scenes ;;
        4)
            echo ""
            echo "📦 Sauvegardes disponibles:"
            echo ""
            if [ -d "$BACKUP_DIR" ]; then
                ls -lh "$BACKUP_DIR"/*.tar.gz 2>/dev/null || echo "Aucune sauvegarde"
            else
                echo "Aucune sauvegarde"
            fi
            echo ""
            ;;
        5)
            echo "Au revoir!"
            exit 0
            ;;
        *)
            echo "❌ Choix invalide"
            exit 1
            ;;
    esac
}

# Point d'entrée
case $ACTION in
    backup) backup_config ;;
    restore) restore_config ;;
    export) export_scenes ;;
    menu) show_menu ;;
    *)
        echo "Usage: $0 [backup|restore|export|menu]"
        exit 1
        ;;
esac
