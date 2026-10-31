# Web client

`index.html` is a no-build dashboard client. It uses browser-native APIs,
Amazon Cognito for authentication, and the Saral Cloud HTTP API for data.

Configure `window.SARAL_CONFIG` in a deployment-specific copy before serving
the file. Keep API and Cognito values out of the public repository.

The sample CSV files can be imported from the Customers and Products tabs.
