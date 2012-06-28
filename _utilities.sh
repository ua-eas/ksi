#-----------------------------------------------------------------------#
# _utilities.sh
#-----------------------------------------------------------------------#
#
# This script is sourced from "ksi.sh" in order to set up some basic
# utility functions used in various places in the installation
# scripting.
#
# It needs to be sourced after "_layout.sh", since it uses one of the
# environment variables established in that script.
#
# Mike Simpson
# Kuali Applications Technical Team
# July 2012
#
#-----------------------------------------------------------------------#

echo "[-utilities-] Loading utility functions ..."

process_template () {
    if [ "X$1" == "X" ]
    then
        echo >&2 "[*utilities*] missing argument in process_template()"
        exit 1
    else
        template="$1"
    fi

    if [ ! -s $template ]
    then
        echo >&2 "[*utilities*] cannot find specified template file $template"
    fi

    cp $template $template.$$
    for var in `env | cut -f1 -d"=" | egrep "(INSTALLER_|SERVICE_|COMPONENT_|${COMPONENT_PREFIX}_)"`
    do
        eval "value=\$$var"
        sed -i "s#{{${var}}}#$value#g" $template.$$
    done
    cat $template.$$
    rm $template.$$
}

