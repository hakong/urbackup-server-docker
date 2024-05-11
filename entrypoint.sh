#!/bin/bash
set -e
# Copy www-folder back, if folder is bind-mounted
cp -R /web-backup/* /usr/share/urbackup
# Specifying backup-folder location
echo "/backups" > /var/urbackup/backupfolder
# Giving the user and group "urbackup" the provided UID/GID
if [[ $PUID != "" ]]
then
	usermod -u $PUID -o urbackup
else
	usermod -u 101 -o urbackup
fi
if [[ $PGID != "" ]]
then
	groupmod -g $PGID -o urbackup
else
	groupmod -g 101 -o urbackup
fi

# Check if /backups and /var/urbackup is writable by urbackup user and conditionally chown
su -s /bin/bash -c "test -w /backups" urbackup || chown urbackup:urbackup /backups
su -s /bin/bash -c "test -w /var/urbackup" urbackup || chown urbackup:urbackup /var/urbackup

exec urbackupsrv "$@"
