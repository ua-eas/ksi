#
# component home install script for tomcat-7.0.28
#

#
# Globals.

distfile="apache-tomcat-7.0.28.tar.gz"
unpacksto="apache-tomcat-7.0.28"

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
# Unpack distribution file.

echo "[-install-] Unpacking distribution file ..."
( cd ${COMPONENT_VERSION_BUILDDIR} && tar zxf ${distfile} )

#
# Move unpacked distribution to become component home directory.

echo "[-install-] Moving to component home directory ..."
mkdir -p ${COMPONENT_INSTALLDIR}
mv ${COMPONENT_VERSION_BUILDDIR}/${unpacksto} ${COMPONENT_HOME}

#
# Clean up home, saving base content for later use in creating new instances.

echo "[-install-] Cleaning up home directory, saving base content for later use ..."
thisdir=`pwd`
cd ${COMPONENT_HOME}
mkdir __dist__
for x in conf logs temp webapps work
do
    mv ${x} __dist__
done
mkdir __base__
cd __base__
mkdir bin conf lib logs temp webapps work
cp ../bin/tomcat-juli.jar ./bin
cd ${thisdir}

#
# Add component configuration.

echo "[-install-] Adding component configuration ..."
mkdir -p ${COMPONENT_CONFIG}
process_template ${INSTALLER_COMPONENT_PROFILE_TMPL} > ${COMPONENT_PROFILE}

#
# Add component base.

echo "[-install-] Adding component base structure ..."
mkdir -p ${COMPONENT_BASE}

