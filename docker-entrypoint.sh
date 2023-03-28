#!/bin/bash

cd ~
sudo chown debian:debian ~/backup
mkdir sshfs

sudo -E perl -pi.orig -e 's/\$\{?SSH_DIR\}?/$ENV{SSH_DIR}/' /etc/rsnapshot.conf
sudo -E perl -pi.orig -e 's/\$\{?MYSQL_DB_NAME\}?/$ENV{MYSQL_DB_NAME}/' /etc/rsnapshot.conf
sudo -E perl -pi.orig -e 's/\$\{?BACKUP_NAME\}?/$ENV{BACKUP_NAME}/' /etc/rsnapshot.conf

sudo -E perl -pi.orig -e 's/\$\{?MYSQL_HOST_NAME\}?/$ENV{MYSQL_HOST_NAME}/' /etc/mysql/conf.d/mysqldump.cnf
sudo -E perl -pi.orig -e 's/\$\{?MYSQL_DB_NAME\}?/$ENV{MYSQL_DB_NAME}/' /etc/mysql/conf.d/mysqldump.cnf
sudo -E perl -pi.orig -e 's/\$\{?MYSQL_USER_NAME\}?/$ENV{MYSQL_USER_NAME}/' /etc/mysql/conf.d/mysqldump.cnf
sudo -E perl -pi.orig -e 's/\$\{?MYSQL_PASSWORD\}?/$ENV{MYSQL_PASSWORD}/' /etc/mysql/conf.d/mysqldump.cnf

sudo -E perl -pi.orig -e "s/dc_eximconfig_configtype='local'/dc_eximconfig_configtype='satellite'/" /etc/exim4/update-exim4.conf.conf
sudo -E perl -pi.orig -e "s/dc_smarthost=''/dc_smarthost='$MAIL_SMARTHOST'/" /etc/exim4/update-exim4.conf.conf
sudo -E perl -pi.orig -e "s/dc_smarthost=''/dc_smarthost='$MAIL_SMARTHOST'/" /etc/exim4/update-exim4.conf.conf

sudo update-exim4.conf

sudo -E perl -pi.orig -e 's/\$\{?SSH_HOST_NAME\}?/$ENV{SSH_HOST_NAME}/' /home/debian/.ssh/config
sudo -E perl -pi.orig -e 's/\$\{?SSH_USER_NAME\}?/$ENV{SSH_USER_NAME}/' /home/debian/.ssh/config

sudo -E perl -pi.orig -e 's/\$\{?ADMIN_EMAIL\}?/$ENV{ADMIN_EMAIL}/' /etc/cron.d/rsnapshot
sudo -E perl -pi.orig -e 's/\$\{?SSH_USER_NAME\}?/$ENV{SSH_USER_NAME}/' /etc/cron.d/rsnapshot
sudo -E perl -pi.orig -e 's/\$\{?SSH_HOST_NAME\}?/$ENV{SSH_HOST_NAME}/' /etc/cron.d/rsnapshot

# save environment so cron can read it
printenv > /tmp/environment
sudo mv /tmp/environment /etc/environment
chown root:root /etc/environment

sudo cron -f
#/bin/bash
