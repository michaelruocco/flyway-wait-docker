FROM java:openjdk-8-jre-alpine

ENV FLYWAY_VERSION 4.0
ENV FLYWAY_SQL_DIR /sql

RUN mkdir /opt \
  && apk add curl mysql-client --update \
  && curl -k https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz | tar -xzf- -C /opt \
  && mv /opt/flyway-${FLYWAY_VERSION} /opt/flyway \
  && sed -i 's/bash/sh/' /opt/flyway/flyway \
  && echo "flyway.locations=filesystem:${FLYWAY_SQL_DIR}" > /opt/flyway/conf/flyway.conf \
  && echo "flyway.encoding=UTF-8" >> /opt/flyway/conf/flyway.conf \
  && rm -rf /var/cache/apk/*

COPY wait-for.sh /opt/flyway/
COPY flyway.sh /opt/flyway/flyway

# Default location for sql migrations
VOLUME /sql

ENTRYPOINT ["/opt/flyway/flyway"]

CMD ["info"]
