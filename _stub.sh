#-----------------------------------------------------------------------#
# _stub.sh
#-----------------------------------------------------------------------#
#
# This script is sourced from "ksi.sh" in order to stub out the basic
# directory structures and a few common files under /opt, /var/opt, and
# /etc/opt, for a particular service.
#
# Note that it doesn't stub out component-specific structure -- that
# should be handled by the individual install scripts.  But it does
# make sure that the basic structure gets established and verified
# each time a new installation is performed.
#
# Mike Simpson
# Kuali Applications Technical Team
# July 2012
#
#-----------------------------------------------------------------------#

#
# Stub out the service home paths.

echo "[-stub-] Stubbing out service home directory structure ..."

for x in SERVICE_HOME SERVICE_BUILDDIR SERVICE_BUILDLOGSDIR SERVICE_BUILDSRCDIR
do
    mkdir -p ${!x} || echo >&2 "[*stub*] + failed to make ${x} at ${!x}"
done

#
# Stub out the service configuration paths.

echo "[-stub-] Stubbing out service configuration directory structure ..."

for x in SERVICE_CONFIG SERVICE_CONTROLDIR SERVICE_INITDIR SERVICE_PROFILEDIR 
do
    mkdir -p ${!x} || echo >&2 "[*stub*] + failed to make ${x} at ${!x}"
done

#
# Install master init script and master profile from templates if not present.

if [ ! -e "${SERVICE_MASTER_INIT}" ]
then
    process_template ${INSTALLER_MASTER_INIT_TMPL} > ${SERVICE_MASTER_INIT} || echo >&2 "[*stub*] failed to install master init script at ${SERVICE_MASTER_INIT}"
    chmod 744 ${SERVICE_MASTER_INIT}
fi

if [ ! -e "${SERVICE_MASTER_PROFILE}" ]
then
    process_template ${INSTALLER_MASTER_PROFILE_TMPL} > ${SERVICE_MASTER_PROFILE} || echo >&2 "[*stub*] failed to install master profile at ${SERVICE_MASTER_PROFILE}"
    chmod 644 ${SERVICE_MASTER_PROFILE}
fi

#
# Set service control script symlink if not present.

if [ ! -e "${SERVICE_CONTROL_SCRIPT}" ]
then
    ln -s ${SERVICE_MASTER_INIT} ${SERVICE_CONTROL_SCRIPT} || echo >&2 "[*stub*] failed to set service control symlink at ${SERVICE_CONTROL_SCRIPT}"
fi

#
# Stub out the service base paths.

echo "[-stub-] Stubbing out service base directory structure ..."

for x in SERVICE_BASE
do
    mkdir -p ${!x} || echo >&2 "[*stub*] + failed to make ${x} at ${!x}"
done

