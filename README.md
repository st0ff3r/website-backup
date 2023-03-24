# website-backup
docker image to backup remote hosted website with mysql

mounts the remote website host via sshfs and runs rsnapshots daily and monthly
runs mysqldump and save data as well

set up by moving docker-compose.yml.example to docker-compose.yml and fill out usernames and passwords

put ssh keys in ssh/id_rsa and ssh/id_rsa.pub

saves backup to backup folder in current directory
