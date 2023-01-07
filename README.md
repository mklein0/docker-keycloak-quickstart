# docker-keycloak-quickstart

Docker build for Keycloak quickstart repository.

The keycloak-quickstart repository has been difficult for me to setup and experiment with.
So I created this example of setting up the enviroment under docker to experiment with.

I have found the wildfly auth plugin to not work well with recent versions of wildfly and the
plugin, so an older version of keycloak is being used.


## Setup

1. Install docker
2. Install docker-compose:
    ```shell
    pip install virtualenv
    virtualenv keycloak-quickstart
    source keycloak-quickstart/bin/activate
    pip install docker-compose
    ```
3. Build local docker image:
    ```shell
    docker-compose build
    ```
4. Start up docker services:
    ```shell
    docker-compose up
    ```
5. Connect to quickstart container as root:
    ```shell
    docker-compose exec -u root -- quickstart bash
    ```
6. Change to the quickstart service interested in and build/start it up:
    ```shell
    cd $HOME/keycloak-quickstarts/app-authz-photoz
    deploy
    ```

## Reference

wildfly <= 23
https://www.wildfly.org/downloads/

https://www.keycloak.org/downloads




 docker run --name keycloak -p 8180:8180 \
     -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin \
     quay.io/keycloak/keycloak:latest \
     start-dev \
     --http-port 8180 \
     --http-relative-path /auth



https://github.com/keycloak/keycloak-quickstarts/blob/latest/docs/getting-started.md





https://github.com/keycloak/keycloak-quickstarts/blob/15.0.2/docs/getting-started.md#keycloak
https://github.com/keycloak/keycloak-quickstarts/tree/15.0.2/app-authz-photoz
