# Cognito Quickstart

## Build
6.x.x [![Build Status](https://travis-ci.org/kyhau/aws-cognito-angular2-demo.svg?branch=master)](https://travis-ci.org/kyhau/aws-cognito-angular2-demo)


## Actual AWS Setup

`createResources.sh` uses `awscli` commands to create the following resources.

1. Cognito Identity Pool with auth/unauth roles and policies
2. Cognito User Pool
3. DynamoDB for storing login activities
4. S3 (optional, for hosting static website)

### Run

1. Install [awscli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
2. Set up aws config and credentials 
3. Change the following configurations in `createResources.sh`.

    ~~~~
    REGION=ap-southeast-2
    COGNITO_REGION=ap-northeast-1
    ROOT_NAME=CognitoTestAlpha
    BUCKET_NAME=cognito-test-alpha
    ~~~~
4. Run `createResources.sh`

## Build and Run sample frontend for demo

```
# Install the NPM & Bower packages, and typings
npm install
npm install -g angular-cli
```
```
# Run the app in dev mode
npm start
```
```
# Build the project and sync the output with the S3 bucket
ng build; cd dist; aws s3 sync . s3://cognito-test-alpha/ --acl public-read
```
```
# Test it out
curl –I http://cognito-test-alpha.s3-website-ap-southeast-2.amazonaws.com/
```

## Necessary changes
As is, the code has default configuration, pointing to the developer's region. You 
will need to change the pool id, region, and dynamodb table id. You can find these
configurations in ```aws.service.ts``` and ```cognito.service.ts```

## What does this app do?
![QuickStart Angular2 Cognito App](/aws/cognito-quickstart-app-overview.png?raw=true)
