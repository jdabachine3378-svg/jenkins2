# jenkins testing webhooks 2

## 📌 Objectif du TP
Ce TP a pour objectif de mettre en place un **pipeline CI/CD avec Jenkins** pour un projet **microservices Spring Boot**, en intégrant :
- la compilation avec **Maven**,
- l’analyse de la qualité du code avec **SonarQube**,
- la gestion sécurisée des **tokens SonarQube** via Jenkins Credentials,
- le déploiement avec **Docker Compose**.

---

## 🏗️ Architecture du projet

Le projet est composé de plusieurs services :

- **car-service** : microservice de gestion des voitures  
- **client-service** : microservice de gestion des clients  
- **gateway-service** : Spring Cloud Gateway  
- **eureka-server** : Service Discovery (Netflix Eureka)  
- **deploy** : fichiers Docker Compose pour le déploiement

---

## ⚙️ Outils et technologies utilisés

- **Java 17**
- **Spring Boot**
- **Spring Cloud (Gateway, Eureka)**
- **Maven**
- **Jenkins**
- **SonarQube**
- **Docker & Docker Compose**
- **GitHub**

---

## 🔁 Pipeline Jenkins (CI/CD)

Le pipeline Jenkins est défini dans un **Jenkinsfile** et contient les étapes suivantes :

### 1️⃣ Clonage du dépôt
Récupération du code source depuis GitHub (branche `main`).

### 2️⃣ Build des microservices
Compilation de chaque microservice avec Maven :
- `car`
- `client`
- `gateway`
- `server_eureka`

```bash
mvn clean install -DskipTests
