
### Objectif de la Solution

L'objectif est de créer une infrastructure complète sur GCP en utilisant Terraform. Les ressources à déployer incluent :
1. **Un Projet Google Cloud** (facultatif si déjà existant).
2. **Une instance Cloud SQL (MySQL)**.
3. **Un Bucket Cloud Storage** pour stocker des fichiers statiques.
4. **Un Service Cloud Run** qui déploie une application PHP-FPM via un conteneur Docker.
5. **Une configuration Nginx** pour servir des fichiers statiques et rediriger les requêtes vers le conteneur PHP-FPM.
6. **Un Équilibrage de Charge HTTP(S)** pour diriger le trafic vers le service Cloud Run.

### Structure du Projet

Le projet est organisé en plusieurs répertoires et fichiers pour faciliter la réutilisation, la lisibilité et la maintenance.

#### Arborescence des Répertoires et Fichiers
```plaintext
.
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── backend.tf
├── modules/
│   ├── cloudsql/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── cloudrun/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── storage/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
└── README.md
```

- **`main.tf`** : Ce fichier est le fichier principal de Terraform qui orchestre la création des différentes ressources en appelant les modules.
- **`variables.tf`** : Ce fichier déclare toutes les variables globales utilisées dans le projet.
- **`outputs.tf`** : Ce fichier contient les outputs, c'est-à-dire les informations utiles extraites après la création des ressources (comme les URL, les noms, etc.).
- **`terraform.tfvars`** : Ce fichier contient les valeurs des variables spécifiques à l'environnement (par exemple, les identifiants de projet, les noms d'instance).
- **`backend.tf`** : Ce fichier configure la gestion de l'état de Terraform pour stocker les informations dans un backend distant sécurisé.
- **`modules/`** : Ce répertoire contient les différents modules réutilisables pour créer des composants spécifiques de l'infrastructure.

### 1. Fichier Principal `main.tf`

Ce fichier est le point d'entrée de la configuration Terraform. Il orchestre la création des ressources en utilisant des modules.

```hcl
provider "google" {
  project = var.project_id
  region  = var.region
}
```
- **Provider** : Le provider Google Cloud est configuré ici, en utilisant les variables `project_id` et `region` pour spécifier le projet et la région GCP.

```hcl
module "cloudsql" {
  source            = "./modules/cloudsql"
  instance_name     = var.sql_instance_name
  database_name     = var.sql_database_name
  database_user     = var.sql_database_user
  database_password = var.sql_database_password
  region            = var.region
}
```
- **Module Cloud SQL** : Ce module gère la création de l'instance MySQL sur Cloud SQL. Les paramètres comme `instance_name`, `database_name`, etc., sont passés en tant que variables, ce qui permet de personnaliser la configuration pour différents environnements.

```hcl
module "storage" {
  source = "./modules/storage"
  bucket_name = var.bucket_name
  location    = var.region
}
```
- **Module Storage** : Ce module gère la création d'un bucket Cloud Storage pour stocker des fichiers statiques.

```hcl
module "cloudrun" {
  source = "./modules/cloudrun"
  image   = var.image
  region  = var.region
  service_name = var.cloudrun_service_name
  env_vars = {
    DB_HOST     = module.cloudsql.db_host,
    DB_NAME     = module.cloudsql.db_name,
    DB_USER     = module.cloudsql.db_user,
    DB_PASSWORD = module.cloudsql.db_password,
  }
}
```
- **Module Cloud Run** : Ce module déploie un service Cloud Run avec une image Docker spécifiée. Il configure également les variables d'environnement (`env_vars`) pour se connecter à la base de données MySQL.

### 2. Fichier `variables.tf`

Ce fichier centralise la déclaration de toutes les variables utilisées dans la configuration Terraform.

```hcl
variable "project_id" {
  description = "ID du projet Google Cloud"
  type        = string
}
```
- **Variables** : Les variables permettent de rendre la configuration flexible et réutilisable. Par exemple, le `project_id` peut varier selon les environnements (développement, production, etc.).

