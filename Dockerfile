FROM quay.io/keycloak/keycloak:26.0.7 as builder

ARG db_vendor
ARG hostname

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=$db_vendor

# Add a tool a check endpoints as curl is not available any more
COPY ConnectionTest.java /opt/keycloak/

WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
#RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=${hostname}" -alias server -ext "SAN:c=DNS:${hostname},IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.0.7

ARG db_user
ARG db_pass
ARG db_url
ARG db_vendor
ARG hostname

COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Configure a database vendor
ENV KC_DB=$db_vendor

# change these values to point to a running mariadb instance
ENV KC_DB_URL=$db_url
ENV KC_DB_USERNAME=$db_user
ENV KC_DB_PASSWORD=$db_pass

# change these values to set the Keycloak server
ENV KC_HOSTNAME=https://${hostname}:8443
ENV KC_HOSTNAME_ADMIN=https://${hostname}:8443

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
