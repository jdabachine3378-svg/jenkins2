#!/bin/bash
# Script pour pré-télécharger les images Docker nécessaires avec retries

set -e

MAX_RETRIES=3
RETRY_DELAY=5

echo "========================================"
echo "Pré-téléchargement des images Docker"
echo "========================================"

# Fonction pour télécharger une image avec retries
download_image() {
    local image=$1
    local retry_count=0
    
    # Vérifier si l'image existe déjà localement
    if docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "^${image}$"; then
        echo "ℹ Image $image déjà présente localement, skip..."
        return 0
    fi
    
    while [ $retry_count -lt $MAX_RETRIES ]; do
        retry_count=$((retry_count + 1))
        echo ""
        echo "[$retry_count/$MAX_RETRIES] Téléchargement de $image..."
        
        if docker pull "$image"; then
            echo "✓ Image $image téléchargée avec succès"
            return 0
        else
            if [ $retry_count -lt $MAX_RETRIES ]; then
                echo "✗ Échec du téléchargement, nouvelle tentative dans $RETRY_DELAY secondes..."
                sleep $RETRY_DELAY
            else
                echo "✗✗✗ Échec après $MAX_RETRIES tentatives pour $image"
                echo "⚠ Tentative de continuer avec les images disponibles..."
                return 0
            fi
        fi
    done
}

# Images de base pour les builds
echo ""
echo "=== Images de build ==="
download_image "maven:3.8.4-openjdk-17"

# Images de runtime
echo ""
echo "=== Images de runtime ==="
download_image "eclipse-temurin:17-jdk-alpine"

# Images pour les services
echo ""
echo "=== Images des services ==="
download_image "mysql:latest"
download_image "consul:1.15.4"
download_image "phpmyadmin/phpmyadmin:latest"

echo ""
echo "========================================"
echo "✓ Pré-téléchargement terminé"
echo "========================================"

