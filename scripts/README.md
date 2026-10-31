# Deployment scripts

The scripts are intended to run from the repository root with AWS CLI v2
already authenticated.

- `fix-backend.ps1` updates both Lambda packages, applies CORS, and checks
  routes and stage auto-deployment.
- `deploy-web.ps1` uploads the static client to S3 and removes stale objects.

Set `SARAL_AWS_REGION` and the script-specific environment variable described
in the root README before running either script.

## Demo accounts

The demo users are:

- `testowner@saral.dev`
- `testsales@saral.dev`
- `testwarehouse@saral.dev`
- `testcollection@saral.dev`

Demo passwords are intentionally not stored in repository files. Set or reset
them securely in Cognito or with the AWS CLI:

```powershell
aws cognito-idp admin-set-user-password `
  --user-pool-id <USER_POOL_ID> `
  --username <EMAIL> `
  --password <PASSWORD> `
  --permanent `
  --region <AWS_REGION> `
  --profile <AWS_PROFILE>
```
  