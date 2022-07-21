# Show all credentials names and values stored in Jenkins

This is useful if you want to retrieve API Keys and other credentials from a Jenkins cluster.

Logged as a Jenkins admin, go to "Manage Jenkins", then script console and paste the following script:

```groovy
def creds = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
    com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class,
    Jenkins.instance,
    null,
    null
);
for (c in creds) {
     println( ( c.properties.privateKeySource ? "ID: " + c.id + ", UserName: " + c.username + ", Private Key: " + c.getPrivateKey() : ""))
}
for (c in creds) {
     println( ( c.properties.password ? "ID: " + c.id + ", UserName: " + c.username + ", Password: " + c.password : ""))
}
```