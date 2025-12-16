@echo off
REM Script pour pré-télécharger les images Docker nécessaires avec retries
echo ========================================
echo Pré-téléchargement des images Docker
echo ========================================

set MAX_RETRIES=3
set RETRY_DELAY=5

REM Fonction pour télécharger une image avec retries
:download_image
set IMAGE=%~1
set RETRY_COUNT=0

:retry
set /a RETRY_COUNT+=1
echo.
echo [%RETRY_COUNT%/%MAX_RETRIES%] Téléchargement de %IMAGE%...

REM Vérifier si l'image existe déjà localement
docker images --format "{{.Repository}}:{{.Tag}}" | findstr /C:"%IMAGE%" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ℹ Image %IMAGE% déjà présente localement, skip...
    goto :end_download
)

docker pull %IMAGE%

if %ERRORLEVEL% EQU 0 (
    echo ✓ Image %IMAGE% téléchargée avec succès
    goto :end_download
) else (
    if %RETRY_COUNT% LSS %MAX_RETRIES% (
        echo ✗ Échec du téléchargement, nouvelle tentative dans %RETRY_DELAY% secondes...
        timeout /t %RETRY_DELAY% /nobreak >nul
        goto :retry
    ) else (
        echo ✗✗✗ Échec après %MAX_RETRIES% tentatives pour %IMAGE%
        echo ⚠ Tentative de continuer avec les images disponibles...
        goto :end_download
    )
)

:end_download
exit /b 0

REM Images de base pour les builds
echo.
echo === Images de build ===
call :download_image maven:3.8.4-openjdk-17

REM Images de runtime
echo.
echo === Images de runtime ===
call :download_image eclipse-temurin:17-jdk-alpine

REM Images pour les services
echo.
echo === Images des services ===
call :download_image mysql:latest
call :download_image consul:1.15.4
call :download_image phpmyadmin/phpmyadmin:latest

echo.
echo ========================================
echo ✓ Pré-téléchargement terminé
echo ========================================

