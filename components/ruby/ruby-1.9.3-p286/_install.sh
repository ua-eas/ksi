#
# component install script for ruby-1.9.3-p286
#

#
# Globals.

distfile="ruby-1.9.3-p286.tar.gz"
unpacksto="ruby-1.9.3-p286"
thisdir=`pwd`
gemlist="activesupport log4r mail thor"

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
# Build and install from source.

echo "[-install-] Building component from source ..."

echo "[-install-] Configuring ..."
./configure --prefix=${COMPONENT_HOME} --enable-shared --enable-pthread

echo "[-install-] Compiling ..."
make

echo "[-install-] Installing ..."
make install

#
# Update and install useful gems.

GEM=${COMPONENT_HOME}/bin/gem
echo "[-install-] Using ${GEM} to install and update gems ..."

for g in ${gemlist}
do
        echo "[-install-] Installing ${g} gem ..."
        ${GEM} install ${g}
done

echo "[-install-] Updating all installed gems ..."
${GEM} update

#
# Return to original directory.

echo "[-install-] Changing directory to ${thisdir} ..."
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
mkdir -p ${COMPONENT_LOGS}

