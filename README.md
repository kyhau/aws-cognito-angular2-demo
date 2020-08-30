# Cognito Web UI in Angular2

**[kyhau](https://github.com/kyhau)**: My folk of [awslabs/aws-cognito-angular-quickstart](https://github.com/awslabs/aws-cognito-angular-quickstart). See [all changes here](https://github.com/kyhau/aws-cognito-angular2-webui/pulls?q=is%3Apr+is%3Aclosed).

---

node v10.16: [![Build Status](https://travis-ci.org/kyhau/aws-cognito-angular2-webui.svg?branch=master)](
https://travis-ci.org/kyhau/aws-cognito-angular2-webui)

The code is modified from https://github.com/awslabs/aws-cognito-angular2-quickstart.

The app provides interface show how to use Cognito User Pool and Cognito Identity Pool to support user sign-up, sign-in
and authentication for your app. The app also shows log to log the user login activiies to a DynamoDB table.

## Demo

See [Cognito Web UI in Angular2](http://k-cognito-alpha.s3-website-ap-southeast-2.amazonaws.com).

## Actual AWS Setup

Use `Cognito-UserPool-IdentityPool-DynamoDB.template.yaml` in
[kyhau/aws-tools/Cognito](https://github.com/kyhau/aws-tools/tree/master/Cognito/cloudformation)
to create

1. Cognito Identity Pool with auth/unauth roles and policies
2. Cognito User Pool
3. DynamoDB for storing login activities
4. S3 for hosting static website

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
ng build; cd dist; aws s3 sync . s3://(your-bucket-name)/ --acl public-read
```
```
# Test it out
curl –I http://(your-bucket-name).s3-website-(your-region).amazonaws.com/
```

## Necessary changes
You  will need to change the following configurations in
[`cognito.service.ts`](src/app/service/cognito.service.ts) and
[`ddb.service.ts`](src/app/service/ddb.service.ts).

1. User pool ID,
2. Identity pool ID,
2. Region, and
3. DynamoDB Table ID.

As is, the code has default configuration, pointing to the developer's region.
