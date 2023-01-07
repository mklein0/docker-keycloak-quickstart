FROM eclipse-temurin:8u352-b08-jdk

RUN \
  set -ex \
  && groupadd -r jboss -g 1000 \
  && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss \
  && chmod 755 /opt/jboss

WORKDIR /opt/jboss

ENV \
  WILDFLY_VERSION=23.0.0.Final \
  WILDFLY_SHA1=b06fab856140226dc499855f324c3e134517455f \
  JBOSS_HOME=/opt/jboss/wildfly \
  LAUNCH_JBOSS_IN_BACKGROUND=true

RUN \
  set -ex \
  && cd $HOME \
  && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
  && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
  && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
  && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
  && rm wildfly-$WILDFLY_VERSION.tar.gz \
  && chown -R jboss:0 ${JBOSS_HOME} \
  && chmod -R g+rw ${JBOSS_HOME}

ENV \
  MAVEN_VERSION=3.3.9 \
  MAVEN_HOME=/usr/share/maven

RUN \
  set -ex \
  && curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

RUN \
  echo 'alias deploy="mvn clean wildfly:deploy -DskipTests=true -Denforcer.skip=true"' >> $HOME/.bashrc

RUN \
  set -ex \
  && apt update \
  && apt install -y --no-install-recommends git

ENV \
  KEYCLOAK_VERSION=15.0.2 \
  REPO_NAME=keycloak-quickstarts

RUN \
  set -ex \
  && cd $HOME \
  && mkdir -p /opt/jboss/.m2 \
  && git clone https://github.com/keycloak/$REPO_NAME.git \
  && cd $HOME/$REPO_NAME \
  && git checkout $KEYCLOAK_VERSION

RUN \
  set -ex \
  && curl -fsSL https://github.com/keycloak/keycloak/releases/download/$KEYCLOAK_VERSION/keycloak-oidc-wildfly-adapter-$KEYCLOAK_VERSION.tar.gz | tar xzf - -C /opt/jboss/wildfly \
  && chown -R jboss:0 ${JBOSS_HOME} \
  && bash $JBOSS_HOME/bin/jboss-cli.sh --file=$JBOSS_HOME/bin/adapter-install-offline.cli
RUN \
  set -ex \
  && curl -fsSL https://github.com/keycloak/keycloak/releases/download/$KEYCLOAK_VERSION/keycloak-saml-wildfly-adapter-$KEYCLOAK_VERSION.tar.gz | tar xzf - -C /opt/jboss/wildfly \
  && chown -R jboss:0 ${JBOSS_HOME} \
  && bash $JBOSS_HOME/bin/jboss-cli.sh --file=$JBOSS_HOME/bin/adapter-install-saml-offline.cli

USER jboss
EXPOSE 8080
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b=0.0.0.0", "-bmanagement=0.0.0.0"]
