#!/bin/bash

# Description:
# Ce script récupère l'adresse IP publique du service Cloud Run déployé.
# Il prend en argument le nom de l'environnement et adapte les configurations en conséquence.
# Le script inclut également une gestion des erreurs et des fonctionnalités de journalisation.

# Usage:
# ./get_cloud_run_ip.sh <environment>

# Définir le journal
LOG_FILE="cloud_run_ip.log"
exec > >(tee -a $LOG_FILE) 2>&1

# Fonction pour journaliser un message avec timestamp
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Fonction de gestion des erreurs
handle_error() {
    log_message "Erreur: $1"
    exit 1
}

# Vérifier que le nom de l'environnement est passé en argument
if [ -z "$1" ]; then
    handle_error "Le nom de l'environnement est requis comme argument."
fi

# Récupérer le nom de l'environnement depuis l'argument
ENVIRONMENT="$1"
log_message "Récupération de l'adresse IP publique pour l'environnement: $ENVIRONMENT"

# Définir le nom du service Cloud Run en fonction de l'environnement
SERVICE_NAME="php-fpm-app-$ENVIRONMENT"

# Récupérer l'URL du service Cloud Run
SERVICE_URL=$(gcloud run services describe "$SERVICE_NAME" --platform managed --region us-central1 --format 'value(status.url)') || handle_error "Impossible de récupérer l'URL du service Cloud Run."

# Extraire l'adresse IP publique de l'URL du service
PUBLIC_IP=$(dig +short "$(echo $SERVICE_URL | awk -F[/:] '{print $4}')" | tail -n1) || handle_error "Impossible de récupérer l'adresse IP publique."

# Vérifier que l'adresse IP a été récupérée
if [ -z "$PUBLIC_IP" ]; then
    handle_error "Adresse IP publique non trouvée pour le service $SERVICE_NAME."
fi

# Afficher et journaliser l'adresse IP publique
log_message "L'adresse IP publique pour le service $SERVICE_NAME est: $PUBLIC_IP"
echo "L'adresse IP publique pour le service $SERVICE_NAME est: $PUBLIC_IP"
