#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================


# Note that we also need some specific pkg_dependencies for build with arm architectures
# dependencies used by the app
pkg_dependencies="python-dev python-virtualenv virtualenv uwsgi uwsgi-plugin-python build-essential libssl-dev libffi-dev"

#=================================================
# PERSONAL HELPERS
#=================================================

install_sources() {
    ynh_setup_source --dest_dir "$final_path"

    # pip installation
    virtualenv --python=$(which python2 python | head -n 1) "$final_path/local"
    # Init virtualenv
    (
        set +o nounset
        source "$final_path/local/bin/activate"
        set -o nounset
        cd "$final_path"
        pip install --upgrade pip
        pip install --upgrade pyramid_chameleon
        CFLAGS="-Wno-error -Wno-error=format-security" \
            ARCHFLAGS="-Wno-error=unused-command-line-argument-hard-error-in-future" \
            pip install --upgrade --requirement "$final_path/requirements.txt"

        python "$final_path/setup.py" develop

        touch "$final_path/local/COMPLETE"
    )
    # Add nice homepage
    cp -r ../sources/page $final_path/syncserver/
    (cd "$final_path/syncserver" && patch -p1 < $YNH_CWD/../sources/homepage.patch) || echo "Unable to apply patches"
}

set_permissions() {
    chown $app -R $final_path
    chmod u=rwX,g=rX,o= -R $final_path
    chown $app:root /var/log/uwsgi/$app
    chmod -R u=rwX,g=rX,o= /var/log/uwsgi/$app
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
