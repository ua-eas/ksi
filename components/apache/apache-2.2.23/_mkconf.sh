#
# configuration file creation script for apache-2.2.23
#

#
# Globals.

cfgfile="kuali.conf"

#
# Make the component build and log directories.

echo "[-install-] Creating ${COMPONENT_VERSION_BUILDDIR} ..."
mkdir -p ${COMPONENT_VERSION_BUILDDIR}

echo "[-install-] Creating ${COMPONENT_BUILDLOGSDIR} ..."
mkdir -p ${COMPONENT_BUILDLOGSDIR}

#
# Add component configuration.

echo "[-install-] Creating kuali configuration file ..."
mkdir -p ${COMPONENT_CONFIG}
process_template ${INSTALLER_SERVICE_COMPONENT_TMPLDIR}/${cfgfile}.tmpl > ${COMPONENT_CONFIG}/${cfgfile}

