# Guide de déploiement Docker Compose

## Problème de timeout TLS

Si vous rencontrez des erreurs de timeout TLS lors du téléchargement des images Docker depuis Docker Hub, utilisez les scripts fournis.

## Solutions

### Solution 1 : Pré-téléchargement des images (Recommandé)

Avant d'exécuter `docker compose up`, pré-téléchargez les images :

**Sur Windows (Jenkins) :**
```batch
cd deploy
call pull-images.bat
docker compose up -d --build
```

**Sur Linux/Mac :**
```bash
cd deploy
chmod +x pull-images.sh
./pull-images.sh
docker compose up -d --build
```

### Solution 2 : Utiliser le script de déploiement complet

Le script `deploy.bat` (Windows) ou `deploy.sh` (Linux) fait tout automatiquement :

**Windows :**
```batch
cd deploy
deploy.bat
```

**Linux/Mac :**
```bash
cd deploy
chmod +x deploy.sh
./deploy.sh
```

### Solution 3 : Configuration Docker daemon (Alternative)

Si le problème persiste, configurez Docker pour augmenter les timeouts :

1. Créez/modifiez `C:\ProgramData\docker\config\daemon.json` (Windows) ou `/etc/docker/daemon.json` (Linux)
2. Ajoutez :
```json
{
  "max-concurrent-downloads": 3,
  "max-concurrent-uploads": 5
}
```

### Solution 4 : Utiliser un registry mirror

Si Docker Hub est bloqué ou lent, configurez un mirror dans `daemon.json` :
```json
{
  "registry-mirrors": ["https://mirror.gcr.io"]
}
```

## Intégration dans Jenkins

Dans votre pipeline Jenkins, ajoutez une étape avant `docker compose up` :

```groovy
stage('Docker Compose Deployment') {
    steps {
        dir('deploy') {
            // Pré-télécharger les images
            bat 'call pull-images.bat'
            
            // Ou utiliser le script complet
            bat 'deploy.bat'
        }
    }
}
```

## Images utilisées

- **Build** : `maven:3.8.4-openjdk-17`
- **Runtime** : `eclipse-temurin:17-jdk-alpine`
- **Services** : `mysql:latest`, `consul:1.15.4`, `phpmyadmin/phpmyadmin:latest`

## Dépannage

1. **Vérifier la connexion réseau** : `docker pull hello-world`
2. **Vérifier les images en cache** : `docker images`
3. **Nettoyer le cache** : `docker system prune -a`
4. **Vérifier les logs** : `docker compose logs`

