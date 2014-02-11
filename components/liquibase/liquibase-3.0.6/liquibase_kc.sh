#!/bin/sh

LIQUIBASE_LIB_DIR=$LIQUIBASE_HOME/lib/
LIQUIBASE_HOME=$LIQUIBASE_HOME/bin/
KC_ENV=$(cat /home/kualiadm/kitt-tools/.envrc)

# grep the username, password, and url from the kc-security.xml file. This is the same
# file that the KC application uses to connect to the DB so it should always be up to
# date for the current environment.
LIQUIBASE_DB_USERNAME=$(grep -e '<param name="datasource.username">' ~/kuali/main/$KC_ENV/kc-security.xml  | sed -e 's/^[ \t]*<param name="datasource.username">//' -e 's/<\/param>.*$//')
LIQUIBASE_DB_PASSWORD=$(grep -e '<param name="datasource.password">' ~/kuali/main/$KC_ENV/kc-security.xml  | sed -e 's/^[ \t]*<param name="datasource.password">//' -e 's/<\/param>.*$//')
LIQUIBASE_DB_URL=$(grep -e '<param name="datasource.url">' ~/kuali/main/$KC_ENV/kc-security.xml  | sed -e 's/^[ \t]*<param name="datasource.url">//' -e 's/<\/param>.*$//')

exec $LIQUIBASE_HOME/liquibase \
--url=$LIQUIBASE_DB_URL \
--username=$LIQUIBASE_DB_USERNAME \
--password=$LIQUIBASE_DB_PASSWORD \
--classpath=$LIQUIBASE_LIB_DIR/ojdbc6.jar \
--driver=oracle.jdbc.driver.OracleDriver \
--logLevel=debug \
$@
