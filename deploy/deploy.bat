@echo off
REM Script de déploiement amélioré avec gestion des erreurs et pré-téléchargement

echo ========================================
echo Déploiement Docker Compose
echo ========================================

REM Vérifier que Docker est disponible
docker --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ✗ Docker n'est pas installé ou n'est pas dans le PATH
    exit /b 1
)

REM Vérifier que Docker Compose est disponible
docker compose version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ✗ Docker Compose n'est pas installé ou n'est pas dans le PATH
    exit /b 1
)

REM Pré-télécharger les images si le script existe
if exist "%~dp0pull-images.bat" (
    echo.
    echo Pré-téléchargement des images Docker...
    call "%~dp0pull-images.bat"
    if %ERRORLEVEL% NEQ 0 (
        echo ⚠ Certaines images n'ont pas pu être téléchargées, mais on continue...
    )
)

REM Arrêter les conteneurs existants
echo.
echo Arrêt des conteneurs existants...
docker compose down 2>nul

REM Construire et démarrer les services
echo.
echo Construction et démarrage des services...
docker compose up -d --build

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo ✓ Déploiement réussi
    echo ========================================
    echo.
    echo Services démarrés:
    docker compose ps
    exit /b 0
) else (
    echo.
    echo ========================================
    echo ✗ Échec du déploiement
    echo ========================================
    echo.
    echo Logs des services:
    docker compose logs --tail=50
    exit /b 1
)

