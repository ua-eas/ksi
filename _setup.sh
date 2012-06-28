#-----------------------------------------------------------------------#
# _setup.sh
#-----------------------------------------------------------------------#
#
# This script is sourced from "ksi.sh" in order to set up convenience
# environment variables pointing to every possible location-of-interest
# for a particular service stack.
#
# In general, there should be absolutely no hardcoded paths in any
# of the KSI action scripts -- this file should be the single common
# point from which all paths are set.
#
# Note that to compose all of the various paths, this script relies
# upon the presence of twelve environment variables in the sourcing
# process; it will complain if those variables are not visible, and
# the paths that get set won't be much use.
#
# Mike Simpson
# Kuali Applications Technical Team
# June 2012
#
#-----------------------------------------------------------------------#

#
# Verify visibility of the required environment settings, and complain
# if any are missing.

echo "[-setup-] Checking for required environment variables ..."

# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------
# CONVENTIONAL PLACEHOLDER                SPECIFIC EXAMPLE                        IN CONVERSATION                                       ENVIRONMENT VARIABLE
# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------
#
# <service name>           [ <service> ]  kuali                                   "the service name"                                    ${SERVICE_NAME}
# <service environment>[ <environment> ]  dev                                     "the service environment"                             ${SERVICE_ENVIRONMENT}
# <service user>              [ <user> ]  kualiadm                                "the service user"                                    ${SERVICE_USER}
# <service group>            [ <group> ]  kuali                                   "the service group"                                   ${SERVICE_GROUP}
# 
# <component name>       [ <component> ]  jdk                                     "the component name"                                  ${COMPONENT_NAME}
# <component version>      [ <version> ]  1.6.0_33                                "the component version"                               ${COMPONENT_VERSION}
# <component index>          [ <index> ]  1                                       "the component index"                                 ${COMPONENT_INDEX}
# <component action>        [ <action> ]  install                                 "the component action"                                ${COMPONENT_ACTION}
#
# <installer repository  [ <installer> ]  (a clone/checkout of the KSI project)   "the installer repository"                            ${INSTALLER_REPOSITORY}
# <installer home root        [ <home> ]  /opt                                    "the root path of the home directory structure"       ${INSTALLER_HOME_ROOT}
# <installer config root    [ <config> ]  /etc/opt                                "the root path of the config directory structure"     ${INSTALLER_CONFIG_ROOT|
# <installer base root        [ <base> ]  /var/opt                                "the root path of the base directory structure"       ${INSTALLER_BASE_ROOT}
#
# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------

for x in SERVICE_NAME SERVICE_ENVIRONMENT SERVICE_USER SERVICE_GROUP \
         COMPONENT_NAME COMPONENT_VERSION COMPONENT_INDEX COMPONENT_ACTION \
         INSTALLER_REPOSITORY INSTALLER_HOME_ROOT INSTALLER_CONFIG_ROOT INSTALLER_BASE_ROOT
do
    if [ "X" == "X${!x}" ]; then
        echo >&2 "[*setup*] + missing environment variable ${x}"
    else
        echo "[-setup-] + using ${x} = ${!x}"
    fi
done

