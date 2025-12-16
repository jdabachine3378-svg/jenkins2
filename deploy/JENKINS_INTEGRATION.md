# Intégration dans Jenkins Pipeline

## Modification du pipeline Jenkins

Dans votre pipeline Jenkins, modifiez l'étape "Docker Compose Deployment" pour utiliser le script de pré-téléchargement :

### Avant (problématique)
```groovy
stage('Docker Compose Deployment') {
    steps {
        dir('deploy') {
            bat 'docker compose up -d --build'
        }
    }
}
```

### Après (solution)
```groovy
stage('Docker Compose Deployment') {
    steps {
        dir('deploy') {
            // Option 1 : Pré-télécharger puis déployer
            bat 'call pull-images.bat'
            bat 'docker compose up -d --build'
            
            // OU Option 2 : Utiliser le script complet
            // bat 'deploy.bat'
        }
    }
}
```

## Pipeline complet recommandé

```groovy
stage('Docker Compose Deployment') {
    steps {
        dir('deploy') {
            script {
                // Pré-télécharger les images avec retries
                echo '📥 Pré-téléchargement des images Docker...'
                def pullResult = bat(
                    script: 'call pull-images.bat',
                    returnStatus: true
                )
                
                if (pullResult != 0) {
                    echo '⚠ Certaines images n\'ont pas pu être pré-téléchargées, mais on continue...'
                }
                
                // Arrêter les conteneurs existants
                echo '🛑 Arrêt des conteneurs existants...'
                bat 'docker compose down', returnStatus: true
                
                // Construire et démarrer
                echo '🚀 Construction et démarrage des services...'
                bat 'docker compose up -d --build'
            }
        }
    }
    post {
        success {
            echo '✅ Déploiement réussi'
            dir('deploy') {
                bat 'docker compose ps'
            }
        }
        failure {
            echo '❌ Échec du déploiement'
            dir('deploy') {
                bat 'docker compose logs --tail=100'
            }
        }
    }
}
```

## Configuration Docker dans Jenkins

Si le problème persiste, configurez Docker dans Jenkins :

1. **Aller dans** : Jenkins → Manage Jenkins → Configure System
2. **Rechercher** : Docker ou ajouter des variables d'environnement globales
3. **Ajouter** :
   - `DOCKER_BUILDKIT=1`
   - `COMPOSE_DOCKER_CLI_BUILD=1`

Ou dans le pipeline :
```groovy
environment {
    DOCKER_BUILDKIT = '1'
    COMPOSE_DOCKER_CLI_BUILD = '1'
}
```

## Alternative : Utiliser un registry mirror

Si Docker Hub est bloqué, configurez un mirror dans le pipeline :

```groovy
stage('Configure Docker') {
    steps {
        script {
            // Configurer Docker daemon avec un mirror (nécessite accès admin)
            // Ou utiliser des variables d'environnement
            sh '''
                mkdir -p ~/.docker
                echo '{"registry-mirrors": ["https://mirror.gcr.io"]}' > ~/.docker/daemon.json
            '''
        }
    }
}
```

## Dépannage

Si les erreurs persistent :

1. **Vérifier la connexion réseau** :
   ```groovy
   bat 'docker pull hello-world'
   ```

2. **Vérifier les images en cache** :
   ```groovy
   bat 'docker images'
   ```

3. **Nettoyer et réessayer** :
   ```groovy
   bat 'docker system prune -f'
   bat 'call pull-images.bat'
   ```

