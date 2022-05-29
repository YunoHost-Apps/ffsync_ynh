#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================


# Note that we also need some specific pkg_dependencies for build with arm architectures
# dependencies used by the app
pkg_dependencies="pypy pypy-dev python3-virtualenv uwsgi build-essential libssl-dev libffi-dev libmariadb-dev-compat"

#=================================================
# PERSONAL HELPERS
#=================================================

install_sources() {
    ynh_setup_source --dest_dir "$final_path"

    # pip installation
    virtualenv --python=$(which pypy | head -n 1) "$final_path/local"
    # Install manually pip v20.1 because the installed version from the system don't work any more with pyp v2.7
    cp -r ../sources/pip_20.1/. $final_path/local/site-packages/pip

    # Init virtualenv
    set +o nounset
    source "$final_path/local/bin/activate"
    set -o nounset
    pushd "$final_path"
    pip install --upgrade 'pip<20.2'
    pip install setuptools==44.1.1
    pip install --upgrade pyramid_chameleon 'soupsieve<2.0' uwsgi
    CFLAGS="-Wno-error -Wno-error=format-security" \
        ARCHFLAGS="-Wno-error=unused-command-line-argument-hard-error-in-future" \
        pip install --upgrade --requirement "$final_path/requirements.txt"
    pypy "$final_path/setup.py" develop
    popd

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
