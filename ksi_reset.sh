#-----------------------------------------------------------------------#
# ksi.sh
#-----------------------------------------------------------------------#
#
# The Kuali Service Installer Reset Script.
#
# Invoked as:
#
#  % ksi_reset.sh -s <service> [-f]
#
#    e.g.
#
#      % ksi_reset.sh -s kuali 
#
# The service installer reset script provides a simple script
# for wiping a particular service point clean, preparatory to doing
# a fresh KSI installation of the service components.
#
# It's a good bit simpler than the main "ksi.sh" script, basically
# it just grabs what it needs from the command line arguments
# and environment variables, then removes everything under the
# service home, service configuration, and service base directories.
# 
# Note that by default, the reset assumes the following root paths:
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
# Also note that, by default, the script will ask you to confirm
# that you want to wipe out the service point; you can add the
# "-f" (for "force") switch to disable the confirmation prompt.
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
force="no"

usage="no"
while getopts s:f opt
do
    case "$opt" in

      s) service="${OPTARG}";;

      f) force="yes";;

     \?) # unknown flag
         usage="yes";;

    esac
done

if [ "X" == "X${service}" ]; then
    usage="yes"
fi

if [ ${usage} == "yes" ]; then
    echo >&2 "usage: $0 -s [service]"
    exit 1
fi

#
# mark top of run

echo "[----- " `date --rfc-2822` " -----]"
echo "[-ksi_reset-] Resetting ${service} service ..."

#
# extract user and group from process information

running_user=`id -un`
running_group=`id -gn`

echo "[-ksi_reset-] Running as user \"${running_user}\", group \"${running_group}\" ..."

#
# default and/or extract the roots for the home, config, and base directories

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

echo "[-ksi_reset-] Running with root paths of ${ksi_home}, ${ksi_config}, and ${ksi_base} ..."

#
# prompt for confirmation unless forcing

if [ ${force} != "yes" ]; then
    echo
    echo "-----"
    echo "Are you sure (type \"yes\" to continue)?"
    read confirm
    if [ ${confirm} != "yes" ]; then
        exit 1
    fi
    echo "-----"
    echo
fi

#
# wipe service directories

service_home=${ksi_home}/${service}
service_config=${ksi_config}/${service}
service_base=${ksi_base}/${service}

echo "[-ksi_reset-] Resetting service home ${service_home} ..."
rm -rf ${service_home}/*

echo "[-ksi_reset-] Resetting service configuration ${service_config} ..."
rm -rf ${service_config}/*

echo "[-ksi_reset-] Resetting service base ${service_base} ..."
rm -rf ${service_base}/*

#
# mark end of run and exit

echo "[-ksi_reset-] Reset complete."
echo "[----- " `date --rfc-2822` " -----]"

exit 0

