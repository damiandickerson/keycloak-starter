# Setting up Keycloak with Docker and Docker Compose

This guide will walk you through the process of setting up Keycloak using Docker Compose. Keycloak is an open source software product to allow single sign-on with identity and access management aimed at modern applications and services.

## Prerequisites

Before you begin, you'll need to have the following installed on your system:

- Docker
- Docker Compose

Although Docker is preferred, Podman and Podman Compose should work as alternatives.

## Installation

To set up Keycloak using Docker Compose, follow these steps:

1. Open ports to allow access to the services.<br>
- Redhat, CentOS, Rocky Linux
    ```
    sudo firewall-cmd --permanent --add-port=8443/tcp
    sudo firewall-cmd --reload
    ```
- Ubuntu
    ```
    sudo ufw allow 8443/tcp
    ```

2. SSL certificates:

    Keycloak requires SSL certificates.  Existing certificates can be used by editing the 'ENV_KC_CERTFILE' and 'ENV_KC_KEYFILE' variables within the .env file.  However, if self signed certificates are required for testing/development reasons, use the following commands.

    ```
    cd certs
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname"
    chmod 644 cert.pem
    chmod 644 key.pem
    ```

    This command should produce two certificate files.

3. Edit the `.env` environment file:
   
    If a domain name is not available for the keycloak server, then you can use the public ip address of the server for ENV_KC_HOSTNAME.  Ensure that the files referenced by ENV_KC_CERTFILE and ENV_KC_KEYFILE have permissions set such tht it is accessible. 

    ```
    ENV_DB_PASSWORD=keycloakdbaccess
    ENV_DB_USER=keycloakdbadmin
    ENV_DB_NAME=dbkc
    ENV_KC_HOSTNAME=<domain name or ip address>
    ENV_KC_CERTFILE=./certs/cert.pem
    ENV_KC_KEYFILE=./certs/key.pem
    ```

4. Start the Keycloak application:

    ```
    docker compose up -d
    ```

   This command will start the Keycloak application using the `docker-compose.yml` file.  It will take a few minutes to complete the start up as the images are being downloaded.

5. Access the Keycloak web interface:

   Open a web browser and navigate to `https://<ENV_KC_HOSTNAME>:8443/admin`<br>
   ... where <ENV_KC_HOSTNAME> is the value assigned in the .env file.

    You should see the Keycloak login page.  Edge, Brave, and Chromium browsers have been verified to work.

   Note: The first time you access the web interface, you'll need to accept the self-signed SSL certificate.

6. Log in to the Keycloak web interface:

   Use the default administrator credentials to log in:

   - Username: admin
   - Password: admin

## Testing the installation

To verify the Keycloak instance is functional, follow these steps:

1. Now that you are signed in as an administrator, import the test realm included in this repository.
   - Expand the realm list in the upper left and select the 'Create Realm' button.
   - In the form, browse to the file 'testing/test.realm' and select the 'Create' button.

   A realm named 'test' should now exist in the realm list.

2. Start a session using the included credential file.
   - Create a new session and grab a token from the Keycloak instance by entering the following text at the command prompt.
    ```
    sh testing/keycloak-login.sh testing/keycloak-cred.json
    ```
   - The result should be a json object that is similar to the following json.
    ```
    {"access_token":"YUJ5anFzIn0.eyJleHAiOjE3MzE3MDgxMDksImlY29tIn0.nvDP5HJ-oPZRjSlEBxHyY37qzf39wykU3VapULtcA","expires_in":300,"refresh_expires_in":1800,"refresh_token":"<data>","token_type":"Bearer","not-before-policy":0,"session_state":"27aba1a8-eb77-424b-95d5-96010432e3e0","scope":"profile email"}
    ```
If these two steps were successful, the Keycloak instance is functioning.  Visit the [Securing Apps](https://www.keycloak.org/securing-apps/overview) resource to get detailed instructions on configuring the Keycloak to secure you particular application or service.