### 3. Fichier `outputs.tf`

Ce fichier définit les outputs, c’est-à-dire les valeurs importantes générées par Terraform après l'application de la configuration.

```hcl
output "sql_instance_connection_name" {
  value = module.cloudsql.connection_name
}
```
- **Outputs** : Les outputs comme `sql_instance_connection_name` sont utiles pour récupérer des informations sur les ressources créées, que vous pourriez utiliser dans d'autres scripts ou configurations.

### 4. Fichier `backend.tf`

Ce fichier configure la gestion de l'état Terraform. L'état stocke des informations sur les ressources gérées par Terraform.

```hcl
terraform {
  backend "gcs" {
    bucket = "terraform-state-bucket"
    prefix = "terraform/state"
  }
}
```
- **Backend GCS** : L'état Terraform est stocké dans un bucket Google Cloud Storage (`terraform-state-bucket`). Cela permet une gestion centralisée et sécurisée, essentielle dans des environnements partagés ou de production.

### 5. Fichier `terraform.tfvars`

Ce fichier contient les valeurs spécifiques aux variables déclarées dans `variables.tf`. C'est ici que vous personnalisez la configuration pour un environnement donné.

```hcl
project_id            = "my-gcp-project"
region                = "us-central1"
sql_instance_name     = "my-sql-instance"
sql_database_name     = "my-database"
sql_database_user     = "admin"
sql_database_password = "supersecurepassword"
bucket_name           = "my-static-files-bucket"
image                 = "gcr.io/my-gcp-project/php-fpm-image"
cloudrun_service_name = "my-cloudrun-service"
```

### 6. Modules

#### a) Module `cloudsql`

Ce module gère la création de l'instance MySQL sur Cloud SQL.

- **`modules/cloudsql/main.tf`** : Contient la logique pour créer l'instance, la base de données, et l'utilisateur MySQL.
- **`modules/cloudsql/variables.tf`** : Contient la déclaration des variables spécifiques à ce module.
- **`modules/cloudsql/outputs.tf`** : Définit les outputs pour récupérer des informations utiles comme le `connection_name`.

#### b) Module `storage`

Ce module gère la création du bucket Cloud Storage.

- **`modules/storage/main.tf`** : Crée un bucket Cloud Storage.
- **`modules/storage/variables.tf`** : Déclare les variables spécifiques à ce module.
- **`modules/storage/outputs.tf`** : Définit les outputs pour récupérer l'URL du bucket.

#### c) Module `cloudrun`

Ce module gère le déploiement du service Cloud Run.

- **`modules/cloudrun/main.tf`** : Déploie un service Cloud Run en utilisant une image Docker spécifiée. Il configure également les variables d'environnement pour l'application.
- **`modules/cloudrun/variables.tf`** : Déclare les variables spécifiques au service Cloud Run, telles que le nom du service, la région, et les variables d'environnement.
- **`modules/cloudrun/outputs.tf`** : Définit les outputs pour récupérer l'URL du service Cloud Run.

### Meilleures Pratiques Suivies

1. **Modularité** : En utilisant des modules, la configuration est organisée, réutilisable et maintenable. Chaque module encapsule une partie spécifique de l'infrastructure.
2. **Gestion des Variables** : Les variables sont centralisées pour permettre une configuration spécifique à chaque environnement (par exemple, dev, staging, prod).
3. **Gestion de l'État** : L'utilisation d'un backend distant pour gérer l'état Terraform assure que l'état est partagé entre les membres de l'équipe et sécurisé.
4. **Outputs** : Les outputs fournissent des informations utiles qui peuvent être utilisées ailleurs ou pour d'autres opérations post-déploiement.
5. **Documentation** : Les descriptions dans le code facilitent la compréhension et la maintenance de l'infrastructure.

En suivant ces pratiques, la solution  que nous avons mise en place est robuste, évolutive et prête pour des environnements de production, tout en restant facile à gérer et à étendre.