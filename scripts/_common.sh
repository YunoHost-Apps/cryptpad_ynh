#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================
nodejs_version=8.11.4

#=================================================
# BACKUP
#=================================================

HUMAN_SIZE () {	# Transforme une taille en Ko en une taille lisible pour un humain
	human=$(numfmt --to=iec --from-unit=1K $1)
	echo $human
}

CHECK_SIZE () {	# Vérifie avant chaque backup que l'espace est suffisant
	file_to_analyse=$1
	backup_size=$(du --summarize "$file_to_analyse" | cut -f1)
	free_space=$(df --output=avail "/home/yunohost.backup" | sed 1d)

	if [ $free_space -le $backup_size ]
	then
		ynh_print_err "Espace insuffisant pour sauvegarder $file_to_analyse."
		ynh_print_err "Espace disponible: $(HUMAN_SIZE $free_space)"
		ynh_die "Espace nécessaire: $(HUMAN_SIZE $backup_size)"
	fi
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

n_install_dir="/opt/node_n"
node_version_path="$n_install_dir/n/versions/node"
# N_PREFIX is the directory of n, it needs to be loaded as a environment variable.
export N_PREFIX="$n_install_dir"

# Install Node version management
#
# [internal]
#
# usage: ynh_install_n
ynh_install_n () {
	echo "Installation of N - Node.js version management" >&2
	# Build an app.src for n
	mkdir -p "../conf"
	echo "SOURCE_URL=https://github.com/tj/n/archive/v2.1.7.tar.gz
SOURCE_SUM=2ba3c9d4dd3c7e38885b37e02337906a1ee91febe6d5c9159d89a9050f2eea8f" > "../conf/n.src"
	# Download and extract n
	ynh_setup_source "$n_install_dir/git" n
	# Install n
	(cd "$n_install_dir/git"
	PREFIX=$N_PREFIX make install 2>&1)
}

# Load the version of node for an app, and set variables.
#
# ynh_use_nodejs has to be used in any app scripts before using node for the first time.
#
# 2 variables are available:
#   - $nodejs_path: The absolute path of node for the chosen version.
#   - $nodejs_version: Just the version number of node for this app. Stored as 'nodejs_version' in settings.yml.
# And 2 alias stored in variables:
#   - $nodejs_use_version: An old variable, not used anymore. Keep here to not break old apps
#     NB: $PATH will contain the path to node, it has to be propagated to any other shell which needs to use it.
#     That's means it has to be added to any systemd script.
#
# usage: ynh_use_nodejs
ynh_use_nodejs () {
	nodejs_version=$(ynh_app_setting_get $app nodejs_version)

	nodejs_use_version="echo \"Deprecated command, should be removed\""

	# Get the absolute path of this version of node
	nodejs_path="$node_version_path/$nodejs_version/bin"

	# Load the path of this version of node in $PATH
	[[ :$PATH: == *":$nodejs_path"* ]] || PATH="$nodejs_path:$PATH"
}

# Install a specific version of nodejs
#
# n (Node version management) uses the PATH variable to store the path of the version of node it is going to use.
# That's how it changes the version
#
# ynh_install_nodejs will install the version of node provided as argument by using n.
#
# usage: ynh_install_nodejs [nodejs_version]
# | arg: nodejs_version - Version of node to install.
#        If possible, prefer to use major version number (e.g. 8 instead of 8.10.0).
#        The crontab will handle the update of minor versions when needed.
ynh_install_nodejs () {
	# Use n, https://github.com/tj/n to manage the nodejs versions
	nodejs_version="$1"

	# Create $n_install_dir
	mkdir -p "$n_install_dir"

	# Load n path in PATH
	CLEAR_PATH="$n_install_dir/bin:$PATH"
	# Remove /usr/local/bin in PATH in case of node prior installation
	PATH=$(echo $CLEAR_PATH | sed 's@/usr/local/bin:@@')

	# Move an existing node binary, to avoid to block n.
	test -x /usr/bin/node && mv /usr/bin/node /usr/bin/node_n
	test -x /usr/bin/npm && mv /usr/bin/npm /usr/bin/npm_n

	# If n is not previously setup, install it
	if ! test $(n --version > /dev/null 2>&1)
	then
		ynh_install_n
	fi

	# Modify the default N_PREFIX in n script
	ynh_replace_string "^N_PREFIX=\${N_PREFIX-.*}$" "N_PREFIX=\${N_PREFIX-$N_PREFIX}" "$n_install_dir/bin/n"

	# Restore /usr/local/bin in PATH
	PATH=$CLEAR_PATH

	# And replace the old node binary.
	test -x /usr/bin/node_n && mv /usr/bin/node_n /usr/bin/node
	test -x /usr/bin/npm_n && mv /usr/bin/npm_n /usr/bin/npm

	# Install the requested version of nodejs
	n $nodejs_version

	# Find the last "real" version for this major version of node.
	real_nodejs_version=$(find $node_version_path/$nodejs_version* -maxdepth 0 | sort --version-sort | tail --lines=1)
	real_nodejs_version=$(basename $real_nodejs_version)

	# Create a symbolic link for this major version if the file doesn't already exist
	if [ ! -e "$node_version_path/$nodejs_version" ]
	then
		ln --symbolic --force --no-target-directory $node_version_path/$real_nodejs_version $node_version_path/$nodejs_version
	fi

	# Store the ID of this app and the version of node requested for it
	echo "$YNH_APP_ID:$nodejs_version" | tee --append "$n_install_dir/ynh_app_version"

	# Store nodejs_version into the config of this app
	ynh_app_setting_set $app nodejs_version $nodejs_version

	# Build the update script and set the cronjob
	ynh_cron_upgrade_node

	ynh_use_nodejs
}

# Remove the version of node used by the app.
#
# This helper will check if another app uses the same version of node,
# if not, this version of node will be removed.
# If no other app uses node, n will be also removed.
#
# usage: ynh_remove_nodejs
ynh_remove_nodejs () {
	nodejs_version=$(ynh_app_setting_get $app nodejs_version)

	# Remove the line for this app
	sed --in-place "/$YNH_APP_ID:$nodejs_version/d" "$n_install_dir/ynh_app_version"

	# If no other app uses this version of nodejs, remove it.
	if ! grep --quiet "$nodejs_version" "$n_install_dir/ynh_app_version"
	then
		$n_install_dir/bin/n rm $nodejs_version
	fi

	# If no other app uses n, remove n
	if [ ! -s "$n_install_dir/ynh_app_version" ]
	then
		ynh_secure_remove "$n_install_dir"
		ynh_secure_remove "/usr/local/n"
	fi
}

# Set a cron design to update your node versions
#
# [internal]
#
# This cron will check and update all minor node versions used by your apps.
#
# usage: ynh_cron_upgrade_node
ynh_cron_upgrade_node () {
	# Build the update script
	cat > "$n_install_dir/node_update.sh" << EOF
#!/bin/bash
version_path="$node_version_path"
n_install_dir="$n_install_dir"
# Log the date
date
# List all real installed version of node
all_real_version="\$(find \$version_path/* -maxdepth 0 -type d | sed "s@\$version_path/@@g")"
# Keep only the major version number of each line
all_real_version=\$(echo "\$all_real_version" | sed 's/\..*\$//')
# Remove double entries
all_real_version=\$(echo "\$all_real_version" | sort --unique)
# Read each major version
while read version
do
	echo "Update of the version \$version"
	sudo \$n_install_dir/bin/n \$version
	# Find the last "real" version for this major version of node.
	real_nodejs_version=\$(find \$version_path/\$version* -maxdepth 0 | sort --version-sort | tail --lines=1)
	real_nodejs_version=\$(basename \$real_nodejs_version)
	# Update the symbolic link for this version
	sudo ln --symbolic --force --no-target-directory \$version_path/\$real_nodejs_version \$version_path/\$version
done <<< "\$(echo "\$all_real_version")"
EOF

	chmod +x "$n_install_dir/node_update.sh"

	# Build the cronjob
	cat > "/etc/cron.daily/node_update" << EOF
#!/bin/bash
$n_install_dir/node_update.sh >> $n_install_dir/node_update.log
EOF

	chmod +x "/etc/cron.daily/node_update"
}

#=================================================

# Start or restart a service and follow its booting
#
# usage: ynh_check_starting "Line to match" [Log file] [Timeout] [Service name]
#
# | arg: Line to match - The line to find in the log to attest the service have finished to boot.
# | arg: Log file - The log file to watch
# | arg: Service name
# /var/log/$app/$app.log will be used if no other log is defined.
# | arg: Timeout - The maximum time to wait before ending the watching. Defaut 300 seconds.
ynh_check_starting () {
	local line_to_match="$1"
	local service_name="${4:-$app}"
	local app_log="${2:-/var/log/$service_name/$service_name.log}"
	local timeout=${3:-300}

	ynh_clean_check_starting () {
		# Stop the execution of tail.
		kill -s 15 $pid_tail 2>&1
		ynh_secure_remove "$templog" 2>&1
	}

	echo "Starting of $service_name" >&2
	systemctl stop $service_name
	local templog="$(mktemp)"
	# Following the starting of the app in its log
	tail -F -n0 "$app_log" > "$templog" &
	# Get the PID of the tail command
	local pid_tail=$!
	systemctl start $service_name

	local i=0
	for i in `seq 1 $timeout`
	do
		# Read the log until the sentence is found, that means the app finished to start. Or run until the timeout
		if grep --quiet "$line_to_match" "$templog"
		then
			echo "The service $service_name has correctly started." >&2
			break
		fi
		echo -n "." >&2
		sleep 1
	done
	if [ $i -eq $timeout ]
	then
		echo "The service $service_name didn't fully started before the timeout." >&2
	fi

	echo ""
	ynh_clean_check_starting
}

#=================================================


# EXEC_LOGIN_AS Helper

# Execute a command as another user with login
# (hence in user home dir, with prior loading of .profile, etc.)
# usage: exec_login_as USER COMMAND [ARG ...]
exec_login_as() {
  local user=$1
  shift 1
  exec_as $user --login "$@"
}
# Execute a command as another user
# usage: exec_as USER COMMAND [ARG ...]
exec_as() {
  local user=$1
  shift 1

  if [[ $user = $(whoami) ]]; then
    eval "$@"
  else
    sudo -u "$user" "$@"
  fi
}
