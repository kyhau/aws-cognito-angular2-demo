# Cognito Web UI in Angular2/Typescript

The code is modified from https://github.com/awslabs/aws-cognito-angular2-quickstart.

## Build
node v6.9.4: [![Build Status](https://travis-ci.org/kyhau/aws-cognito-angular2-webui.svg?branch=master)](https://travis-ci.org/kyhau/aws-cognito-angular2-webui)

## Demo

[Cognito Web UI in Angular2](http://k-cognito-alpha.s3-website-ap-southeast-2.amazonaws.com)

## Actual AWS Setup

Use Cognito.template in [https://github.com/kyhau/aws-cf-templates/templates](https://github.com/kyhau/aws-cf-templates)
to create

1. Cognito Identity Pool with auth/unauth roles and policies
2. Cognito User Pool
3. DynamoDB for storing login activities
4. S3 (optional, for hosting static website)

## Build and run
```
# Install the NPM & Bower packages, and typings
npm install
npm install -g @angular/cli@latest
```
```
# Run the app in dev mode
npm start
```
```
# Build the project and sync the output with the S3 bucket
ng build; cd dist; aws s3 sync . s3://bn-cognito-sydney/ --acl public-read
```
```
# Test it out
curl –I http://bn-cognito-sydney.s3-website-ap-southeast-2.amazonaws.com/
```

## Necessary changes
You  will need to change the following configurations in `cognito.service.ts` and `ddb.service.ts`.

1. User pool ID,
2. Identity pool ID,
2. Region, and
3. DynamoDB Table ID. 

As is, the code has default configuration, pointing to the developer's region.

## What does this app do?
![QuickStart Angular2 Cognito App](/aws/cognito-quickstart-app-overview.png?raw=true)
