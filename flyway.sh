#!/bin/sh -x

DB_HOST=${DB_HOST:-"localhost"}
DB_PORT=${DB_PORT:-"3306"}
DB_DATABASE=${DB_DATABASE:-"mysql"}
DB_PASSWORD=${DB_PASSWORD:-"1234"}
DB_DRIVER=${DB_DRIVER:-"mysql"}

/opt/flyway/wait-for.sh ${DB_HOST}:${DB_PORT} --timeout=30

JAVA_CMD="$JAVA_HOME/bin/java"
JAVA_ARGS="-Djava.security.egd=file:/dev/../dev/urandom"
INSTALL_DIR=$(dirname $0)

FLYWAY_ARGS=""
[[ -n "$DB_USER" ]] && FLYWAY_ARGS="${FLYWAY_ARGS} -user=${DB_USER}"
[[ -n "$DB_PASSWORD" ]] && FLYWAY_ARGS="${FLYWAY_ARGS} -password=${DB_PASSWORD}"
FLYWAY_ARGS="${FLYWAY_ARGS} -url=jdbc:${DB_DRIVER}://${DB_HOST}:${DB_PORT}/${DB_DATABASE}"

"$JAVA_CMD" "$JAVA_ARGS" -cp "${INSTALL_DIR}/drivers/*:${INSTALL_DIR}/lib/*" org.flywaydb.commandline.Main ${FLYWAY_ARGS} -locations=filesystem:/sql -schemas=${DB_DATABASE} "$@"