#if [ "X" == "X${SERVICE_NAME}" ]; then
#    echo >&2 "[*setup*] + missing environment variable \${SERVICE_NAME}"
#else
#    echo "[-setup-] + using SERVICE_NAME = ${SERVICE_NAME}"
#fi
#
#if [ "X" == "X${SERVICE_ENVIRONMENT}" ]; then
#    echo >&2 "[*setup*] + missing environment variable \${SERVICE_ENVIRONMENT}"
#else
#    echo "[-setup-] + using SERVICE_ENVIRONMENT = ${SERVICE_ENVIRONMENT}"
#fi
#
#if [ "X" == "X${SERVICE_USER}" ]; then
#    echo >&2 "[*setup*] + missing environment variable \${SERVICE_USER}"
#else
#    echo "[-setup-] + using SERVICE_USER = ${SERVICE_USER}"
#fi
#
#if [ "X" == "X${SERVICE_GROUP}" ]; then
#    echo >&2 "[*setup*] + missing environment variable \${SERVICE_GROUP}"
#else
#    echo "[-setup-] + using SERVICE_GROUP = ${SERVICE_GROUP}"
#fi
#
#if [ "X" == "X${COMPONENT_NAME}" ]; then
#    echo >&2 "[*setup*] + missing environment variable \${COMPONENT_NAME}"
#else
#    echo "[-setup-] + using COMPONENT_NAME = ${COMPONENT_NAME}"
#fi
#
#if [ "X" == "X${COMPONENT_VERSION}" ]; then
#    echo >&2 "[*setup*] + missing environment variable \${COMPONENT_VERSION}"
#else
#    echo "[-setup-] + using COMPONENT_VERSION = ${COMPONENT_VERSION}"
#fi
#
#if [ "X" == "X${COMPONENT_INDEX}" ]; then
#    echo >&2 "[*setup*] + missing environment variable \${COMPONENT_INDEX}"
#else
#    echo "[-setup-] + using COMPONENT_INDEX = ${COMPONENT_INDEX}"
#fi
#
#if [ "X" == "X${COMPONENT_ACTION}" ]; then
#    echo >&2 "[*setup*] + missing environment variable \${COMPONENT_ACTION}"
#else
#    echo "[-setup-] + using COMPONENT_ACTION = ${COMPONENT_ACTION}"
#fi
#
#if [ "X" == "X${INSTALLER_REPOSITORY}" ]; then
#    echo >&2 "[*setup*] + missing environment variable \${INSTALLER_REPOSITORY}"
#else
#    echo "[-setup-] + using INSTALLER_REPOSITORY = ${INSTALLER_REPOSITORY}"
#fi
#
#if [ "X" == "X${INSTALLER_HOME_ROOT}" ]; then
#    echo >&2 "[*setup*] + missing environment variable \${INSTALLER_HOME_ROOT}"
#else
#    echo "[-setup-] + using INSTALLER_HOME_ROOT = ${INSTALLER_HOME_ROOT}"
#fi
#
#if [ "X" == "X${INSTALLER_CONFIG_ROOT}" ]; then
#    echo >&2 "[*setup*] + missing environment variable \${INSTALLER_CONFIG_ROOT}"
#else
#    echo "[-setup-] + using INSTALLER_CONFIG_ROOT = ${INSTALLER_CONFIG_ROOT}"
#fi
#
#if [ "X" == "X${INSTALLER_BASE_ROOT}" ]; then
#    echo >&2 "[*setup*] + missing environment variable \${INSTALLER_BASE_ROOT}"
#else
#    echo "[-setup-] + using INSTALLER_BASE_ROOT = ${INSTALLER_BASE_ROOT}"
#fi

#
# Calculate paths and build out the "installer" directory structure; the assumption
# is that we're being run from the base of a cloned KSI Git repository, or at
# least the checked-out files from it.  We also add a couple of extra variables
# that are used in the templating utility function to do replacements during
# installation.

echo "[-setup-] Setting up service installer paths ..."

# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------
# CONVENTIONAL PLACEHOLDER                SPECIFIC EXAMPLE                        IN CONVERSATION                                       ENVIRONMENT VARIABLE
# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------
#
# <service prefix>                        KUALI                                   "the service prefix"                                  ${SERVICE_PREFIX}
# <component prefix>                      JDK                                     "the component prefix"                                ${COMPONENT_PREFIX}
#
# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------
# CONVENTIONAL PATH                       SPECIFIC EXAMPLE                        IN CONVERSATION                                       ENVIRONMENT VARIABLE
# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------
#
# <installer>                             ~kualiadm/ksi                           "the installer working directory"                     ${INSTALLER_WORKDIR}
#
#   /components                             /components                           "the installer components directory"                  ${INSTALLER_COMPONENTS}
#
#     init.sh.tmpl                            init.sh.tmpl                        "the installer master init script template"           ${INSTALLER_MASTER_INIT_TMPL}
#     profile.sh.tmpl                         profile.sh.tmpl                     "the installer master profile template"               ${INSTALLER_MASTER_PROFILE_TMPL}
#
#     /<component>                            /jdk                                "an installer component directory"                    ${INSTALLER_COMPONENTDIR}
#       /<component>-<version>                  /jdk-1.6.0_33                     "an installer component version directory"            ${INSTALLER_COMPONENT_VERSIONDIR}
#         init.sh.tmpl                            init.sh.tmpl                    "an installer component init script template"         ${INSTALLER_COMPONENT_INIT_TMPL}
#         profile.sh.tmpl                         profile.sh.tmpl                 "an installer component profile template"             ${INSTALLER_COMPONENT_PROFILE_TMPL}
#         _<action>.sh                            _install.sh                     "an installer component action script"                ${INSTALLER_COMPONENT_ACTION}
#
#   /services                               /services                             "the installer services directory"                    ${INSTALLER_SERVICES}
#
#     /<service>                              /kuali                              "an installer service directory"                      ${INSTALLER_SERVICEDIR}
#
#       /properties                             /properties                       "an installer service properties directory"           ${INSTALLER_SERVICE_PROPDIR}
#         <service>-<environment>.env             kuali-dev.env                   "an installer service environment properties file"    ${INSTALLER_SERVICE_ENVIRONMENT_PROPERTIES}
#
#       /templates                              /templates                        "an installer service templates directory"            ${INSTALLER_SERVICE_TMPLDIR}
#         /<component>                            /jdk                            "an installer service component templates directory"  ${INSTALLER_SERVICE_COMPONENT_TMPLDIR}
#
# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------

