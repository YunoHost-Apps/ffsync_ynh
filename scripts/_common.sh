#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================


# Note that we also need some specific pkg_dependencies for build with arm architectures
# dependencies used by the app
pkg_dependencies="pypy pypy-dev python3-virtualenv build-essential libssl-dev libffi-dev libmariadb-dev-compat"

#=================================================
# PERSONAL HELPERS
#=================================================

call_pip() {
    # Sometime we get a segfault error while we invoke pip
    # As we don't have a really clean way to fix this really bad error we just try many time utils it works
    i=0
    result_ok=false
    while [ $i -lt 5 ] && ! $result_ok; do
        ynh_exec_warn_less pip $@ && result_ok=true
        i=$((i+1))
    done
    if ! $result_ok; then
        echo "Error on build package"
        false
    fi
}

install_sources() {
    ynh_setup_source --dest_dir "$final_path"

    # pip installation
    python3 -m virtualenv --python=$(which pypy | head -n 1) "$final_path/local"
    # Install manually pip v20.1 because the installed version from the system don't work any more with pyp v2.7
    cp -r ../sources/pip_20.1/. $final_path/local/site-packages/pip

    # Init virtualenv
    set +o nounset
    source "$final_path/local/bin/activate"
    set -o nounset
    pushd "$final_path"
    call_pip install --upgrade 'pip<20.2'
    call_pip install setuptools==44.1.1
    call_pip install --upgrade pyramid_chameleon 'soupsieve<2.0'
    CFLAGS="-Wno-error -Wno-error=format-security" \
        ARCHFLAGS="-Wno-error=unused-command-line-argument-hard-error-in-future" \
        call_pip install --upgrade --requirement "$final_path/requirements.txt"
    pypy "$final_path/setup.py" develop
    test -e $final_path/local/lib_pypy/_sysconfigdata.py || ln -s /usr/lib/pypy/lib_pypy/_sysconfigdata.py $final_path/local/lib_pypy/_sysconfigdata.py
    test -e $final_path/local/lib_pypy/cffi || ln -s /usr/lib/pypy/lib_pypy/cffi $final_path/local/lib_pypy/cffi
    popd

    # Add nice homepage
    cp -r ../sources/page $final_path/syncserver/
    (cd "$final_path/syncserver" && patch -p1 < $YNH_CWD/../sources/homepage.patch) || echo "Unable to apply patches"
}

set_permissions() {
    chown $app -R $final_path
    chmod u=rwX,g=rX,o= -R $final_path
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
