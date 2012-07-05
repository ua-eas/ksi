#
# component base install script for kc on tomcat-7.0.28
#

#
# Since we do a single home install, and multiple base installs, we have to do a little tap-dancing.

echo "[-install-] Customizing environment for Tomcat multiple-base install ..."

export COMPONENT_BASE="${COMPONENT_BASE}/kc"
export COMPONENT_LOGS="${COMPONENT_BASE}/logs"
export INSTALLER_COMPONENT_PROFILE_TMPL="${INSTALLER_COMPONENT_VERSIONDIR}/profile_kc.sh.tmpl"
export COMPONENT_PROFILE="${COMPONENT_PROFILE}_kc"
export INSTALLER_COMPONENT_INIT_TMPL="${INSTALLER_COMPONENT_VERSIONDIR}/init_kc.sh.tmpl"
export COMPONENT_INIT="${COMPONENT_INIT}_kc"
export TOMCAT_CATALINA_PID="${COMPONENT_LOGS}/catalina.pid"
export TOMCAT_THIS_INSTANCE="KC"

for x in COMPONENT_BASE \
         COMPONENT_LOGS \
         COMPONENT_PROFILE \
         COMPONENT_INIT \
         TOMCAT_CATALINA_PID \
         TOMCAT_THIS_INSTANCE
do
    [ ${!KSI_VERBOSE[@]} ] && echo "[-install-] + setting ${x} = ${!x}"
done

#
# Copy KC-specific environment variables into generic placeholders for templating.

echo "[-install-] Copying KC-specific environment into generic Tomcat template variables ..."

for x in TOMCAT_INSTANCE_IDENTIFIER \
         TOMCAT_SHUTDOWN_PORT TOMCAT_HTTP_PORT TOMCAT_AJP_PORT \
         TOMCAT_PROXY_NAME TOMCAT_JVM_ROUTE \
         TOMCAT_CLUSTER_MCAST_IPADDR TOMCAT_CLUSTER_MCAST_PORT \
         TOMCAT_CLUSTER_RECV_PORT \
         TOMCAT_CATALINA_OPTS \
         TOMCAT_NEWRELIC_APPNAME
do
    y=`eval echo "${TOMCAT_THIS_INSTANCE}_${x}"`
    [ ${!KSI_VERBOSE[@]} ] && echo "[-install-] + using ${x} = ${!y}"
    export ${x}="${!y}"
done

#
# Make the base directory structure for the KC instance.

echo "[-install-] Creating base directory structure for kc tomcat instance  ..."

mkdir -p ${COMPONENT_BASE}

thisdir=`pwd`
cd ${COMPONENT_HOME}/__base__
tar csplSf - . | ( cd ${COMPONENT_BASE} && tar xplSf - )
cd ${thisdir}

#
# copy newrelic.jar and newrelic.yml into place, and adjust CATALINA_OPTS placeholder

echo "[-install-] Adding New Relic application monitoring agent wiring ..."

mkdir -p ${COMPONENT_BASE}/newrelic
cp -p ${INSTALLER_SERVICE_COMPONENT_TMPLDIR}/newrelic.jar ${COMPONENT_BASE}/newrelic/newrelic.jar
process_template ${INSTALLER_SERVICE_COMPONENT_TMPLDIR}/newrelic.yml.tmpl > ${COMPONENT_BASE}/newrelic/newrelic.yml
export TOMCAT_CATALINA_OPTS="-D${TOMCAT_INSTANCE_IDENTIFIER} ${TOMCAT_CATALINA_OPTS} -Dnewrelic.environment=${SERVICE_ENVIRONMENT} -javaagent:${COMPONENT_BASE}/newrelic/newrelic.jar"

#
# Create setenv.sh in base bin to set CATALINA_OPTS, CATALINA_PID.

echo "[-install-] Creating environment settings file for kc tomcat instance ..."

process_template ${INSTALLER_SERVICE_COMPONENT_TMPLDIR}/setenv.sh.tmpl > ${COMPONENT_BASE}/bin/setenv.sh

#
# Process template configuration files into the correct location.

echo "[-install-] Creating configuration files for this instance ..."

for x in catalina.policy catalina.properties \
         context.xml logging.properties \
         server.xml web.xml
do
    process_template ${INSTALLER_SERVICE_COMPONENT_TMPLDIR}/${x}.tmpl > ${COMPONENT_BASE}/conf/${x}
done

#
# install component profile script into place

echo "[-install-] Installing profile for this instance ..."

process_template ${INSTALLER_COMPONENT_PROFILE_TMPL} > ${COMPONENT_PROFILE}

#
# install component init script into place

echo "[-install-] Installing init script for this instance ..."

process_template ${INSTALLER_COMPONENT_INIT_TMPL} > ${COMPONENT_INIT}

