#!/bin/bash

# Check if system wide templates are available and correcly configured
#
# usage: ynh_check_global_uwsgi_config
ynh_check_global_uwsgi_config () {
	uwsgi --version || ynh_die "You need to add uwsgi (and appropriate plugin) as a dependency"

	cat >> /etc/systemd/system/uwsgi-app@.service <<EOF
[Unit]
Description=%i uWSGI app
After=syslog.target

[Service]
RuntimeDirectory=%i
ExecStart=/usr/bin/uwsgi \
        --ini /etc/uwsgi/apps-available/%i.ini \
        --socket /var/run/%i/app.socket \
        --logto /var/log/uwsgi/%i/%i.log
User=%i
Group=www-data
Restart=on-failure
KillSignal=SIGQUIT
Type=notify
StandardError=syslog
NotifyAccess=all

[Install]
WantedBy=multi-user.target
EOF

	systemctl daemon-reload
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
# usage: ynh_add_uwsgi_service
#
# to interact with your service: `systemctl <action> uwsgi-app@app`
ynh_add_uwsgi_service () {
	ynh_check_global_uwsgi_config

	local others_var=${1:-}
	local finaluwsgiini="/etc/uwsgi/apps-available/$app.ini"

	# www-data group is needed since it is this nginx who will start the service
	usermod --append --groups www-data "$app" || ynh_die "It wasn't possible to add user $app to group www-data"

	ynh_backup_if_checksum_is_different "$finaluwsgiini"
	cp ../conf/uwsgi.ini "$finaluwsgiini"

	# To avoid a break by set -u, use a void substitution ${var:-}. If the variable is not set, it's simply set with an empty variable.
	# Substitute in a nginx config file only if the variable is not empty
	if test -n "${final_path:-}"; then
		ynh_replace_string "__FINALPATH__" "$final_path" "$finaluwsgiini"
	fi
	if test -n "${path_url:-}"; then
		ynh_replace_string "__PATH__" "$path_url" "$finaluwsgiini"
	fi
	if test -n "${app:-}"; then
		ynh_replace_string "__APP__" "$app" "$finaluwsgiini"
	fi

	# Replace all other variable given as arguments
	for var_to_replace in $others_var
	do
		# ${var_to_replace^^} make the content of the variable on upper-cases
		# ${!var_to_replace} get the content of the variable named $var_to_replace 
		ynh_replace_string "__${var_to_replace^^}__" "${!var_to_replace}" "$finaluwsgiini"
	done

	ynh_store_file_checksum "$finaluwsgiini"

	chown $app:root "$finaluwsgiini"

	# make sure the folder for logs exists and set authorizations
	mkdir -p /var/log/uwsgi/$app
	chown $app:root /var/log/uwsgi/$app
	chmod -R u=rwX,g=rX,o= /var/log/uwsgi/$app

	# Setup specific Systemd rules if necessary
	test -e ../conf/uwsgi-app@override.service && \
		mkdir /etc/systemd/system/uwsgi-app@$app.service.d && \
		cp ../conf/uwsgi-app@override.service /etc/systemd/system/uwsgi-app@$app.service.d/override.conf

	systemctl daemon-reload
	systemctl stop "uwsgi-app@$app.service"
	systemctl enable "uwsgi-app@$app.service"
	systemctl start "uwsgi-app@$app.service"

	# Add as a service
	yunohost service add "uwsgi-app@$app" --log "/var/log/uwsgi/$app/$app.log"
}

# Remove the dedicated uwsgi ini file
#
# usage: ynh_remove_uwsgi_service
ynh_remove_uwsgi_service () {
	local finaluwsgiini="/etc/uwsgi/apps-available/$app.ini"
	if [ -e "$finaluwsgiini" ]; then
		systemctl stop "uwsgi-app@$app.service"
		systemctl disable "uwsgi-app@$app.service"
		yunohost service remove "uwsgi-app@$app"

		ynh_secure_remove "$finaluwsgiini"
		ynh_secure_remove "/var/log/uwsgi/$app"
		ynh_secure_remove "/etc/systemd/system/uwsgi-app@$app.service.d"
	fi
}
