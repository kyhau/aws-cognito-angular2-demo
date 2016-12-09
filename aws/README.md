# Create infrastructure for using Cognito User Pool and Identity Pool

## Resource to be created

```createResources.sh``` uses awscli commands to create the following resources.

1. Cognito Identity Pool with auth/unauth roles and policies
2. Cognito User Pool
3. DynamoDB for storing login activities
4. S3 (optional, for hosting static website)

### Run

1. Set up aws config and credentials 
2. Install [awscli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
3. Change the following configurations in ```createResources.sh```.

    ```
    REGION=ap-southeast-2
    COGNITO_REGION=ap-northeast-1
    ROOT_NAME=TestCognito
    BUCKET_NAME=bn-testing-cognito
    ```
4. Run ```createResources.sh```
