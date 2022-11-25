#!/bin/bash
echo "Starting..."
CLIENT="gg"
COUNTRY="sg"
ENVIRONMENT="dev"
SERVICE="oauth2demo"
SUBSERVICE="app"
REGION="ap-southeast-1"
ECS="ecs_dev.yml"
BUILD_YML="build.yml"
ACCOUNT_ID=""
AWS_PROFILE=""

IMAGE_WEB=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$CLIENT-$COUNTRY-$ENVIRONMENT-$SERVICE-$SUBSERVICE-web:latest
IMAGE_NGINX=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$CLIENT-$COUNTRY-$ENVIRONMENT-$SERVICE-$SUBSERVICE-nginx:latest
CLUSTER=$CLIENT-$COUNTRY-$ENVIRONMENT-$SERVICE-$SUBSERVICE
PROJECT_NAME=$CLIENT-$COUNTRY-$ENVIRONMENT-$SERVICE-$SUBSERVICE

export IMAGE_WEB=${IMAGE_WEB}
export IMAGE_NGINX=${IMAGE_NGINX}

echo "Logging in to docker..."

echo "Configuring ecs-cli..."
docker login -u AWS -p $(aws ecr get-login-password --region $REGION --profile $AWS_PROFILE) $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
ecs-cli configure --region ${REGION} --cluster ${CLUSTER}

echo "Building docker images..."
docker-compose \
	-f ${BUILD_YML} \
	--project-name oauth2demo \
	build

# Tag the docker builds
docker tag oauth2demo_web:latest ${IMAGE_WEB}
docker tag oauth2demo_nginx:latest ${IMAGE_NGINX}

# Push docker images
echo 'Pushing Docker Image..................................................................................'
docker push ${IMAGE_WEB}
docker push ${IMAGE_NGINX}

# Stop existing service
echo "Stopping existing services..."
ecs-cli compose \
	-f ${ECS} \
	$([ -n $PROJECT_NAME ] && echo "--project-name ${PROJECT_NAME}") \
    --aws-profile ${AWS_PROFILE} \
	service \
	stop

# Start services with new images
echo "Starting new services..."
ecs-cli compose \
	-f ${ECS} \
	--verbose \
	$([ -n $PROJECT_NAME ] && echo "--project-name ${PROJECT_NAME}") \
	--aws-profile ${AWS_PROFILE} \
	service \
	up

echo "Completed!"