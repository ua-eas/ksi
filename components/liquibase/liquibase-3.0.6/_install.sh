#
# component install script for liquibase-3.0.6
#

#
# Globals.

distfile="liquibase-3.0.6-bin.tar.gz"
unpacksto="liquibase-3.0.6-bin"
thisdir=`pwd`

#
# Make the component build and log directories.

echo "[-install-] Creating ${COMPONENT_VERSION_BUILDDIR} ..."
mkdir -p ${COMPONENT_VERSION_BUILDDIR}

echo "[-install-] Creating ${COMPONENT_BUILDLOGSDIR} ..."
mkdir -p ${COMPONENT_BUILDLOGSDIR}

#
# Copy the distribution file to the build directory.

echo "[-install-] Copying ${INSTALLER_COMPONENT_VERSIONDIR}/${distfile} to ${COMPONENT_VERSION_BUILDDIR} ..."
cp ${INSTALLER_COMPONENT_VERSIONDIR}/${distfile} ${COMPONENT_VERSION_BUILDDIR}

#
# Change directory to build directory.

echo "[-install-] Changing directory to ${COMPONENT_VERSION_BUILDDIR} ..."
cd ${COMPONENT_VERSION_BUILDDIR}

#
# Unpack the distribution file.

echo "[-install-] Unpacking distribution file ..."
tar zxf ${distfile}
cd ${unpacksto}

#
# Copy all binary files to $COMPONENT_HOME

echo "[-install-] Copying binary files to ${COMPONENT_HOME}/bin/ ..."
mkdir -p ${COMPONENT_HOME}/bin/
cp -rp ./* ${COMPONENT_HOME}/bin/

#
# Make liquibase binary executable

echo "[-install-] Making liquibase binary executable ..."
chmod 700 ${COMPONENT_HOME}/bin/liquibase

#
# Return to original directory.

echo "[-install-] Changing directory to ${thisdir} ..."
cd ${thisdir}

echo "[-install-] Copying ${INSTALLER_COMPONENT_VERSIONDIR}/liquibase_kc.sh to ${COMPONENT_HOME}/bin/ ..."
cp -rp ${INSTALLER_COMPONENT_VERSIONDIR}/liquibase_kc.sh ${COMPONENT_HOME}/bin/

echo "[-install-] Copying ${INSTALLER_COMPONENT_VERSIONDIR}/lib/*.jar to ${COMPONENT_HOME}/lib/ ..."
mkdir -p ${COMPONENT_HOME}/lib/
cp -rp ${INSTALLER_COMPONENT_VERSIONDIR}/lib/*.jar ${COMPONENT_HOME}/lib/

#
# Add component configuration.

echo "[-install-] Adding component configuration ..."
mkdir -p ${COMPONENT_CONFIG}
process_template ${INSTALLER_COMPONENT_PROFILE_TMPL} > ${COMPONENT_PROFILE}

#
# Add component base.

echo "[-install-] Adding component base structure ..."
mkdir -p ${COMPONENT_BASE}
mkdir -p ${COMPONENT_LOGS}

