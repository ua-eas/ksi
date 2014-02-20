#
# component uninstall script for liquibase-3.0.6
#

#
# Remove the component build and log directories.

echo "[-uninstall-] Removing ${COMPONENT_VERSION_BUILDDIR} ..."
rm -rf ${COMPONENT_VERSION_BUILDDIR}

echo "[-uninstall-] Removing ${COMPONENT_BUILDLOGSDIR} ..."
rm -rf ${COMPONENT_BUILDLOGSDIR}

#
# Remove component home directory. (/opt/kuali/liquibase)

echo "[-uninstall-] Removing ${COMPONENT_INSTALLDIR} ..."
rm -rf ${COMPONENT_INSTALLDIR}

#
# Remove component configuration directory. (/etc/opt/kuali/liquibase)

echo "[-uninstall-] Removing ${COMPONENT_CONFIGDIR} ..."
rm -rf ${COMPONENT_CONFIGDIR}

#
# Remove component base directory. (/var/opt/kuali/liquibase)

echo "[-uninstall-] Removing ${COMPONENT_BASE} ..."
rm -rf ${COMPONENT_BASE}

#
# Remove component's initialization script.

echo "[-uninstall-] Removing initialization script ..."
rm -rf /etc/opt/kuali/__control__/profile.d/*liquibase