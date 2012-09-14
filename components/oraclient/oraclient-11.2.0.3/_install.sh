#
# component install script for oraclient-11.2.0.3
#

#
# Globals.

distfiles=( "instantclient-basic-linux.x64-11.2.0.3.0.zip" \
            "instantclient-jdbc-linux.x64-11.2.0.3.0.zip" \
            "instantclient-sqlplus-linux.x64-11.2.0.3.0.zip" )
unpacks_to="instantclient_11_2"

#
# Make the component build and log directories.

echo "[-install-] Creating ${COMPONENT_VERSION_BUILDDIR} ..."
mkdir -p ${COMPONENT_VERSION_BUILDDIR}

echo "[-install-] Creating ${COMPONENT_BUILDLOGSDIR} ..."
mkdir -p ${COMPONENT_BUILDLOGSDIR}

#
# Copy the distribution files to it.

echo "[-install-] Copying distribution files to ${COMPONENT_VERSION_BUILDDIR} ..."
for d in "${distfiles[@]}"
do
    cp ${INSTALLER_COMPONENT_VERSIONDIR}/${d} ${COMPONENT_VERSION_BUILDDIR}
done

#
# Change directory and unpack files.

echo "[-install-] Unpacking distribution files ..."
thisdir=`pwd`
cd ${COMPONENT_VERSION_BUILDDIR}
for d in "${distfiles[@]}"
do
    unzip ${d}
done
cd ${thisdir}

#
# Move unpacked distribution to become component home directory.

echo "[-install-] Moving to component home directory ..."
mkdir -p ${COMPONENT_INSTALLDIR}
mv ${COMPONENT_VERSION_BUILDDIR}/${unpacks_to} ${COMPONENT_HOME}

#
# Add component configuration.

echo "[-install-] Adding component configuration ..."
mkdir -p ${COMPONENT_CONFIG}
process_template ${INSTALLER_COMPONENT_PROFILE_TMPL} > ${COMPONENT_PROFILE}

#
# Add TNSNAMES file to the config directory.

echo "[-install-] Installing stock tnsnames.ora file to component configuration ..."
cp ${INSTALLER_COMPONENT_VERSIONDIR}/tnsnames.ora ${COMPONENT_CONFIG}

#
# Add component base.

echo "[-install-] Adding component base structure ..."
mkdir -p ${COMPONENT_BASE}
mkdir -p ${COMPONENT_LOGS}