SERVICE_PREFIX=`echo ${SERVICE_NAME} | tr '[:lower:]' '[:upper:]'`
COMPONENT_PREFIX=`echo ${COMPONENT_NAME} | tr '[:lower:]' '[:upper:]'`
for x in SERVICE_PREFIX COMPONENT_PREFIX
do
    echo "[-setup-] + using ${x} = ${!x}"
    export ${x}
done

INSTALLER_WORKDIR="${INSTALLER_REPOSITORY}"
for x in INSTALLER_WORKDIR
do
    echo "[-setup-] + using ${x} = ${!x}"
    export ${x}
done

INSTALLER_COMPONENTS="${INSTALLER_WORKDIR}/components"
INSTALLER_MASTER_INIT_TMPL="${INSTALLER_COMPONENTS}/init.sh.tmpl"
INSTALLER_MASTER_PROFILE_TMPL="${INSTALLER_COMPONENTS}/profile.sh.tmpl"
INSTALLER_COMPONENTDIR="${INSTALLER_COMPONENTS}/${COMPONENT_NAME}"
INSTALLER_COMPONENT_VERSIONDIR="${INSTALLER_COMPONENTDIR}/${COMPONENT_NAME}-${COMPONENT_VERSION}"
INSTALLER_COMPONENT_INIT_TMPL="${INSTALLER_COMPONENT_VERSIONDIR}/init.sh.tmpl"
INSTALLER_COMPONENT_PROFILE_TMPL="${INSTALLER_COMPONENT_VERSIONDIR}/profile.sh.tmpl"
INSTALLER_COMPONENT_ACTION="${INSTALLER_COMPONENT_VERSIONDIR}/_${COMPONENT_ACTION}.sh"
for x in INSTALLER_COMPONENTS INSTALLER_MASTER_INIT_TMPL INSTALLER_MASTER_PROFILE_TMPL \
         INSTALLER_COMPONENTDIR INSTALLER_COMPONENT_VERSIONDIR INSTALLER_COMPONENT_INIT_TMPL \
         INSTALLER_COMPONENT_PROFILE_TMPL INSTALLER_COMPONENT_ACTION
do
    echo "[-setup-] + using ${x} = ${!x}"
    export ${x}
done

INSTALLER_SERVICES="${INSTALLER_WORKDIR}/services"
INSTALLER_SERVICEDIR="${INSTALLER_SERVICES}/${SERVICE_NAME}"
INSTALLER_SERVICE_PROPDIR="${INSTALLER_SERVICEDIR}/properties"
INSTALLER_SERVICE_ENVIRONMENT_PROPERTIES="${INSTALLER_SERVICE_PROPDIR}/${SERVICE_NAME}-${SERVICE_ENVIRONMENT}.env"
INSTALLER_SERVICE_TMPLDIR="${INSTALLER_SERVICEDIR}/templates"
INSTALLER_SERVICE_COMPONENT_TMPLDIR="${INSTALLER_SERVICE_TMPLDIR}/${COMPONENT_NAME}"
for x in INSTALLER_SERVICES INSTALLER_SERVICEDIR \
         INSTALLER_SERVICE_PROPDIR INSTALLER_SERVICE_ENVIRONMENT_PROPERTIES \
         INSTALLER_SERVICE_TMPLDIR INSTALLER_SERVICE_COMPONENT_TMPLDIR
do
    echo "[-setup-] + using ${x} = ${!x}"
    export ${x}
done

#
# Set the root paths for the home, configuration, and base directory structures;
# if these are visible in the invoking environment, override the defaults set here.

if [ "X" == "X${INSTALLER_REPOSITORY}" ]; then
    echo >&2 "[*setup*] + missing environment variable \${INSTALLER_REPOSITORY}"
else
    echo "[-setup-] + using INSTALLER_REPOSITORY = ${INSTALLER_REPOSITORY}"
fi

