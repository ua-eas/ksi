#
# component install script for jdk-1.6.0_33
#

#
# Globals.

distfile="jdk-6u33-linux-x64.bin"
unpacksto="jdk1.6.0_33"

#
# Make the component build and log directories.

echo "[-install-] Creating ${COMPONENT_VERSION_BUILDDIR} ..."
mkdir -p ${COMPONENT_VERSION_BUILDDIR}

echo "[-install-] Creating ${COMPONENT_BUILDLOGSDIR} ..."
mkdir -p ${COMPONENT_BUILDLOGSDIR}

#
# Copy the distribution file to it.

echo "[-install-] Copying ${INSTALLER_COMPONENT_VERSIONDIR}/${distfile} to ${COMPONENT_VERSION_BUILDDIR} ..."
cp ${INSTALLER_COMPONENT_VERSIONDIR}/${distfile} ${COMPONENT_VERSION_BUILDDIR}

#
# Turn on execute bit.

echo "[-install-] Turning on execute bit ..."
chmod +x ${COMPONENT_VERSION_BUILDDIR}/${distfile}

#
# Change directory and execute to install, including minor hacks
# to fix stupid Oracle interactive install process.

echo "[-install-] Executing distribution package ..."
thisdir=`pwd`
cd ${COMPONENT_VERSION_BUILDDIR}
echo "yes" > answers.txt
./${distfile} < ./answers.txt > /dev/null
cd ${thisdir}

#
# Move unpacked distribution to become component home directory.

echo "[-install-] Moving to component home directory ..."
mkdir -p ${COMPONENT_INSTALLDIR}
mv ${COMPONENT_VERSION_BUILDDIR}/${unpacksto} ${COMPONENT_HOME}

#
# Add component configuration.

echo "[-install-] Adding component configuration ..."
mkdir -p ${COMPONENT_CONFIG}
process_template ${INSTALLER_COMPONENT_PROFILE_TMPL} > ${COMPONENT_PROFILE}

# Add component base.

echo "[-install-] Adding component base structure ..."
mkdir -p ${COMPONENT_BASE}
mkdir -p ${COMPONENT_LOGS}

