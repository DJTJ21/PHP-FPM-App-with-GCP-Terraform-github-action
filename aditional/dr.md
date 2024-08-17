# Disaster Recovery (DR) Strategy

## Introduction

Ce document décrit la stratégie de récupération en cas de sinistre pour l'application déployée sur Google Cloud. 

## Objectifs

1. Minimiser le temps d'arrêt en cas de sinistre.
2. Assurer l'intégrité des données.
3. Automatiser la récupération lorsque cela est possible.

## Stratégies de Récupération

### 1. Backup Régulier de Cloud SQL

Utilisez les sauvegardes automatiques de Google Cloud SQL pour restaurer les données en cas de panne.

### 2. Réplication des Buckets Cloud Storage

Activez la réplication des buckets entre plusieurs régions pour garantir la disponibilité des fichiers statiques.

### 3. Infrastructure Redondante

Utilisez Terraform pour déployer une infrastructure redondante dans une région secondaire. Les ressources critiques, comme Cloud Run et Cloud SQL, doivent être répliquées dans cette région.

## Plan de Récupération

### Étape 1: Activer l'infrastructure secondaire
Déployer les ressources à partir de Terraform dans la région de secours.

### Étape 2: Restaurer les données de sauvegarde
Récupérer les données Cloud SQL et les fichiers statiques à partir des sauvegardes.

### Étape 3: Basculer le traffic
Mettre à jour les enregistrements DNS pour pointer vers l'infrastructure secondaire.

## Conclusion

La mise en œuvre de cette stratégie DR assure que l'application reste disponible même en cas de sinistre majeur.
