#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================
# Workaround for backward compatibility
unset N_PREFIX
NODEJS_VERSION="8"

#=================================================
#=================================================
# TESTING
#=================================================
#=================================================

ynh_fpm_config () {
	finalphpconf="/etc/php5/fpm/pool.d/$app.conf"
	ynh_backup_if_checksum_is_different "$finalphpconf" 1
	sudo cp ../conf/php-fpm.conf "$finalphpconf"
	ynh_replace_string "__NAMETOCHANGE__" "$app" "$finalphpconf"
	ynh_replace_string "__FINALPATH__" "$final_path" "$finalphpconf"
	ynh_replace_string "__USER__" "$app" "$finalphpconf"
	sudo chown root: "$finalphpconf"
	ynh_store_file_checksum "$finalphpconf"

	if [ -e "../conf/php-fpm.ini" ]
	then
		finalphpini="/etc/php5/fpm/conf.d/20-$app.ini"
		ynh_backup_if_checksum_is_different "$finalphpini" 1
		sudo cp ../conf/php-fpm.ini "$finalphpini"
		sudo chown root: "$finalphpini"
		ynh_store_file_checksum "$finalphpini"
	fi

	sudo systemctl reload php5-fpm
}

ynh_remove_fpm_config () {
	ynh_secure_remove "/etc/php5/fpm/pool.d/$app.conf"
	ynh_secure_remove "/etc/php5/fpm/conf.d/20-$app.ini"
	sudo systemctl reload php5-fpm
}

ynh_nginx_config () {
	finalnginxconf="/etc/nginx/conf.d/$domain.d/$app.conf"
	ynh_backup_if_checksum_is_different "$finalnginxconf" 1
	sudo cp ../conf/nginx.conf "$finalnginxconf"

	# To avoid a break by set -u, use a void substitution ${var:-}. If the variable is not set, it's simply set with an empty variable.
	# Substitute in a nginx config file only if the variable is not empty
	if test -n "${path_url:-}"; then
		ynh_replace_string "__PATH__" "$path_url" "$finalnginxconf"
	fi
	if test -n "${domain:-}"; then
		ynh_replace_string "__DOMAIN__" "$domain" "$finalnginxconf"
	fi
	if test -n "${port:-}"; then
		ynh_replace_string "__PORT__" "$port" "$finalnginxconf"
	fi
	if test -n "${app:-}"; then
		ynh_replace_string "__NAME__" "$app" "$finalnginxconf"
	fi
	if test -n "${final_path:-}"; then
		ynh_replace_string "__FINALPATH__" "$final_path" "$finalnginxconf"
	fi
	ynh_store_file_checksum "$finalnginxconf"

	sudo systemctl reload nginx
}

ynh_remove_nginx_config () {
	ynh_secure_remove "/etc/nginx/conf.d/$domain.d/$app.conf"
	sudo systemctl reload nginx
}

ynh_systemd_config () {
	finalsystemdconf="/etc/systemd/system/$app.service"
	ynh_backup_if_checksum_is_different "$finalsystemdconf" 1
	sudo cp ../conf/systemd.service "$finalsystemdconf"

	# To avoid a break by set -u, use a void substitution ${var:-}. If the variable is not set, it's simply set with an empty variable.
	# Substitute in a nginx config file only if the variable is not empty
	if test -n "${final_path:-}"; then
		ynh_replace_string "__FINALPATH__" "$final_path" "$finalsystemdconf"
	fi
	if test -n "${app:-}"; then
		ynh_replace_string "__APP__" "$app" "$finalsystemdconf"
	fi
        ynh_replace_string "__PORT__" "$port" "$finalsystemdconf"
	ynh_store_file_checksum "$finalsystemdconf"

	sudo chown root: "$finalsystemdconf"
	sudo systemctl enable $app
	sudo systemctl daemon-reload
}

ynh_remove_systemd_config () {
	finalsystemdconf="/etc/systemd/system/$app.service"
	if [ -e "$finalsystemdconf" ]; then
		sudo systemctl stop $app
		sudo systemctl disable $app
		ynh_secure_remove "$finalsystemdconf"
	fi
}

#=================================================
#=================================================

#=================================================
# CHECKING
#=================================================

CHECK_USER () {	# Vérifie la validité de l'user admin
# $1 = Variable de l'user admin.
	ynh_user_exists "$1" || ynh_die "Wrong user"
}

