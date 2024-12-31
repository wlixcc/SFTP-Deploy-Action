#!/bin/sh -l

#set -e at the top of your script will make the script exit with an error whenever an error occurs (and is not explicitly handled)
set -eu

TEMP_SSH_PRIVATE_KEY_FILE='../private_key.pem'
TEMP_SFTP_FILE='../sftp'

# 定义一个本地临时目录，用于 rsync 过滤后存放文件
RSYNC_LOCAL_DEST="../filtered_upload"

RSYNC_ARGS="${11}"

# 如果用户“未”设置 exclude（EXCLUDE_PATTERNS 为空），则直接进入原逻辑
if [ -z "$RSYNC_ARGS" ]; then
  echo "===> No rsync args provided, skip rsync filtering..."
else
  echo "===> rsync args detected, start rsync filtering..."

  # 先清理并创建该临时目录
  rm -rf "$RSYNC_LOCAL_DEST"
  mkdir -p "$RSYNC_LOCAL_DEST"

  # 6) 打印完整的 rsync 命令，方便调试
  echo "===> rsync command: rsync -av $RSYNC_ARGS $5 $RSYNC_LOCAL_DEST/"

  # 执行 rsync 命令
  rsync -av $RSYNC_ARGS $5 $RSYNC_LOCAL_DEST/

  # 将 $5 替换为过滤后的目录下的所有文件，这样后面原脚本里 put -r $5 $6 就无需改动其他地方
  set -- "$1" "$2" "$3" "$4" "$RSYNC_LOCAL_DEST/*" "$6" "$7" "$8" "$9" "${10}"

  echo "===> Done rsync filtering. Continue original script..."
fi

# make sure remote path is not empty
if [ -z "$6" ]; then
   echo 'remote_path is empty'
   exit 1
fi

# use password
if [ -n "${10}" ]; then
	echo 'use sshpass'

	if test $9 == "true";then
  		echo 'Start delete remote files'
		sshpass -p ${10} ssh -o StrictHostKeyChecking=no -p $3 $1@$2 rm -rf $6
	fi
	if test $7 = "true"; then
  		echo "Connection via sftp protocol only, skip the command to create a directory"
	else
 	 	echo 'Create directory if needed'
 	 	sshpass -p ${10} ssh -o StrictHostKeyChecking=no -p $3 $1@$2 mkdir -p $6
	fi

	echo 'SFTP Start'
	# create a temporary file containing sftp commands
	printf "%s" "put -r $5 $6" >$TEMP_SFTP_FILE
	#-o StrictHostKeyChecking=no avoid Host key verification failed.
	SSHPASS=${10} sshpass -e sftp -oBatchMode=no -b $TEMP_SFTP_FILE -P $3 $8 -o StrictHostKeyChecking=no $1@$2

	echo 'Deploy Success'

    exit 0
fi

# keep string format
printf "%s" "$4" >$TEMP_SSH_PRIVATE_KEY_FILE
# avoid Permissions too open
chmod 600 $TEMP_SSH_PRIVATE_KEY_FILE

# delete remote files if needed
if test $9 == "true";then
  echo 'Start delete remote files'
  ssh -o StrictHostKeyChecking=no -p $3 -i $TEMP_SSH_PRIVATE_KEY_FILE $1@$2 rm -rf $6
fi

if test $7 = "true"; then
  echo "Connection via sftp protocol only, skip the command to create a directory"
else
  echo 'Create directory if needed'
  ssh -o StrictHostKeyChecking=no -p $3 -i $TEMP_SSH_PRIVATE_KEY_FILE $1@$2 mkdir -p $6
fi

echo 'SFTP Start'
# create a temporary file containing sftp commands
printf "%s" "put -r $5 $6" >$TEMP_SFTP_FILE
#-o StrictHostKeyChecking=no avoid Host key verification failed.
sftp -b $TEMP_SFTP_FILE -P $3 $8 -o StrictHostKeyChecking=no -i $TEMP_SSH_PRIVATE_KEY_FILE $1@$2

echo 'Deploy Success'
exit 0
