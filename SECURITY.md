# Security policy

## Do not publish secrets

Do not commit AWS credentials, Cognito passwords, access tokens, private keys,
or environment-specific configuration to this repository. Use an AWS profile,
environment variables, or a deployment secret store instead.

The web client reads deployment values from `window.SARAL_CONFIG`; use
`web/config.example.js` as a template and keep the populated copy out of Git.

## Reporting a vulnerability

If you find a security issue, do not open a public issue with exploit details.
Contact the repository owner privately with reproduction steps and impact.
