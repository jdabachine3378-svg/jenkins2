#!/bin/bash
# Script de déploiement amélioré avec gestion des erreurs et pré-téléchargement

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================"
echo "Déploiement Docker Compose"
echo "========================================"

# Vérifier que Docker est disponible
if ! command -v docker &> /dev/null; then
    echo "✗ Docker n'est pas installé ou n'est pas dans le PATH"
    exit 1
fi

# Vérifier que Docker Compose est disponible
if ! docker compose version &> /dev/null; then
    echo "✗ Docker Compose n'est pas installé ou n'est pas dans le PATH"
    exit 1
fi

# Pré-télécharger les images si le script existe
if [ -f "$SCRIPT_DIR/pull-images.sh" ]; then
    echo ""
    echo "Pré-téléchargement des images Docker..."
    bash "$SCRIPT_DIR/pull-images.sh" || echo "⚠ Certaines images n'ont pas pu être téléchargées, mais on continue..."
fi

# Arrêter les conteneurs existants
echo ""
echo "Arrêt des conteneurs existants..."
docker compose down 2>/dev/null || true

# Construire et démarrer les services
echo ""
echo "Construction et démarrage des services..."
if docker compose up -d --build; then
    echo ""
    echo "========================================"
    echo "✓ Déploiement réussi"
    echo "========================================"
    echo ""
    echo "Services démarrés:"
    docker compose ps
    exit 0
else
    echo ""
    echo "========================================"
    echo "✗ Échec du déploiement"
    echo "========================================"
    echo ""
    echo "Logs des services:"
    docker compose logs --tail=50
    exit 1
fi