CHECK_DOMAINPATH () {	# Vérifie la disponibilité du path et du domaine.
	if sudo yunohost app --help | grep --quiet url-available
	then
		# Check availability of a web path
		ynh_webpath_available $domain $path_url
		# Register/book a web path for an app
		ynh_webpath_register $app $domain $path_url
	else
		# Use the legacy command
		sudo yunohost app checkurl $domain$path_url -a $app
	fi
}

CHECK_FINALPATH () {	# Vérifie que le dossier de destination n'est pas déjà utilisé.
	final_path=/var/www/$app
	test ! -e "$final_path" || ynh_die "This path already contains a folder"
}

#=================================================
# DISPLAYING
#=================================================

NO_PRINT () {	# Supprime l'affichage dans stdout pour la commande en argument.
	set +x
	$@
	set -x
}

WARNING () {	# Écrit sur le canal d'erreur pour passer en warning.
	$@ >&2
}

SUPPRESS_WARNING () {	# Force l'écriture sur la sortie standard
	$@ 2>&1
}

QUIET () {	# Redirige la sortie standard dans /dev/null
	$@ > /dev/null
}

ALL_QUIET () {	# Redirige la sortie standard et d'erreur dans /dev/null
	$@ > /dev/null 2>&1
}

#=================================================
# BACKUP
#=================================================

