# Run from the folder that contains "lambdas" and "scripts":
# powershell -ExecutionPolicy Bypass -File scripts\fix-backend.ps1
$ErrorActionPreference = "Stop"
$R = $env:SARAL_AWS_REGION
$API = $env:SARAL_API_ID

if ([string]::IsNullOrWhiteSpace($R)) {
    throw "Set SARAL_AWS_REGION before running this script."
}
if ([string]::IsNullOrWhiteSpace($API)) {
    throw "Set SARAL_API_ID before running this script."
}

Write-Host "1/4 Deploying fixed team Lambdas..."
aws lambda update-function-code --function-name saral-team-invite --zip-file fileb://lambdas/saral-team-invite.zip --region $R --query LastModified
aws lambda update-function-code --function-name saral-list-team   --zip-file fileb://lambdas/saral-list-team.zip   --region $R --query LastModified

Write-Host "2/4 Applying CORS to the API..."
aws apigatewayv2 update-api --api-id $API --cors-configuration file://scripts/cors.json --region $R --query CorsConfiguration

Write-Host "3/3 Checking routes, stage and CORS..."
aws apigatewayv2 get-routes --api-id $API --region $R --query "Items[].RouteKey" --output text
aws apigatewayv2 get-stage --api-id $API --stage-name '$default' --region $R --query "AutoDeploy"

Write-Host "DONE. Create or reset test users securely through Cognito."
