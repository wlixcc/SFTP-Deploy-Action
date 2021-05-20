#!/bin/sh -l

#set -e at the top of your script will make the script exit with an error whenever an error occurs (and is not explicitly handled)
set -eu

echo 'Connecting to SSH server and creating directory..'

ssh -o StrictHostKeyChecking=no -p $3 -i $TEMP_SSH_PRIVATE_KEY_FILE $1@$2 mkdir -p $6

echo 'Connection to SSH server and directory creation finished successfully!'

echo 'Starting file transfer..'
# create a temporary file containing sftp commands
printf "%s" "put -r $5 $6" >$TEMP_SFTP_FILE
#-o StrictHostKeyChecking=no to avoid "Host key verification failed".
sshpass -p $4 sftp -b $TEMP_SFTP_FILE -P $3 $7 -o StrictHostKeyChecking=no $1@$2

echo 'File transfer finished successfully!'
exit 0

