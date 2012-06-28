#-----------------------------------------------------------------------#
# ksi.sh
#-----------------------------------------------------------------------#
#
# The Kuali Service Installer.
#
# Invoked as:
#
#  % ksi.sh -s <service> -e <environment> -c <component> -v <version> -i <index> -a <action>
#
#    e.g.
#
#      % ksi.sh -s kuali -e dev -c jdk -v 1.6.0_33 -i 3 -a install
#
#    or, if you wanted to keep a log:
#
#      % ksi.sh -s kuali -e dev -c jdk -v 1.6.0_33 -i 3 -a install 2>&1 | tee ksi.log
#
# The installer will recommend a standard spot to which to move the
# log file at the end of the run.
#
# The service installer:
#
# * Parses command line arguments and other process information and
#   converts them to appropriate seed environment variables;
#
# * Changes working directory to the root of the KSI repository;
#
# * Sources several helper scripts to set up convenience environment
#   variables, verify paths, define utility functions, etc.;
# 
# * Invokes the appropriate action script for the specified component.
#
# Note that by default, the installer assumes the following root paths:
#
# * Service home directory structure is under /opt;
#
# * Service configuration directory structure is under /etc/opt;
#
# * Service base directory structure is under /var/opt.
#
# The above root paths can be overriden by setting the KSI_HOME,
# KSI_CONFIG, and KSI_BASE environment variables before invocation.
#
# Mike Simpson
# Kuali Applications Technical Team
# Enterprise Applications, UITS, University of Arizona
# July 2012
#
#-----------------------------------------------------------------------#

#
# extract command line arguments, exit with usage message if incorrect

service=
environment=
component=
version=
index=
action=

usage="no"
while getopts s:e:c:v:i:a: opt
do
    case "$opt" in

      s) service="${OPTARG}";;
      e) environment="${OPTARG}";;
      c) component="${OPTARG}";;
      v) version="${OPTARG}";;
      i) index="${OPTARG}";;
      a) action="${OPTARG}";;

     \?) # unknown flag
         usage="yes";;

    esac
done

if [ "X" == "X${service}" ]; then
    usage="yes"
fi

if [ "X" == "X${environment}" ]; then
    usage="yes"
fi

if [ "X" == "X${component}" ]; then
    usage="yes"
fi

if [ "X" == "X${version}" ]; then
    usage="yes"
fi

if [ "X" == "X${index}" ]; then
    usage="yes"
fi

if [ "X" == "X${action}" ]; then
    usage="yes"
fi

if [ ${usage} == "yes" ]; then
    echo >&2 "usage: $0 -s [service] -e [environment] -c [component] -v [version] -i [index] -a [action]"
    exit 1
fi

#
# mark top of run

echo "[----- " `date --rfc-2822` " -----]"
echo "[-ksi-] Running ${action} of ${component}-${version} to ${service}-${environment} at index ${index} ..."

#
# extract user and group from process information

running_user=`id -un`
running_group=`id -gn`

echo "[-ksi-] Running as user \"${running_user}\", group \"${running_group}\" ..."

#
# default and/or extract the roots for the home, config, and base directories.

ksi_home=
ksi_config=
ksi_base=

if [ "X" == "X${KSI_HOME}" ]; then
    ksi_home="/opt"
else
    ksi_home="${KSI_HOME}"
fi

if [ "X" == "X${KSI_CONFIG}" ]; then
    ksi_config="/etc/opt"
else
    ksi_config="${KSI_CONFIG}"
fi

if [ "X" == "X${KSI_BASE}" ]; then
    ksi_base="/var/opt"
else
    ksi_base="${KSI_BASE}"
fi

echo "[-ksi-] Running with root paths of ${ksi_home}, ${ksi_config}, and ${ksi_base} ..."

#
# calculate installer repository from path of invocation and change working directory

installer=$(cd -P -- "$(dirname -- "$0")" && pwd -P) && SELF_PATH=$SELF_PATH/$(basename -- "$0")
cd ${installer}

echo "[-ksi-] Changed directory to ${installer} ..."

#
# convert extracted information to environment seeds, and source helper scripts

echo "[-ksi-] Seeding environment ..."

SERVICE_NAME=${service}
SERVICE_ENVIRONMENT=${environment}
SERVICE_USER=${running_user}
SERVICE_GROUP=${running_group}
COMPONENT_NAME=${component}
COMPONENT_VERSION=${version}
COMPONENT_INDEX=${index}
COMPONENT_ACTION=${action}
INSTALLER_REPOSITORY=${installer}
INSTALLER_HOME_ROOT=${ksi_home}
INSTALLER_CONFIG_ROOT=${ksi_config}
INSTALLER_BASE_ROOT=${ksi_base}
export SERVICE_NAME SERVICE_ENVIRONMENT SERVICE_USER SERVICE_GROUP \
       COMPONENT_NAME COMPONENT_VERSION COMPONENT_INDEX COMPONENT_ACTION \
       INSTALLER_REPOSITORY INSTALLER_HOME_ROOT INSTALLER_CONFIG_ROOT INSTALLER_BASE_ROOT

echo "[-ksi-] Sourcing helper scripts ..."

. ./_setup.sh
. ./_utilities.sh
. ./_stub.sh

#
# source action script

echo "[-ksi-] Sourcing component action script ..."

. ${INSTALLER_COMPONENT_ACTION}

#
# mark end of run, remind about log archiving, and exit

echo "[-ksi-] Run complete."
echo "[----- " `date --rfc-2822` " -----]"

echo "*"
echo "* N.b.: If you have kept a log of this KSI invocation that you would like to"
echo "* retain for future reference, the suggested archive location would be:"
echo "*"
echo "*   ${COMPONENT_VERSION_BUILDLOG}"
echo "*"

exit 0

