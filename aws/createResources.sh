#!/usr/bin/env bash

###############################################################################
# Review and update the following settings before running the script

# Default region =  sydney (IAM, S3 not region specific)
REGION=ap-southeast-2
# Cognito region = tokyo
COGNITO_REGION=ap-northeast-1
# DynamoDB region = tokyo
DYNAMODB_REGION=ap-northeast-1
ROOT_NAME=TestCognito
BUCKET_NAME=${ROOT_NAME}

TABLE_NAME=${ROOT_NAME}LoginTrail
ROLE_NAME_PREFIX=$ROOT_NAME
POOL_NAME=$ROOT_NAME
IDENTITY_POOL_NAME=$ROOT_NAME

echo "######################################################################"
echo "Creating bucket $BUCKET_NAME ..."
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION

echo "Adding the S3 static website configuration and bucket policy ..."
aws s3api put-bucket-website --bucket $BUCKET_NAME --website-configuration file://website.json
cat s3-bucket-policy.json | sed 's/REPLACE_ME/'$BUCKET_NAME'/' > tmp-s3-bucket-policy.json
aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy file://tmp-s3-bucket-policy.json

echo "######################################################################"
echo "Creating DynamoDB Table ..."
aws dynamodb create-table \
    --table-name $TABLE_NAME \
    --attribute-definitions \
        AttributeName=userId,AttributeType=S \
        AttributeName=activityDate,AttributeType=S \
    --key-schema AttributeName=userId,KeyType=HASH AttributeName=activityDate,KeyType=RANGE \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    --region $DYNAMODB_REGION
tableArn=$(aws dynamodb describe-table --table-name TestCognitoLoginTrail | grep TableArn | awk -F\" '{print $4}')
echo "TableArn is $tableArn"

echo "######################################################################"
echo "Creating a Cognito Identity and setting roles ..."
aws cognito-identity create-identity-pool --identity-pool-name $IDENTITY_POOL_NAME --allow-unauthenticated-identities --region $COGNITO_REGION | grep IdentityPoolId | awk '{print $2}' | xargs |sed -e 's/^"//'  -e 's/"$//' -e 's/,$//' > tmp-poolId
identityPoolId=$(cat tmp-poolId)
echo "Created an identity pool with id of " $identityPoolId

echo "Creating an IAM role for unauthenticated users ..."
cat unauthrole-trust-policy.json | sed 's/IDENTITY_POOL/'$identityPoolId'/' > tmp-unauthrole-trust-policy.json
aws iam create-role --role-name $ROLE_NAME_PREFIX-unauthenticated-role --assume-role-policy-document file://tmp-unauthrole-trust-policy.json
aws iam put-role-policy --role-name $ROLE_NAME_PREFIX-unauthenticated-role --policy-name CognitoPolicy --policy-document file://unauthrole.json

echo "Creating an IAM role for authenticated users ..."
cat authrole-trust-policy.json | sed 's/IDENTITY_POOL/'$identityPoolId'/' > tmp-authrole-trust-policy.json
aws iam create-role --role-name $ROLE_NAME_PREFIX-authenticated-role --assume-role-policy-document file://tmp-authrole-trust-policy.json
# replace /  to \/  first
tableArn=$(echo $tableArn | sed 's/\//\\\//')
cat authrole.json | sed 's/TABLE_ARN/'$tableArn'/' > tmp-authrole.json
aws iam put-role-policy --role-name $ROLE_NAME_PREFIX-authenticated-role --policy-name CognitoPolicy --policy-document file://tmp-authrole.json

echo "######################################################################"
echo "Creating the user pool ..."
aws cognito-idp create-user-pool --pool-name $POOL_NAME --auto-verified-attributes email --policies file://user-pool-policy.json --region $COGNITO_REGION > tmp-$POOL_NAME-create-user-pool
userPoolId=$(grep -Po '"Id":.*?[^\\]",' tmp-$POOL_NAME-create-user-pool | awk -F'"' '{print $4}')
echo "Created user pool with an id of " $userPoolId

echo "Creating the user pool client (i.e. User Pool > Apps...)"
aws cognito-idp create-user-pool-client --user-pool-id $userPoolId --no-generate-secret --client-name webapp --region $COGNITO_REGION > tmp-$POOL_NAME-create-user-pool-client
userPoolClientId=$(grep -Po '"ClientId":.*?[^\\]",' tmp-$POOL_NAME-create-user-pool-client | awk -F'"' '{print $4}')
echo "Created user pool client with id of " $userPoolClientId

echo "######################################################################"
echo "Adding the user pool and user pool client id to the identity pool ..."
aws cognito-identity update-identity-pool --allow-unauthenticated-identities --identity-pool-id $identityPoolId --identity-pool-name $IDENTITY_POOL_NAME --cognito-identity-providers ProviderName=cognito-idp.$COGNITO_REGION.amazonaws.com/$userPoolId,ClientId=$userPoolClientId --region $COGNITO_REGION

echo "######################################################################"
echo "Updating cognito identity with the roles ..."
echo aws iam get-role --role-name $ROLE_NAME_PREFIX-authenticated-rol
authRoleArn=$(aws iam get-role --role-name $ROLE_NAME_PREFIX-authenticated-role | grep arn:aws:iam | awk -F\" '{print $4}')
unauthRoleArn=$(aws iam get-role --role-name $ROLE_NAME_PREFIX-unauthenticated-role | grep arn:aws:iam | awk -F\" '{print $4}')
aws cognito-identity set-identity-pool-roles --identity-pool-id $identityPoolId --roles authenticated=$authRoleArn,unauthenticated=$unauthRoleArn --region $COGNITO_REGION

sleep 3
echo "######################################################################"
echo "Region: " $REGION
echo "Cognito Region: " $COGNITO_REGION
echo "DynamoDB Region: " $DYNAMODB_REGION
echo "DynamoDB Table: " $TABLE_NAME
echo "DynamoDB Table Arn: " $tableArn
echo "Identity Pool name: " $IDENTITY_POOL_NAME
echo "Identity Pool id: " $identityPoolId
echo "User Pool name: " $POOL_NAME
echo "User Pool id: " $userPoolId
echo "User Pool Client id: " $userPoolClientId
echo "Auth Role Arn" $authRoleArn
echo "Unauth Role Arn" $unauthRoleArn
