#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

# Note that we also need some specific pkg_dependencies for build with arm architectures
# dependencies used by the app
pkg_dependencies="python2.7 python2.7-dev python-virtualenv virtualenv uwsgi uwsgi-plugin-python build-essential libssl-dev libffi-dev libmariadbclient-dev-compat"

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
        ynh_exec_warn_less pip install --upgrade pip
        ynh_exec_warn_less pip install --upgrade pyramid_chameleon 'soupsieve<2.0'
        ynh_exec_warn_less CFLAGS="-Wno-error -Wno-error=format-security" \
            ARCHFLAGS="-Wno-error=unused-command-line-argument-hard-error-in-future" \
            pip install --upgrade --requirement "$final_path/requirements.txt"

        ynh_exec_warn_less python "$final_path/setup.py" develop

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

# Check if system wide templates are available and correcly configured
#
# usage: ynh_check_global_uwsgi_config
ynh_check_global_uwsgi_config () {
    uwsgi --version || ynh_die --message="You need to add uwsgi (and appropriate plugin) as a dependency"

    cat > /etc/systemd/system/uwsgi-app@.service <<EOF
[Unit]
Description=%i uWSGI app
After=syslog.target

[Service]
RuntimeDirectory=%i
ExecStart=/usr/bin/uwsgi \
        --ini /etc/uwsgi/apps-available/%i.ini \
        --socket /run/%i/app.socket \
        --logto /var/log/uwsgi/%i/%i.log
User=%i
Group=www-data
Restart=always
RestartSec=10
KillSignal=SIGQUIT
Type=notify
StandardError=syslog
NotifyAccess=all

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload --quiet
}

# Create a dedicated uwsgi ini file to use with generic uwsgi service
#
# This will use a template in ../conf/uwsgi.ini
# and will replace the following keywords with
# global variables that should be defined before calling
# this helper :
#
#   __APP__       by  $app
#   __PATH__      by  $path_url
#   __FINALPATH__ by  $final_path
#
#  And dynamic variables (from the last example) :
#   __PATH_2__    by $path_2
#   __PORT_2__    by $port_2
#
# To be able to customise the settings of the systemd unit you can override the rules with the file "conf/uwsgi-app@override.service".
# This file will be automatically placed on the good place
# 
# Note that the service need to be started manually at the end of the installation.
# Generally you can start the service with this command:
# # ynh_systemd_action --service_name "uwsgi-app@$app.service" --line_match "WSGI app 0 \(mountpoint='[/[:alnum:]_-]*'\) ready in [[:digit:]]* seconds on interpreter" --log_path "/var/log/uwsgi/$app/$app.log"
#
# usage: ynh_add_uwsgi_service
#
# to interact with your service: `systemctl <action> uwsgi-app@$app`
ynh_add_uwsgi_service () {
    ynh_check_global_uwsgi_config

    local others_var=${1:-}
    local finaluwsgiini="/etc/uwsgi/apps-available/$app.ini"

    # www-data group is needed since it is this nginx who will start the service
    usermod --append --groups www-data "$app" || ynh_die --message="It wasn't possible to add user $app to group www-data"

    ynh_backup_if_checksum_is_different --file="$finaluwsgiini"
    cp ../conf/uwsgi.ini "$finaluwsgiini"

    # To avoid a break by set -u, use a void substitution ${var:-}. If the variable is not set, it's simply set with an empty variable.
    # Substitute in a nginx config file only if the variable is not empty
    if test -n "${final_path:-}"; then
        ynh_replace_string --match_string="__FINALPATH__" --replace_string="$final_path" --target_file="$finaluwsgiini"
    fi
    if test -n "${path_url:-}"; then
        ynh_replace_string --match_string="__PATH__" --replace_string="$path_url" --target_file="$finaluwsgiini"
    fi
    if test -n "${app:-}"; then
        ynh_replace_string --match_string="__APP__" --replace_string="$app" --target_file="$finaluwsgiini"
    fi

    # Replace all other variable given as arguments
    for var_to_replace in $others_var
    do
        # ${var_to_replace^^} make the content of the variable on upper-cases
        # ${!var_to_replace} get the content of the variable named $var_to_replace 
        ynh_replace_string --match_string="__${var_to_replace^^}__" --replace_string="${!var_to_replace}" --target_file="$finaluwsgiini"
    done

    ynh_store_file_checksum --file="$finaluwsgiini"

    chown $app:root "$finaluwsgiini"

    # make sure the folder for logs exists and set authorizations
    mkdir -p /var/log/uwsgi/$app
    chown $app:root /var/log/uwsgi/$app
    chmod -R u=rwX,g=rX,o= /var/log/uwsgi/$app

    # Setup specific Systemd rules if necessary
    test -e ../conf/uwsgi-app@override.service && \
        mkdir /etc/systemd/system/uwsgi-app@$app.service.d && \
        cp ../conf/uwsgi-app@override.service /etc/systemd/system/uwsgi-app@$app.service.d/override.conf

    systemctl daemon-reload --quiet
    systemctl enable "uwsgi-app@$app.service" --quiet

    # Add as a service
    yunohost service add "uwsgi-app@$app" --log "/var/log/uwsgi/$app/$app.log"
}

# Remove the dedicated uwsgi ini file
#
# usage: ynh_remove_uwsgi_service
ynh_remove_uwsgi_service () {
    local finaluwsgiini="/etc/uwsgi/apps-available/$app.ini"
    if [ -e "$finaluwsgiini" ]; then
        yunohost service remove "uwsgi-app@$app"
        systemctl stop "uwsgi-app@$app.service" --quiet
        systemctl disable "uwsgi-app@$app.service" --quiet

        ynh_secure_remove --file="$finaluwsgiini"
        ynh_secure_remove --file="/var/log/uwsgi/$app"
        ynh_secure_remove --file="/etc/systemd/system/uwsgi-app@$app.service.d"
    fi
}

ynh_restore_uwsgi_service () {
    ynh_check_global_uwsgi_config
    systemctl enable "uwsgi-app@$app" --quiet
    yunohost service add "uwsgi-app@$app" --log "/var/log/uwsgi/$app/$app.log"
}

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
