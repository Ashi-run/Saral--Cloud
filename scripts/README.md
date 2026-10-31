# Deployment scripts

The scripts are intended to run from the repository root with AWS CLI v2
already authenticated.

- `fix-backend.ps1` updates both Lambda packages, applies CORS, and checks
  routes and stage auto-deployment.
- `deploy-web.ps1` uploads the static client to S3 and removes stale objects.

Set `SARAL_AWS_REGION` and the script-specific environment variable described
in the root README before running either script.
