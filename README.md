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
<img width="542" height="424" alt="image" src="https://github.com/user-attachments/assets/385f4c1e-98b0-4558-bcb9-3d456df9ca80" />

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
```
### SonarQube
<img width="1755" height="849" alt="image" src="https://github.com/user-attachments/assets/b601646d-fddb-4b8e-bc20-85fa3d989433" />
<img width="1755" height="1684" alt="image" src="https://github.com/user-attachments/assets/027c4337-12cf-4581-9f25-9d3e5c6549ec" />

### docker compose
<img width="1755" height="1378" alt="image" src="https://github.com/user-attachments/assets/5faa9fdb-ff6e-4d40-97e6-f4ccbe79105d" />


