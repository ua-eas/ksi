#
# component install script for rhubarb 1.0
#
# Note: Rhubarb is a component we actually develop and deploy separately 
#       in house. This component install will setup the service infrastructure
#		requirements for this component but it will be deployed on it's own
#		development and deployment cycle.

#
# Make the component log directory.

echo "[-install-] Creating ${COMPONENT_BUILDLOGSDIR} ..."
mkdir -p ${COMPONENT_BUILDLOGSDIR}

#
# Add component configuration.

echo "[-install-] Adding component configuration ..."
mkdir -p ${COMPONENT_CONFIG}
process_template ${INSTALLER_COMPONENT_PROFILE_TMPL} > ${COMPONENT_PROFILE}

# Add component base.

echo "[-install-] Adding component base structure ..."
mkdir -p ${COMPONENT_BASE}
mkdir -p ${COMPONENT_LOGS}
mkdir -p ${COMPONENT_HOME}

echo "COMPONENT_HOME: ${COMPONENT_HOME}"

#
# Add the expected control directory
echo "[-install-] Adding batch home control structure ..."
mkdir -p "${RHUBARB_BATCH_HOME}/control"

#
# Add the expected logs directory
echo "[-install-] Adding batch home logs structure ..."
mkdir -p "${RHUBARB_BATCH_HOME}/logs"

#
# Set the runnable file

# remove the old .runable file if it exists
echo "[-install-] Removing all existing .runnable files ..."
rm ${RHUBARB_BATCH_HOME}/control/*.runnable

echo "[-install-] Adding the runnable file ..."
touch ${RHUBARB_BATCH_HOME}/control/${RHUBARB_BATCH_RUNNABLE_HOST}.runnable