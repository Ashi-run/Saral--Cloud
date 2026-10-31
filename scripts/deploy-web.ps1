# Uploads web\index.html to the configured S3 website bucket.
$Bucket = $env:SARAL_S3_BUCKET
$Region = $env:SARAL_AWS_REGION

if ([string]::IsNullOrWhiteSpace($Bucket)) {
    throw "Set SARAL_S3_BUCKET before running this script."
}
if ([string]::IsNullOrWhiteSpace($Region)) {
    throw "Set SARAL_AWS_REGION before running this script."
}

aws s3 cp web/index.html "s3://$Bucket/index.html" --content-type "text/html" --cache-control "no-cache" --region $Region
if ($LASTEXITCODE -ne 0) {
    throw "Uploading the website failed."
}

# Remove stale objects while preserving the current entry point.
aws s3 rm "s3://$Bucket" --recursive --exclude "index.html" --region $Region
if ($LASTEXITCODE -ne 0) {
    throw "Removing stale website objects failed."
}

Write-Host "Upload complete. Open the website endpoint configured for bucket '$Bucket'."
