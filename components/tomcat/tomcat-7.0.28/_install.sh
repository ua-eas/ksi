#
# component install script for tomcat-7.0.28
#

#
# Globals.

distfile="apache-tomcat-7.0.28.tar.gz"
unpacksto="apache-tomcat-7.0.28"

mailjar="javamail.jar"

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
# Add JavaMail API into Tomcat's common lib directory.

echo "[-install-] Adding javamail library ..."
cp ${INSTALLER_COMPONENT_VERSIONDIR}/${mailjar} ${COMPONENT_HOME}/lib

#
# Clean up home, saving base content for later use in creating new instances.

echo "[-install-] Cleaning up home directory ..."
thisdir=`pwd`
cd ${COMPONENT_HOME}
for x in conf logs temp webapps work
do
     rm -rf ${x}
done
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

