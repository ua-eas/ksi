#-----------------------------------------------------------------------#
# _custom.sh
#-----------------------------------------------------------------------#
#
# This script is sourced from "ksi.sh" in order to bring in component-
# and service-specific variables immediately prior to running the
# component's action script -- these variables become available for
# template placeholder replacement when using the process_template()
# utility function, e.g., when installing a "tomcat" component, any
# variable that starts with "TOMCAT_" will be included in the list
# of placeholder replacements when processing templates.
#
# In general, customizations are sourced from the following files,
# in this order:
#
# * the component properties file;
# * the component version properties file;
# * the service properties file;
# * the service environment properties file.
#
# I.e., service properties override component properties, and version
# and environment properties override their corresponding component
# and service properties.
# 
# Mike Simpson
# Kuali Applications Technical Team
# July 2012
#
#-----------------------------------------------------------------------#

echo "[-custom-] Adding environment customizations from properties files ..."

env | sort > env.pre

. ${INSTALLER_COMPONENT_PROPERTIES}
. ${INSTALLER_COMPONENT_VERSION_PROPERTIES}
. ${INSTALLER_SERVICE_PROPERTIES}
. ${INSTALLER_SERVICE_ENVIRONMENT_PROPERTIES}

env | sort > env.post

for x in `cat env.pre env.post | sort | uniq -u | cut -d '=' -f 1`
do
    [ ${!KSI_VERBOSE[@]} ] && echo "[-custom-] + added ${x} = ${!x}"
done

rm env.pre env.post