KSI_HOME_ROOT=/opt
KSI_CONFIG_ROOT=/etc/opt
KSI_BASE_ROOT=/var/opt

#
# Calculate paths and build out the "service home" directory structure: this usually
# lives under the "/opt" hierarchy, and should only contain component files that don't
# change significantly after installation, e.g. binaries, libraries, etc.  The idea here
# is that after you have everything installed, you could choose to mount the service home
# as a read-only filesystem, and nothing would break.  For ease of reference, this is also
# where we keep our build files and logs created during component installation.

echo "[-setup-] Setting up service home paths ..."

# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------
# CONVENTIONAL PATH                       SPECIFIC EXAMPLE                        IN CONVERSATION                                       ENVIRONMENT VARIABLE
# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------
#
# /<home>/<service>                         /opt/kuali                            "the service home"                                    ${SERVICE_HOME}
# 
#   /__build__                                /__build__                          "the service build directory"                         ${SERVICE_BUILDDIR}
#
#     /logs                                     /logs                             "the service build logs directory"                    ${SERVICE_BUILDLOGSDIR}
#       /<component>                              /jdk                            "a component build logs directory"                    ${COMPONENT_BUILDLOGSDIR}
#         /<action>.<component>-<version>.log       install.jdk-1.6.0_33.log      "a component version build log"                       ${COMPONENT_VERSION_BUILDLOG}
#
#     /source                                   /source                           "the service build source directory"                  ${SERVICE_BUILDSRCDIR}
#       /<component>                              /jdk                            "a component build source directory"                  ${COMPONENT_BUILDSRCDIR}
#         /<component>-<version>                    /jdk-1.6.0_33                 "a component version build directory"                 ${COMPONENT_VERSION_BUILDDIR}
#
#   /<component>                              /jdk                                "a component installation directory"                  ${COMPONENT_INSTALLDIR}
#     /<component>-<version>                    /jdk-1.6.0_33                     "a component version installation directory"          ${COMPONENT_VERSION_INSTALLDIR}
#                                                                                     [ a.k.a. "a component home" ]                     ${COMPONENT_HOME}
#
# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------

SERVICE_HOME="${INSTALLER_HOME_ROOT}/${SERVICE_NAME}"
SERVICE_BUILDDIR="${SERVICE_HOME}/__build__"
SERVICE_BUILDLOGSDIR="${SERVICE_BUILDDIR}/logs"
COMPONENT_BUILDLOGSDIR="${SERVICE_BUILDLOGSDIR}/${COMPONENT_NAME}"
COMPONENT_VERSION_BUILDLOG="${COMPONENT_BUILDLOGSDIR}/${COMPONENT_ACTION}.${COMPONENT_NAME}-${COMPONENT_VERSION}.log"
SERVICE_BUILDSRCDIR="${SERVICE_BUILDDIR}/source"
COMPONENT_BUILDSRCDIR="${SERVICE_BUILDSRCDIR}/${COMPONENT_NAME}"
COMPONENT_VERSION_BUILDDIR="${COMPONENT_BUILDSRCDIR}/${COMPONENT_NAME}-${COMPONENT_VERSION}"
COMPONENT_INSTALLDIR="${SERVICE_HOME}/${COMPONENT_NAME}"
COMPONENT_VERSION_INSTALLDIR="${COMPONENT_INSTALLDIR}/${COMPONENT_NAME}-${COMPONENT_VERSION}"
COMPONENT_HOME="${COMPONENT_VERSION_INSTALLDIR}"
for x in SERVICE_HOME SERVICE_BUILDDIR \
         SERVICE_BUILDLOGSDIR COMPONENT_BUILDLOGSDIR COMPONENT_VERSION_BUILDLOG \
         SERVICE_BUILDSRCDIR COMPONENT_BUILDSRCDIR COMPONENT_VERSION_BUILDDIR \
         COMPONENT_INSTALLDIR COMPONENT_VERSION_INSTALLDIR COMPONENT_HOME
do
    echo "[-setup-] + using ${x} = ${!x}"
    export ${x}
done

#
# Calculate paths and build out the "service configuration" directory structure: this
# usually lives under the "/etc/opt" hierarchy, and should contain component configuration
# files and related information.

echo "[-setup-] Setting up service configuration paths ..."

# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------
# CONVENTIONAL PATH                       SPECIFIC EXAMPLE                        IN CONVERSATION                                       ENVIRONMENT VARIABLE
# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------
#
# /<config>/<service>                     /etc/opt/kuali                          "the service configuration"                           ${SERVICE_CONFIG}
#
#   <service>ctl                            kualictl                              "the service control script"                          ${SERVICE_CONTROL_SCRIPT}
#
#   /__control__                            /__control__                          "the service control directory"                       ${SERVICE_CONTROLDIR}
#     init.sh                                 init.sh                             "the service master init file"                        ${SERVICE_MASTER_INIT}
#     /init.d                                 /init.d                             "the service init directory"                          ${SERVICE_INITDIR}
#       <index><component>                      1jdk                              "a component init file"                               ${COMPONENT_INIT}
#     profile.sh                              profile.sh                          "the service master profile file"                     ${SERVICE_MASTER_PROFILE}
#     /profile.d                              /profile.d                          "the service profile directory"                       ${SERVICE_PROFILEDIR}
#       <index><component>                      1jdk                              "a component profile file"                            ${COMPONENT_PROFILE}
#
#   /<component>                              /jdk                                "a component configuration directory"                 ${COMPONENT_CONFIGDIR}
#     /<component>-<version>                    /jdk-1.6.0_33                     "a component version configuration"                   ${COMPONENT_VERSION_CONFIGDIR}
#                                                                                     [ a.k.a. "a component config" ]                   ${COMPONENT_CONFIG}
#
# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------

SERVICE_CONFIG="${INSTALLER_CONFIG_ROOT}/${SERVICE_NAME}"
SERVICE_CONTROL_SCRIPT="${SERVICE_CONFIG}/${SERVICE_NAME}ctl"
SERVICE_CONTROLDIR="${SERVICE_CONFIG}/__control__"
SERVICE_MASTER_INIT="${SERVICE_CONTROLDIR}/init.sh"
SERVICE_INITDIR="${SERVICE_CONTROLDIR}/init.d"
COMPONENT_INIT="${SERVICE_INITDIR}/${COMPONENT_INDEX}${COMPONENT_NAME}"
SERVICE_MASTER_PROFILE="${SERVICE_CONTROLDIR}/profile.sh"
SERVICE_PROFILEDIR="${SERVICE_CONTROLDIR}/profile.d"
COMPONENT_PROFILE="${SERVICE_PROFILEDIR}/${COMPONENT_INDEX}${COMPONENT_NAME}"
COMPONENT_CONFIGDIR="${SERVICE_CONFIG}/${COMPONENT_NAME}"
COMPONENT_VERSION_CONFIGDIR="${COMPONENT_CONFIGDIR}/${COMPONENT_NAME}-${COMPONENT_VERSION}"
COMPONENT_CONFIG="${COMPONENT_VERSION_CONFIGDIR}"
for x in SERVICE_CONFIG SERVICE_CONTROL_SCRIPT SERVICE_CONTROLDIR \
         SERVICE_MASTER_INIT SERVICE_INITDIR COMPONENT_INIT \
         SERVICE_MASTER_PROFILE SERVICE_PROFILEDIR COMPONENT_PROFILE \
         COMPONENT_CONFIGDIR COMPONENT_VERSION_CONFIGDIR COMPONENT_CONFIG
do
    echo "[-setup-] + using ${x} = ${!x}"
    export ${x}
done
    
#
# Calculate paths and build out the "service base" directory structure: this
# usually lives under the "/var/opt" hierarchy, and should contain component files
# that change repeatedly after installation, e.g. content, logs, 
# files and related information.  One of the major differences between this
# directory structure and the other two is the lack of versioning; we assume
# that as we upgrade to new versions, we will be retaining most or all of the
# content under the service base.

echo "[-setup-] Setting up service base paths ..."

# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------
# CONVENTIONAL PATH                       SPECIFIC EXAMPLE                        IN CONVERSATION                                       ENVIRONMENT VARIABLE
# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------
#
# /<base>/<service>                       /var/opt/kuali                          "the service base"                                    ${SERVICE_BASE}
#
#   /<component>                            /jdk                                  "a component base directory"                          ${COMPONENT_BASE}
#
#     /logs                                   /logs                               "a component logs directory"                          ${COMPONENT_LOGS}
#
# --------------------------------------  --------------------------------------  ----------------------------------------------------  --------------------------------------------

SERVICE_BASE="${INSTALLER_BASE_ROOT}/${SERVICE_NAME}"
COMPONENT_BASE="${SERVICE_BASE}/${COMPONENT_NAME}"
COMPONENT_LOGS="${COMPONENT_BASE}/logs"
for x in SERVICE_BASE COMPONENT_BASE COMPONENT_LOGS
do
    echo "[-setup-] + using ${x} = ${!x}"
    export ${x}
done

