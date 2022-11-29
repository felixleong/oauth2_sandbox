# Configuration / Deployment guidelines

Before we start: kindly ensure that:
- The relevant AWS resources has already been deployed. ie; as part of terraform.
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html "AWS CLI") and [ECS CLI](https://github.com/aws/amazon-ecs-cli "ECS CLI") has been installed & configured locally.

### Fill up the necessary configuration
Ensure that the variables has been filled in for the following files. You may also override any existing variables that is deemed necessary.

File:`secrets.env`:
- `GGAUTH_OAUTH2_CLIENT_ID` - OAuth2 Client ID
- `GGAUTH_OAUTH2_CLIENT_SECRET` - OAuth2 Client Secret
- `VIRTUAL_HOST` - host/domain name of the website, ie; google.com

File:`local_deploy.sh`
- `ACCOUNT_ID` - AWS Account Identifier, eg; 34567890
- `AWS_PROFILE` - AWS profile name that is configured on AWS CLI with relevant permissions. List of configured profiles can be checked via `aws configure list-profiles`

### Build and deploy the images to ECR
Navigate to the project directory and run `./local_deploy.sh`