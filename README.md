# Saral Cloud

Saral Cloud is a small, serverless team dashboard for orders, customers,
products, payments, and delivery status. This repository contains the static
web client, deployment helpers, CORS configuration, sample CSV files, and
Lambda deployment packages.

## Repository layout

```text
.
├── lambdas/                 # ZIP packages uploaded by fix-backend.ps1
├── scripts/
│   ├── cors.json            # API Gateway HTTP API CORS policy
│   ├── deploy-web.ps1      # Uploads the static client to S3
│   └── fix-backend.ps1     # Updates Lambdas and API CORS
└── web/
    ├── index.html           # No-build dashboard client
    ├── sample-customers.csv
    └── sample-products.csv
```

## Security first

Never commit AWS access keys, passwords, tokens, private endpoints, or
environment-specific identifiers. The published files intentionally use
environment variables and browser configuration instead of containing live
deployment values.

If credentials were previously shared, deactivate or delete the exposed key,
create a replacement, and run `aws configure` again. Use an IAM identity with
only the permissions needed for this deployment.

## Prerequisites

- PowerShell 5.1 or newer
- AWS CLI v2, authenticated with `aws configure` or an AWS profile
- An existing S3 website bucket
- An API Gateway HTTP API and Cognito user pool

## Configure the web client

Before deploying, copy the template from `web/config.example.js` into a
deployment-specific configuration and set `window.SARAL_CONFIG` near the top
of the script:

```js
window.SARAL_CONFIG = {
  apiBaseUrl: "https://YOUR_API_ID.execute-api.YOUR_REGION.amazonaws.com",
  region: "YOUR_REGION",
  clientId: "YOUR_COGNITO_APP_CLIENT_ID"
};
```

Keep these values in a deployment-specific working copy or inject them during
your release process. Do not commit production identifiers if this repository
is public.

## Deploy the backend

Set the required environment variables in the same PowerShell session:

```powershell
$env:SARAL_AWS_REGION = "your-region"
$env:SARAL_API_ID = "your-http-api-id"
.\scripts\fix-backend.ps1
```

The script uploads the two Lambda packages, applies `scripts/cors.json`, and
prints the configured routes and `$default` stage auto-deploy status. User
password resets are deliberately not automated; manage users through Cognito
with secure, temporary credentials.

## Deploy the website

```powershell
$env:SARAL_S3_BUCKET = "your-website-bucket"
$env:SARAL_AWS_REGION = "your-region"
.\scripts\deploy-web.ps1
```

The script uploads `web/index.html` with no-cache headers and removes stale
objects except for the current entry point. It prints the website URL after a
successful upload.

## Verify CORS

Replace the placeholders before running this check:

```powershell
curl.exe -i -X OPTIONS `
  "https://YOUR_API_ID.execute-api.YOUR_REGION.amazonaws.com/orders" `
  -H "Origin: https://YOUR_WEBSITE_HOST" `
  -H "Access-Control-Request-Method: GET" `
  -H "Access-Control-Request-Headers: authorization"
```

The response should be a successful preflight response and include the
configured `access-control-allow-origin` header.

## Import sample data

After signing in with a user that has the required role, use the Customers and
Products tabs to import:

- `web/sample-customers.csv`
- `web/sample-products.csv`

The dashboard supports role-based tabs for owners, managers, sales, warehouse,
and collections users. Create test users and temporary passwords in Cognito;
do not document real credentials in this repository.

## Troubleshooting

- Browser errors usually indicate an incorrect API URL or CORS policy.
- Lambda failures are available in CloudWatch under the corresponding
  `/aws/lambda/<function-name>` log group.
- Confirm that the API's routes and `$default` stage auto-deploy setting match
  the output from `scripts/fix-backend.ps1`.

## License

No license has been selected yet. Add a license before distributing this
project beyond your organization.

## Contributing

Keep deployment values out of Git, validate PowerShell syntax before changing
deployment scripts, and test the dashboard in a browser after changing
`web/index.html`. See [SECURITY.md](SECURITY.md) for reporting guidance.
