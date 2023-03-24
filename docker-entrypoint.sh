#!/bin/bash

cd ~
sudo chown debian:debian ~/backup
mkdir sshfs
echo ${SSH_PASSWORD} | sshfs -o password_stdin -o IdentityFile=~/.ssh/id_rsa ${SSH_USER_NAME}@${SSH_HOST_NAME}:/ ~/sshfs

sudo -E perl -pi.orig -e 's/\$\{?SSH_DIR\}?/$ENV{SSH_DIR}/' /etc/rsnapshot.conf
sudo -E perl -pi.orig -e 's/\$\{?MYSQL_DB_NAME\}?/$ENV{MYSQL_DB_NAME}/' /etc/rsnapshot.conf
sudo -E perl -pi.orig -e 's/\$\{?BACKUP_NAME\}?/$ENV{BACKUP_NAME}/' /etc/rsnapshot.conf

sudo -E perl -pi.orig -e 's/\$\{?MYSQL_HOST_NAME\}?/$ENV{MYSQL_HOST_NAME}/' /etc/mysql/conf.d/mysqldump.cnf
sudo -E perl -pi.orig -e 's/\$\{?MYSQL_DB_NAME\}?/$ENV{MYSQL_DB_NAME}/' /etc/mysql/conf.d/mysqldump.cnf
sudo -E perl -pi.orig -e 's/\$\{?MYSQL_USER_NAME\}?/$ENV{MYSQL_USER_NAME}/' /etc/mysql/conf.d/mysqldump.cnf
sudo -E perl -pi.orig -e 's/\$\{?MYSQL_PASSWORD\}?/$ENV{MYSQL_PASSWORD}/' /etc/mysql/conf.d/mysqldump.cnf

sudo service cron start
#/bin/bash
while true; do sleep 60; done
