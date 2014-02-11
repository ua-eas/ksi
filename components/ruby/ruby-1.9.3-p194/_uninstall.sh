#
# component uninstall script for ruby-1.9.3-p194
#

#
# Remove the component build and log directories.

echo "[-uninstall-] Removing ${COMPONENT_BUILDSRCDIR} ..."
rm -rf ${COMPONENT_BUILDSRCDIR}

echo "[-uninstall-] Removing ${COMPONENT_BUILDLOGSDIR} ..."
rm -rf ${COMPONENT_BUILDLOGSDIR}

#
# Remove component home directory. (/opt/kuali/ruby)

echo "[-uninstall-] Removing ${COMPONENT_INSTALLDIR} ..."
rm -rf ${COMPONENT_INSTALLDIR}

#
# Remove component configuration directory. (/etc/opt/kuali/ruby)

echo "[-uninstall-] Removing ${COMPONENT_CONFIGDIR} ..."
rm -rf ${COMPONENT_CONFIGDIR}

#
# Remove component base directory. (/var/opt/kuali/ruby)

echo "[-uninstall-] Removing ${COMPONENT_BASE} ..."
rm -rf ${COMPONENT_BASE}

#
# Remove component's initialization script.

echo "[-uninstall-] Removing initialization script ..."
rm -rf /etc/opt/kuali/__control__/profile.d/*ruby