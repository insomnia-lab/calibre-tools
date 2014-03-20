#!/bin/bash
server_ip="erficca.lan"
remote_user="calibre"
remote_path="/home/calibre/propirata"
temp_path='~/temp_calibre_library'

eval temp_path=$temp_path

#umount path
function _umount { 
	umount $temp_path &> /dev/null
	if [ $? -ne 0 ]; then
		echo "failed umounting $temp_path"	
	fi
}

#remove temp folder
function _remove {
	mount | grep $temp_path &> /dev/null
	if [ $? -ne 0 ]; then
		rm -R $temp_path &> /dev/null	
	fi
}

#clean previous run
umount $temp_path &> /dev/null
_remove


#test sshfs installation
which sshfs &> /dev/null
if [ $? -ne 0 ]; then
	echo "sshfs is not installed"
	exit 1
fi

#test if server is reachable
ping -W 3 -c 1 erficca.lan &> /dev/null
if [ $? -ne 0 ]; then
	echo "server it's not reachable on \"$server_ip\""
	exit 3
fi

#create directory
mkdir $temp_path &> /dev/null
if [ $? -ne 0 ]; then
	echo "failed to create $temp_path"
	exit 4
fi

#mount remote hdd
sshfs $remote_user@$server_ip:$remote_path $temp_path
if [ $? -ne 0 ]; then
	echo "failed on sshfs"
	exit 5
fi


#test folder
ls $temp_path
if [ $? -ne 0 ]; then
	echo "failed to start calibre"
	exit 6
fi


_umount

_remove

exit 0