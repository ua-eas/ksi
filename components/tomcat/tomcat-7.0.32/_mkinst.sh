#
# component make instance script for kc on tomcat-7.0.32
#

#
# Instance tag should come in as single argument to script.

instance=$1
instance_prefix=`echo ${instance} | tr '[:lower:]' '[:upper:]'`

echo "[-mkinst-] Making new Tomcat instance \"${instance}\" ..."

#
# Since we do a single home install, and multiple base installs, we have to do a little tap-dancing.

echo "[-mkinst-] Customizing environment for specified instance ..."

export COMPONENT_BASE="${COMPONENT_BASE}/${instance}"
export COMPONENT_LOGS="${COMPONENT_BASE}/logs"
export INSTALLER_COMPONENT_PROFILE_TMPL="${INSTALLER_COMPONENT_VERSIONDIR}/profile_inst.sh.tmpl"
export COMPONENT_PROFILE="${COMPONENT_PROFILE}_${instance}"
export INSTALLER_COMPONENT_INIT_TMPL="${INSTALLER_COMPONENT_VERSIONDIR}/init_inst.sh.tmpl"
export COMPONENT_INIT="${COMPONENT_INIT}_${instance}"
export TOMCAT_CATALINA_PID="${COMPONENT_LOGS}/catalina.pid"
export TOMCAT_THIS_INSTANCE="${instance}"
export TOMCAT_THIS_INSTANCE_PREFIX="${instance_prefix}"

for x in COMPONENT_BASE \
         COMPONENT_LOGS \
         COMPONENT_PROFILE \
         COMPONENT_INIT \
         TOMCAT_CATALINA_PID \
         TOMCAT_THIS_INSTANCE \
         TOMCAT_THIS_INSTANCE_PREFIX
do
    [ ${!KSI_VERBOSE[@]} ] && echo "[-mkinst-] + setting ${x} = ${!x}"
done

#
# Copy instance-specific environment variables into generic placeholders for templating.

echo "[-mkinst-] Copying instance-specific environment into generic Tomcat template variables ..."

for x in TOMCAT_INSTANCE_IDENTIFIER \
         TOMCAT_SHUTDOWN_PORT TOMCAT_HTTP_PORT TOMCAT_AJP_PORT \
         TOMCAT_PROXY_NAME TOMCAT_JVM_ROUTE \
         TOMCAT_CATALINA_OPTS \
         TOMCAT_NEWRELIC_APPNAME
do
    y=`eval echo "${TOMCAT_THIS_INSTANCE_PREFIX}_${x}"`
    [ ${!KSI_VERBOSE[@]} ] && echo "[-mkinst-] + using ${x} = ${!y}"
    export ${x}="${!y}"
done

#
# Make the base directory structure for the KC instance.

echo "[-mkinst-] Creating base directory structure for new Tomcat instance  ..."

mkdir -p ${COMPONENT_BASE}
for x in bin conf lib logs temp webapps work
do
    mkdir ${COMPONENT_BASE}/${x}
done
cp ${COMPONENT_HOME}/bin/tomcat-juli.jar ${COMPONENT_BASE}/bin

#
# copy newrelic.jar and newrelic.yml into place, and adjust CATALINA_OPTS placeholder

echo "[-mkinst-] Adding New Relic application monitoring agent wiring ..."

mkdir -p ${COMPONENT_BASE}/newrelic
cp -p ${INSTALLER_SERVICE_COMPONENT_TMPLDIR}/newrelic.jar ${COMPONENT_BASE}/newrelic/newrelic.jar
process_template ${INSTALLER_SERVICE_COMPONENT_TMPLDIR}/newrelic.yml.tmpl > ${COMPONENT_BASE}/newrelic/newrelic.yml
export TOMCAT_CATALINA_OPTS="-D${TOMCAT_INSTANCE_IDENTIFIER} ${TOMCAT_CATALINA_OPTS} -Dnewrelic.environment=${SERVICE_ENVIRONMENT} -javaagent:${COMPONENT_BASE}/newrelic/newrelic.jar"

#
# Create setenv.sh in base bin to set CATALINA_OPTS, CATALINA_PID.

echo "[-mkinst-] Creating environment settings file for this instance ..."

process_template ${INSTALLER_SERVICE_COMPONENT_TMPLDIR}/setenv.sh.tmpl > ${COMPONENT_BASE}/bin/setenv.sh

#
# Process template configuration files into the correct location.

echo "[-mkinst-] Creating configuration files for this instance ..."

for x in catalina.policy catalina.properties \
         context.xml logging.properties \
         server.xml tomcat-users.xml web.xml
do
    process_template ${INSTALLER_SERVICE_COMPONENT_TMPLDIR}/${x}.tmpl > ${COMPONENT_BASE}/conf/${x}
done
mkdir -p ${COMPONENT_BASE}/conf/Catalina/localhost
process_template ${INSTALLER_SERVICE_COMPONENT_TMPLDIR}/context-manager.xml.tmpl > ${COMPONENT_BASE}/conf/Catalina/localhost/manager.xml

echo "[-mkinst-] ***note*** Don't forget to fix username and password values in tomcat-users.xml ..."

#
# install component profile script into place

echo "[-mkinst-] Installing profile for this instance ..."

process_template ${INSTALLER_COMPONENT_PROFILE_TMPL} > ${COMPONENT_PROFILE}

#
# install component init script into place

echo "[-mkinst-] Installing init script for this instance ..."

process_template ${INSTALLER_COMPONENT_INIT_TMPL} > ${COMPONENT_INIT}

