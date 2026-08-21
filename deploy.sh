#!/bin/bash

set -e

ENV=$1
MODE=$2

if [ -z "$ENV" ]; then
  echo "Usage: ./deploy.sh <dev|staging|prod> [--plan-only]"
  exit 1
fi

if [ ! -f "environments/${ENV}.tfvars" ]; then
  echo "No tfvars file for environment: $ENV"
  exit 1
fi

echo "Deploying environment: $ENV"

if [ "$ENV" = "prod" ]; then
  WORKSPACE="production"
else
  WORKSPACE="$ENV"
fi

terraform workspace select "$WORKSPACE" 2>/dev/null || terraform workspace new "$WORKSPACE"

if [ "$MODE" == "--plan-only" ]; then
  echo "PLAN ONLY MODE — no infrastructure will be changed."
  terraform plan -var-file="environments/${ENV}.tfvars"
else
  terraform apply \
    -var-file="environments/${ENV}.tfvars" \
    -auto-approve

  echo "Deployment complete. ALB URL:"
  terraform output alb_url
fi