# Restore a previous backup if the upgrade process failed
#
# usage:
# ynh_backup_before_upgrade
# ynh_clean_setup () {
# 	ynh_backup_after_failed_upgrade
# }
# ynh_abort_if_errors
#
ynh_backup_after_failed_upgrade () {
	echo "Upgrade failed." >&2
	app_bck=${app//_/-}	# Replace all '_' by '-'
    # Check if a existing backup can be found before remove and restore the application.
	if sudo yunohost backup list | grep -q $app_bck-pre-upgrade$backup_number
    then
    	# Remove the application then restore it
		sudo yunohost app remove $app
        # Restore the backup if the upgrade failed
		sudo yunohost backup restore --ignore-hooks $app_bck-pre-upgrade$backup_number --apps $app --force
		ynh_die "The app was restored to the way it was before the failed upgrade."
	fi
}

# Make a backup in case of failed upgrade
#
# usage:
# ynh_backup_before_upgrade
# ynh_clean_setup () {
# 	ynh_backup_after_failed_upgrade
# }
# ynh_abort_if_errors
#
ynh_backup_before_upgrade () {
	backup_number=1
	old_backup_number=2
	app_bck=${app//_/-}	# Replace all '_' by '-'
    # Check if a backup already exist with the prefix 1.
	if sudo yunohost backup list | grep -q $app_bck-pre-upgrade1
    then
        # Prefix become 2 to preserve the previous backup
		backup_number=2
		old_backup_number=1
	fi

	# Create another backup
	sudo yunohost backup create --ignore-hooks --apps $app --name $app_bck-pre-upgrade$backup_number
	if [ "$?" -eq 0 ]
    then
       	# If the backup succedded, remove the previous backup
		if sudo yunohost backup list | grep -q $app_bck-pre-upgrade$old_backup_number
        then
            # Remove the previous backup only if it exists
			sudo yunohost backup delete $app_bck-pre-upgrade$old_backup_number > /dev/null
		fi
	else
		ynh_die "Backup failed, the upgrade process was aborted."
	fi
}


HUMAN_SIZE () {	# Transforme une taille en Ko en une taille lisible pour un humain
	human=$(numfmt --to=iec --from-unit=1K $1)
	echo $human
}

CHECK_SIZE () {	# Vérifie avant chaque backup que l'espace est suffisant
	file_to_analyse=$1
	backup_size=$(sudo du --summarize "$file_to_analyse" | cut -f1)
	free_space=$(sudo df --output=avail "/home/yunohost.backup" | sed 1d)

	if [ $free_space -le $backup_size ]
	then
		WARNING echo "Espace insuffisant pour sauvegarder $file_to_analyse."
		WARNING echo "Espace disponible: $(HUMAN_SIZE $free_space)"
		ynh_die "Espace nécessaire: $(HUMAN_SIZE $backup_size)"
	fi
}

# Ce helper est temporaire et sert de remplacement à la véritable fonction ynh_restore_file. Le temps qu'elle arrive...
ynh_restore_file () {
	if [ -f "$1" ]; then
		ynh_die "There is already a file at this path: $1"
	fi
	sudo cp -a "${YNH_APP_BACKUP_DIR}$1" "$1"
}

#=================================================
# PACKAGE CHECK BYPASSING...
#=================================================

IS_PACKAGE_CHECK () {	# Détermine une exécution en conteneur (Non testé)
	return $(uname -n | grep -c 'pchecker_lxc')
}

sudo_path () {
	sudo env "PATH=$PATH" $@
}

# INFOS
# n (Node version management) utilise la variable PATH pour stocker le path de la version de node à utiliser.
# C'est ainsi qu'il change de version
# ynh_install_nodejs installe la version de nodejs demandée en argument, avec n
# ynh_use_nodejs active une version de nodejs dans le script courant
# 3 variables sont mises à disposition, et 2 sont stockées dans la config de l'app
# - nodejs_path: Le chemin absolu de cette version de node
# Utilisé pour des appels directs à node.
# - nodejs_version: Simplement le numéro de version de nodejs pour cette application
# - nodejs_use_version: Un alias pour charger une version de node dans le shell courant.
# Utilisé pour démarrer un service ou un script qui utilise node ou npm
# Dans ce cas, c'est $PATH qui contient le chemin de la version de node. Il doit être propagé sur les autres shell si nécessaire.

n_install_dir="/opt/node_n"
node_version_path="/usr/local/n/versions/node"
ynh_use_nodejs () {
	nodejs_version=$(ynh_app_setting_get $app nodejs_version)

	load_n_path="[[ :$PATH: == *\":$n_install_dir/bin:\"* ]] || PATH=\"$n_install_dir/bin:$PATH\""

	nodejs_use_version="$n_install_dir/bin/n -q $nodejs_version"

	# "Load" a version of node
	eval $load_n_path; $nodejs_use_version

	# Get the absolute path of this version of node
	nodejs_path="$(n bin $nodejs_version)"

	# Make an alias for node use
	ynh_node_exec="eval $load_n_path; n use $nodejs_version"
}

ynh_install_nodejs () {
	# Use n, https://github.com/tj/n to manage the nodejs versions
	nodejs_version="$1"
	local n_install_script="https://git.io/n-install"

	# Create $n_install_dir
	mkdir -p "$n_install_dir"

	# Load n path in PATH
	CLEAR_PATH="$n_install_dir/bin:$PATH"
	# Remove /usr/local/bin in PATH in case of node has already setup.
	PATH=$(echo $CLEAR_PATH | sed 's@/usr/local/bin:@@')

	# Move an existing node binary, to avoid to block n.
	test -x /usr/bin/node && mv /usr/bin/node /usr/bin/node_n
	test -x /usr/bin/npm && mv /usr/bin/npm /usr/bin/npm_n

	# If n is not previously setup, install it
	n --version > /dev/null 2>&1 || \
	( echo "Installation of N - Node.js version management" >&2; \
	curl -sL $n_install_script | N_PREFIX="$n_install_dir" bash -s -- -y - )

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

	# Create a symbolic link for this major version
	ln --symbolic --force --no-target-directory $node_version_path/$real_nodejs_version $node_version_path/$nodejs_version

	# Store the ID of this app and the version of node requested for it
	echo "$YNH_APP_ID:$nodejs_version" | tee --append "$n_install_dir/ynh_app_version"

	# Store nodejs_version into the config of this app
	ynh_app_setting_set $app nodejs_version $nodejs_version

	# Build the update script and set the cronjob
	ynh_cron_upgrade_node

	ynh_use_nodejs
}

ynh_remove_nodejs () {
	ynh_use_nodejs

	# Remove the line for this app
	sed --in-place "/$YNH_APP_ID:$nodejs_version/d" "$n_install_dir/ynh_app_version"

	# If none another app uses this version of nodejs, remove it.
	if ! grep --quiet "$nodejs_version" "$n_install_dir/ynh_app_version"
	then
		n rm $nodejs_version
	fi

	# If none another app uses n, remove n
	if [ ! -s "$n_install_dir/ynh_app_version" ]
	then
		ynh_secure_remove "$n_install_dir"
		ynh_secure_remove "/usr/local/n"
		sed --in-place "/N_PREFIX/d" /root/.bashrc
	fi
}

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
#=================================================
# FUTUR YNH HELPERS
#=================================================
# Importer ce fichier de fonction avant celui des helpers officiel
# Ainsi, les officiels prendront le pas sur ceux-ci le cas échéant
#=================================================

# Normalize the url path syntax
# Handle the slash at the beginning of path and its absence at ending
# Return a normalized url path
#
# example: url_path=$(ynh_normalize_url_path $url_path)
#          ynh_normalize_url_path example -> /example
#          ynh_normalize_url_path /example -> /example
#          ynh_normalize_url_path /example/ -> /example
#          ynh_normalize_url_path / -> /
#
# usage: ynh_normalize_url_path path_to_normalize
# | arg: url_path_to_normalize - URL path to normalize before using it
ynh_normalize_url_path () {
	path_url=$1
	test -n "$path_url" || ynh_die "ynh_normalize_url_path expect a URL path as first argument and received nothing."
	if [ "${path_url:0:1}" != "/" ]; then    # If the first character is not a /
		path_url="/$path_url"    # Add / at begin of path variable
	fi
	if [ "${path_url:${#path_url}-1}" == "/" ] && [ ${#path_url} -gt 1 ]; then    # If the last character is a / and that not the only character.
		path_url="${path_url:0:${#path_url}-1}"	# Delete the last character
	fi
	echo $path_url
}

# Check if a mysql user exists
#
# usage: ynh_mysql_user_exists user
# | arg: user - the user for which to check existence
function ynh_mysql_user_exists()
{
   local user=$1
   if [[ -z $(ynh_mysql_execute_as_root "SELECT User from mysql.user WHERE User = '$user';") ]]
   then
      return 1
   else
      return 0
   fi
}

# Create a database, an user and its password. Then store the password in the app's config
#
# After executing this helper, the password of the created database will be available in $db_pwd
# It will also be stored as "mysqlpwd" into the app settings.
#
# usage: ynh_mysql_setup_db user name [pwd]
# | arg: user - Owner of the database
# | arg: name - Name of the database
# | arg: pwd - Password of the database. If not given, a password will be generated
ynh_mysql_setup_db () {
	local db_user="$1"
	local db_name="$2"
	local new_db_pwd=$(ynh_string_random)	# Generate a random password
	db_pwd="${3:-$new_db_pwd}"
	ynh_mysql_create_db "$db_name" "$db_user" "$db_pwd"	# Create the database
	ynh_app_setting_set $app mysqlpwd $db_pwd	# Store the password in the app's config
}

# Remove a database if it exists, and the associated user
#
# usage: ynh_mysql_remove_db user name
# | arg: user - Owner of the database
# | arg: name - Name of the database
ynh_mysql_remove_db () {
	local db_user="$1"
	local db_name="$2"
	local mysql_root_password=$(sudo cat $MYSQL_ROOT_PWD_FILE)
	if mysqlshow -u root -p$mysql_root_password | grep -q "^| $db_name"; then	# Check if the database exists
		echo "Removing database $db_name" >&2
		ynh_mysql_drop_db $db_name	# Remove the database	
	else
		echo "Database $db_name not found" >&2
	fi

	# Remove mysql user if it exists
        if $(ynh_mysql_user_exists $db_user); then
		ynh_mysql_drop_user $db_user
	fi
}

# Correct the name given in argument for mariadb
#
# Avoid invalid name for your database
#
# Exemple: dbname=$(ynh_make_valid_dbid $app)
#
# usage: ynh_make_valid_dbid name
# | arg: name - name to correct
# | ret: the corrected name
ynh_sanitize_dbid () {
	dbid=${1//[-.]/_}	# We should avoid having - and . in the name of databases. They are replaced by _
	echo $dbid
}

# Manage a fail of the script
#
# Print a warning to inform that the script was failed
# Execute the ynh_clean_setup function if used in the app script
#
# usage of ynh_clean_setup function
# This function provide a way to clean some residual of installation that not managed by remove script.
# To use it, simply add in your script:
# ynh_clean_setup () {
#        instructions...
# }
# This function is optionnal.
#
# Usage: ynh_exit_properly is used only by the helper ynh_abort_if_errors.
# You must not use it directly.
ynh_exit_properly () {
	exit_code=$?
	if [ "$exit_code" -eq 0 ]; then
			exit 0	# Exit without error if the script ended correctly
	fi

	trap '' EXIT	# Ignore new exit signals
	set +eu	# Do not exit anymore if a command fail or if a variable is empty

	echo -e "!!\n  $app's script has encountered an error. Its execution was cancelled.\n!!" >&2

	if type -t ynh_clean_setup > /dev/null; then	# Check if the function exist in the app script.
		ynh_clean_setup	# Call the function to do specific cleaning for the app.
	fi

	ynh_die	# Exit with error status
}

# Exit if an error occurs during the execution of the script.
#
# Stop immediatly the execution if an error occured or if a empty variable is used.
# The execution of the script is derivate to ynh_exit_properly function before exit.
#
# Usage: ynh_abort_if_errors
ynh_abort_if_errors () {
	set -eu	# Exit if a command fail, and if a variable is used unset.
	trap ynh_exit_properly EXIT	# Capturing exit signals on shell script
}

# Define and install dependencies with a equivs control file
# This helper can/should only be called once per app
#
# usage: ynh_install_app_dependencies dep [dep [...]]
# | arg: dep - the package name to install in dependence
ynh_install_app_dependencies () {
    dependencies=$@
    manifest_path="../manifest.json"
    if [ ! -e "$manifest_path" ]; then
    	manifest_path="../settings/manifest.json"	# Into the restore script, the manifest is not at the same place
    fi
    version=$(sudo grep '\"version\": ' "$manifest_path" | cut -d '"' -f 4)	# Retrieve the version number in the manifest file.
    dep_app=${app//_/-}	# Replace all '_' by '-'

    if ynh_package_is_installed "${dep_app}-ynh-deps"; then
		echo "A package named ${dep_app}-ynh-deps is already installed" >&2
    else
        cat > ./${dep_app}-ynh-deps.control << EOF	# Make a control file for equivs-build
Section: misc
Priority: optional
Package: ${dep_app}-ynh-deps
Version: ${version}
Depends: ${dependencies// /, }
Architecture: all
Description: Fake package for ${app} (YunoHost app) dependencies
 This meta-package is only responsible of installing its dependencies.
EOF
        ynh_package_install_from_equivs ./${dep_app}-ynh-deps.control \
            || ynh_die "Unable to install dependencies"	# Install the fake package and its dependencies
        ynh_app_setting_set $app apt_dependencies $dependencies
    fi
}

# Remove fake package and its dependencies
#
# Dependencies will removed only if no other package need them.
#
# usage: ynh_remove_app_dependencies
ynh_remove_app_dependencies () {
    dep_app=${app//_/-}	# Replace all '_' by '-'
    ynh_package_autoremove ${dep_app}-ynh-deps	# Remove the fake package and its dependencies if they not still used.
}

# Use logrotate to manage the logfile
#
# usage: ynh_use_logrotate [logfile]
# | arg: logfile - absolute path of logfile
#
# If no argument provided, a standard directory will be use. /var/log/${app}
# You can provide a path with the directory only or with the logfile.
# /parentdir/logdir/
# /parentdir/logdir/logfile.log
#
# It's possible to use this helper several times, each config will added to same logrotate config file.
ynh_use_logrotate () {
	if [ "$#" -gt 0 ]; then
		if [ "$(echo ${1##*.})" == "log" ]; then	# Keep only the extension to check if it's a logfile
			logfile=$1	# In this case, focus logrotate on the logfile
		else
			logfile=$1/.log	# Else, uses the directory and all logfile into it.
		fi
	else
		logfile="/var/log/${app}/*.log" # Without argument, use a defaut directory in /var/log
	fi
	cat > ./${app}-logrotate << EOF	# Build a config file for logrotate
$logfile {
		# Rotate if the logfile exceeds 100Mo
	size 100M
		# Keep 12 old log maximum
	rotate 12
		# Compress the logs with gzip
	compress
		# Compress the log at the next cycle. So keep always 2 non compressed logs
	delaycompress
		# Copy and truncate the log to allow to continue write on it. Instead of move the log.
	copytruncate
		# Do not do an error if the log is missing
	missingok
		# Not rotate if the log is empty
	notifempty
		# Keep old logs in the same dir
	noolddir
}
EOF
	sudo mkdir -p $(dirname "$logfile")	# Create the log directory, if not exist
	cat ${app}-logrotate | sudo tee -a /etc/logrotate.d/$app > /dev/null	# Append this config to the others for this app. If a config file already exist
}

# Remove the app's logrotate config.
#
# usage: ynh_remove_logrotate
ynh_remove_logrotate () {
	if [ -e "/etc/logrotate.d/$app" ]; then
		sudo rm "/etc/logrotate.d/$app"
	fi
}

# Find a free port and return it
#
# example: port=$(ynh_find_port 8080)
#
# usage: ynh_find_port begin_port
# | arg: begin_port - port to start to search
ynh_find_port () {
	port=$1
	test -n "$port" || ynh_die "The argument of ynh_find_port must be a valid port."
	while netcat -z 127.0.0.1 $port       # Check if the port is free
	do
		port=$((port+1))	# Else, pass to next port
	done
	echo $port
}

# Create a system user
#
# usage: ynh_system_user_create user_name [home_dir]
# | arg: user_name - Name of the system user that will be create
# | arg: home_dir - Path of the home dir for the user. Usually the final path of the app. If this argument is omitted, the user will be created without home
ynh_system_user_create () {
	if ! ynh_system_user_exists "$1"	# Check if the user exists on the system
	then	# If the user doesn't exist
		if [ $# -ge 2 ]; then	# If a home dir is mentioned
			user_home_dir="-d $2"
		else
			user_home_dir="--no-create-home"
		fi
		sudo useradd $user_home_dir --system --user-group $1 --shell /usr/sbin/nologin || ynh_die "Unable to create $1 system account"
	fi
}

# Delete a system user
#
# usage: ynh_system_user_delete user_name
# | arg: user_name - Name of the system user that will be create
ynh_system_user_delete () {
    if ynh_system_user_exists "$1"	# Check if the user exists on the system
    then
		echo "Remove the user $1" >&2
		sudo userdel $1
	else
		echo "The user $1 was not found" >&2
    fi
}

# Curl abstraction to help with POST requests to local pages (such as installation forms)
#
# $domain and $path_url should be defined externally (and correspond to the domain.tld and the /path (of the app?))
#
# example: ynh_local_curl "/install.php?installButton" "foo=$var1" "bar=$var2"
# 
# usage: ynh_local_curl "page_uri" "key1=value1" "key2=value2" ...
# | arg: page_uri    - Path (relative to $path_url) of the page where POST data will be sent
# | arg: key1=value1 - (Optionnal) POST key and corresponding value
# | arg: key2=value2 - (Optionnal) Another POST key and corresponding value
# | arg: ...         - (Optionnal) More POST keys and values
ynh_local_curl () {
	# Define url of page to curl
	full_page_url=https://localhost$path_url$1

	# Concatenate all other arguments with '&' to prepare POST data
	POST_data=""
	for arg in "${@:2}"
	do
		POST_data="${POST_data}${arg}&"
	done
	if [ -n "$POST_data" ]
	then
		# Add --data arg and remove the last character, which is an unecessary '&'
		POST_data="--data \"${POST_data::-1}\""
	fi

	# Curl the URL
	curl --silent --show-error -kL -H "Host: $domain" --resolve $domain:443:127.0.0.1 $POST_data "$full_page_url"
}

# Substitute/replace a string by another in a file
#
# usage: ynh_replace_string match_string replace_string target_file
# | arg: match_string - String to be searched and replaced in the file
# | arg: replace_string - String that will replace matches
# | arg: target_file - File in which the string will be replaced.
ynh_replace_string () {
	delimit=@
	match_string=${1//${delimit}/"\\${delimit}"}	# Escape the delimiter if it's in the string.
	replace_string=${2//${delimit}/"\\${delimit}"}
	workfile=$3

	sudo sed --in-place "s${delimit}${match_string}${delimit}${replace_string}${delimit}g" "$workfile"
}

# Remove a file or a directory securely
#
# usage: ynh_secure_remove path_to_remove
# | arg: path_to_remove - File or directory to remove
ynh_secure_remove () {
	path_to_remove=$1
	forbidden_path=" \
	/var/www \
	/home/yunohost.app"

	if [[ "$forbidden_path" =~ "$path_to_remove" \
		# Match all paths or subpaths in $forbidden_path
		|| "$path_to_remove" =~ ^/[[:alnum:]]+$ \
		# Match all first level paths from / (Like /var, /root, etc...)
		|| "${path_to_remove:${#path_to_remove}-1}" = "/" ]]
		# Match if the path finishes by /. Because it seems there is an empty variable
	then
		echo "Avoid deleting $path_to_remove." >&2
	else
		if [ -e "$path_to_remove" ]
		then
			sudo rm -R "$path_to_remove"
		else
			echo "$path_to_remove wasn't deleted because it doesn't exist." >&2
		fi
	fi
}

# Download, check integrity, uncompress and patch the source from app.src
#
# The file conf/app.src need to contains:
# 
# SOURCE_URL=Address to download the app archive
# SOURCE_SUM=Control sum
# # (Optional) Programm to check the integrity (sha256sum, md5sum$YNH_EXECUTION_DIR/...)
# # default: sha256
# SOURCE_SUM_PRG=sha256
# # (Optional) Archive format
# # default: tar.gz
# SOURCE_FORMAT=tar.gz
# # (Optional) Put false if source are directly in the archive root
# # default: true
# SOURCE_IN_SUBDIR=false
# # (Optionnal) Name of the local archive (offline setup support)
# # default: ${src_id}.${src_format}
# SOURCE_FILENAME=example.tar.gz 
#
# Details:
# This helper download sources from SOURCE_URL if there is no local source
# archive in /opt/yunohost-apps-src/APP_ID/SOURCE_FILENAME
# 
# Next, it check the integrity with "SOURCE_SUM_PRG -c --status" command.
# 
# If it's ok, the source archive will be uncompress in $dest_dir. If the
# SOURCE_IN_SUBDIR is true, the first level directory of the archive will be
# removed.
#
# Finally, patches named sources/patches/${src_id}-*.patch and extra files in
# sources/extra_files/$src_id will be applyed to dest_dir
#
#
# usage: ynh_setup_source dest_dir [source_id]
# | arg: dest_dir  - Directory where to setup sources
# | arg: source_id - Name of the app, if the package contains more than one app
YNH_EXECUTION_DIR="."
ynh_setup_source () {
    local dest_dir=$1
    local src_id=${2:-app} # If the argument is not given, source_id equal "app"

    # Load value from configuration file (see above for a small doc about this file
    # format)
    local src_url=$(grep 'SOURCE_URL=' "$YNH_EXECUTION_DIR/../conf/${src_id}.src" | cut -d= -f2-)
    local src_sum=$(grep 'SOURCE_SUM=' "$YNH_EXECUTION_DIR/../conf/${src_id}.src" | cut -d= -f2-)
    local src_sumprg=$(grep 'SOURCE_SUM_PRG=' "$YNH_EXECUTION_DIR/../conf/${src_id}.src" | cut -d= -f2-)
    local src_format=$(grep 'SOURCE_FORMAT=' "$YNH_EXECUTION_DIR/../conf/${src_id}.src" | cut -d= -f2-)
    local src_in_subdir=$(grep 'SOURCE_IN_SUBDIR=' "$YNH_EXECUTION_DIR/../conf/${src_id}.src" | cut -d= -f2-)
    local src_filename=$(grep 'SOURCE_FILENAME=' "$YNH_EXECUTION_DIR/../conf/${src_id}.src" | cut -d= -f2-)

    # Default value
    src_sumprg=${src_sumprg:-sha256sum}
    src_in_subdir=${src_in_subdir:-true}
    src_format=${src_format:-tar.gz}
    src_format=$(echo "$src_format" | tr '[:upper:]' '[:lower:]')
    if [ "$src_filename" = "" ] ; then
        src_filename="${src_id}.${src_format}"
    fi
    local local_src="/opt/yunohost-apps-src/${YNH_APP_ID}/${src_filename}"

    if test -e "$local_src"
    then    # Use the local source file if it is present
        cp $local_src $src_filename
    else    # If not, download the source
        wget -nv -O $src_filename $src_url
    fi

    # Check the control sum
    echo "${src_sum} ${src_filename}" | ${src_sumprg} -c --status \
        || ynh_die "Corrupt source"

    # Extract source into the app dir
    sudo mkdir -p "$dest_dir"
    if [ "$src_format" = "zip" ]
    then 
        # Zip format
        # Using of a temp directory, because unzip doesn't manage --strip-components
        if $src_in_subdir ; then
            local tmp_dir=$(mktemp -d)
            sudo unzip -quo $src_filename -d "$tmp_dir"
            sudo cp -a $tmp_dir/*/. "$dest_dir"
            ynh_secure_remove "$tmp_dir"
        else
            sudo unzip -quo $src_filename -d "$dest_dir"
        fi
    else
        local strip=""
        if $src_in_subdir ; then
            strip="--strip-components 1"
        fi
        if [[ "$src_format" =~ ^tar.gz|tar.bz2|tar.xz$ ]] ; then
            sudo tar -xf $src_filename -C "$dest_dir" $strip
        else
            ynh_die "Archive format unrecognized."
        fi
    fi

    # Apply patches
    if (( $(find $YNH_EXECUTION_DIR/../sources/patches/ -type f -name "${src_id}-*.patch" 2> /dev/null | wc -l) > "0" )); then
        local old_dir=$(pwd)
        (cd "$dest_dir" \
            && for p in $YNH_EXECUTION_DIR/../sources/patches/${src_id}-*.patch; do \
                sudo patch -p1 < $p; done) \
            || ynh_die "Unable to apply patches"
        cd $old_dir
    fi

    # Add supplementary files
    if test -e "$YNH_EXECUTION_DIR/../sources/extra_files/${src_id}"; then
        sudo cp -a $YNH_EXECUTION_DIR/../sources/extra_files/$src_id/. "$dest_dir"
    fi
}

# Check availability of a web path
#
# example: ynh_webpath_available some.domain.tld /coffee
#
# usage: ynh_webpath_available domain path
# | arg: domain - the domain/host of the url
# | arg: path - the web path to check the availability of
ynh_webpath_available () {
	local domain=$1
	local path=$2
	sudo yunohost domain url-available $domain $path
}

# Register/book a web path for an app
#
# example: ynh_webpath_register wordpress some.domain.tld /coffee
#
# usage: ynh_webpath_register app domain path
# | arg: app - the app for which the domain should be registered
# | arg: domain - the domain/host of the web path
# | arg: path - the web path to be registered
ynh_webpath_register () {
	local app=$1
	local domain=$2
	local path=$3
	sudo yunohost app register-url $app $domain $path
}

# Calculate and store a file checksum into the app settings
#
# $app should be defined when calling this helper
#
# usage: ynh_store_file_checksum file
# | arg: file - The file on which the checksum will performed, then stored.
ynh_store_file_checksum () {
	local checksum_setting_name=checksum_${1//[\/ ]/_}	# Replace all '/' and ' ' by '_'
	ynh_app_setting_set $app $checksum_setting_name $(sudo md5sum "$1" | cut -d' ' -f1)
}

# Verify the checksum and backup the file if it's different
# This helper is primarily meant to allow to easily backup personalised/manually 
# modified config files.
#
# $app should be defined when calling this helper
#
# usage: ynh_backup_if_checksum_is_different file
# | arg: file - The file on which the checksum test will be perfomed.
#
# | ret: Return the name a the backup file, or nothing
ynh_backup_if_checksum_is_different () {
	local file=$1
	local checksum_setting_name=checksum_${file//[\/ ]/_}	# Replace all '/' and ' ' by '_'
	local checksum_value=$(ynh_app_setting_get $app $checksum_setting_name)
	if [ -n "$checksum_value" ]
	then	# Proceed only if a value was stored into the app settings
		if ! echo "$checksum_value $file" | sudo md5sum -c --status
		then	# If the checksum is now different
			backup_file="/home/yunohost.conf/backup/$file.backup.$(date '+%Y%m%d.%H%M%S')"
			sudo mkdir -p "$(dirname "$backup_file")"
			sudo cp -a "$file" "$backup_file"	# Backup the current file
			echo "File $file has been manually modified since the installation or last upgrade. So it has been duplicated in $backup_file" >&2
			echo "$backup_file"	# Return the name of the backup file
		fi
	fi
}

# Find a free port and return it
#
# example: port=$(ynh_find_port 8080)
#
# usage: ynh_find_port begin_port
# | arg: begin_port - port to start to search
ynh_find_port () {
	port=$1
	test -n "$port" || ynh_die "The argument of ynh_find_port must be a valid port."
	while netcat -z 127.0.0.1 $port       # Check if the port is free
	do
		port=$((port+1))	# Else, pass to next port
	done
	echo $port
}
