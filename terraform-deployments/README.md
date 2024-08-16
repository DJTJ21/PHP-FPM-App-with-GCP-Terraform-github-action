

# Documentation de Déploiement Terraform pour Multi-Environnement

## Table des Matières
1. [Introduction](#introduction)
2. [Structure du Projet Terraform](#structure-du-projet-terraform)
3. [Configuration des Environnements](#configuration-des-environnements)
   - [Fichier `main.tf`](#fichier-main.tf)
   - [Fichier `variables.tf`](#fichier-variables.tf)
   - [Fichier `terraform.tfvars`](#fichier-terraform.tfvars)
   - [Fichier `backend.tf`](#fichier-backend.tf)
4. [Modules Terraform](#modules-terraform)
5. [Processus de Déploiement](#processus-de-deploiement)
6. [Gestion de l'État Terraform](#gestion-de-l-etat-terraform)
7. [Meilleures Pratiques](#meilleures-pratiques)
8. [Dépannage](#dépannage)

---

## 1. Introduction

Ce projet Terraform est structuré pour gérer les déploiements dans différents environnements (`dev`, `prod`, etc.). Chaque environnement a sa propre configuration, tout en réutilisant des modules communs pour les composants de l'infrastructure. Cela permet une gestion simplifiée et modulable des environnements, tout en garantissant que chaque déploiement est adapté aux besoins spécifiques de l'environnement.

## 2. Structure du Projet Terraform

La structure du répertoire Terraform est organisée comme suit :

```
terraform-deployments/
│
├── modules/
│   ├── cloud_sql/
│   ├── cloud_storage/
│   ├── cloud_run/
│   └── load_balancer/
│   
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── backend.tf
│   │   └── terraform.tfvars
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── backend.tf
│       └── terraform.tfvars


```

### 3. Configuration des Environnements

Chaque environnement (`dev`, `prod`) dispose de ses propres fichiers de configuration pour définir les paramètres spécifiques à cet environnement.

#### Fichier `main.tf`

Le fichier `main.tf` dans chaque environnement contient les appels aux modules Terraform pour créer l'infrastructure.

```hcl
# environments/dev/main.tf

provider "google" {
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source  = "../../modules/vpc"
  name    = "dev-vpc"
  region  = var.region
}

module "cloud_sql" {
  source         = "../../modules/cloud_sql"
  instance_name  = "dev-sql-instance"
  region         = var.region
  tier           = "db-f1-micro"
}

module "cloud_storage" {
  source         = "../../modules/cloud_storage"
  bucket_name    = "dev-bucket"
}

module "cloud_run" {
  source         = "../../modules/cloud_run"
  service_name   = "dev-cloud-run"
  image          = var.image
}

module "load_balancer" {
  source         = "../../modules/load_balancer"
  backend_service_name = "dev-backend-service"
}
```

#### Fichier `variables.tf`

Le fichier `variables.tf` définit les variables spécifiques à chaque environnement, telles que l'ID du projet, la région, et l'image Docker.

```hcl
# environments/dev/variables.tf

variable "project_id" {
  description = "The project ID to deploy resources into"
}

variable "region" {
  description = "The region to deploy resources into"
  default     = "us-central1"
}

variable "image" {
  description = "The Docker image to deploy"
}
```

#### Fichier `terraform.tfvars`

Le fichier `terraform.tfvars` contient les valeurs spécifiques pour les variables de l'environnement.

```hcl
# environments/dev/terraform.tfvars

project_id = "your-dev-project-id"
image      = "gcr.io/your-dev-project-id/your-image:latest"
```

#### Fichier `backend.tf`

Le fichier `backend.tf` configure le backend de stockage de l'état Terraform pour chaque environnement, permettant de suivre les modifications d'infrastructure de manière sécurisée.

```hcl
# environments/dev/backend.tf

terraform {
  backend "gcs" {
    bucket = "your-dev-terraform-state-bucket"
    prefix = "terraform/state/dev"
  }
}
```

### 4. Modules Terraform

Les modules Terraform sont définis dans le répertoire `modules/`. Chaque module encapsule la logique pour gérer une ressource spécifique, comme un service Cloud Run, une instance Cloud SQL, ou un bucket de stockage.

Exemple de module `cloud_sql` :

```hcl
# modules/cloud_sql/main.tf

resource "google_sql_database_instance" "default" {
  name             = var.instance_name
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = var.tier
  }
}
```

### 5. Processus de Déploiement

Pour déployer l'infrastructure dans un environnement spécifique, suivez les étapes suivantes :

1. **Accédez au répertoire de l'environnement souhaité** (`dev` ou `prod`).

   ```bash
   cd terraform-deployments/environments/dev  # ou prod
   ```

2. **Initialisez Terraform** dans cet environnement.

   ```bash
   terraform init
   ```

3. **Appliquez la configuration Terraform**.

   ```bash
   terraform apply -var-file="terraform.tfvars" -auto-approve
   ```

### 6. Gestion de l'État Terraform

L'état Terraform est stocké de manière sécurisée dans Google Cloud Storage (GCS). Chaque environnement a son propre état, configuré via le fichier `backend.tf`. Cela permet de gérer l'infrastructure de manière indépendante pour chaque environnement.

```hcl
# Exemple de configuration backend pour un environnement de production

terraform {
  backend "gcs" {
    bucket = "your-prod-terraform-state-bucket"
    prefix = "terraform/state/prod"
  }
}
```

### 7. Meilleures Pratiques

- **Modules réutilisables** : nous avons utilise des modules pour encapsuler les composants de l'infrastructure afin de garantir la cohérence et la réutilisabilité.
- **Gestion de l'état** : nous avons Stocker l'état Terraform dans des backends sécurisés comme GCS pour assurer une gestion centralisée et collaborative des états.
- **Environnement par défaut** : nous avons definie des valeurs par défaut pour les variables courantes comme `region` pour simplifier la configuration.

### 8. Dépannage

#### Problèmes Communs et Solutions

- **Erreur d'authentification** : Assurez-vous que les clés du compte de service sont correctement configurées et que l'ID du projet est correct.
- **Échec lors de l'initialisation de Terraform** : Vérifiez que le bucket GCS est accessible et que les permissions sont correctement définies.
- **Conflit de ressources** : Vérifiez que les noms de ressources (comme les buckets ou les services) sont uniques à chaque environnement.

### Récupérer l'Adresse IP du Load Balancer

Une fois le déploiement terminé, vous pouvez récupérer l'adresse IP publique du Load Balancer avec la commande suivante :

```bash
gcloud compute addresses describe my-load-balancer-ip --region=us-central1 --format="get(address)"
```
