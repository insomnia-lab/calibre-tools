#!/bin/bash

remote_user=calibre
remote_host=erficca.ins
remote_port=22
remote_path=/home/calibre/propirata/
local_path=/media/tera/backup/propirata/
tar_dest=/media/tera/backup/
log_file=/media/tera/backup/propirata_archive.log
email=

### DO NOT MODIFY UNDER THIS LINE ###

date_string=`date +%F`

echo -e "---- Run of $date_string ----\n" > $log_file

# copy remote archive in $local_path 

echo -e "\n#### Rsync log ####\n" >> $log_file
rsync -rzh --rsh="ssh -p $remote_port" $remote_user@$remote_host:$remote_path  $local_path &>> $log_file

# generate compressed archive
echo -e "\n#### Tar log ####\n" >> $log_file
tar -zcf "$tar_dest"propirata_"$date_string".tar.gz $local_path &>> $log_file

# send email

if [ -n $email ]; then
	echo -e "Sending mail...\n"
	echo -e "Server: "`hostname`"\nScript: $0\n\n---Autogenerated mail---\n" > /tmp/void_mail.txt
	mutt -s "["`hostname`"] Archive Script Finished" -a $log_file -- $email < /tmp/void_mail.txt
fi

exit 0
