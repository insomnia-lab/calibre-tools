#!/bin/sh

### BEGIN INIT INFO
# Provides:          calibred
# Required-Start:    $network $local_fs
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Calibre daemon - ebook content server
### END INIT INFO

USER=calibre
PORT=8080
LIBRARY=/home/calibre/propirata

## DON'T CHANGE FOLLOWING LINES ##

GROUP=`id -ng "$USER"`
HOME=`getent passwd $USER | cut -d: -f6`
NAME="Calibre Server"
DAEMON=/usr/bin/calibre-server
PIDFILE=/home/calibre/.calibred.pid

. /lib/lsb/init-functions

start() {
	log_daemon_msg "Starting $NAME"	
	if [ ! -x $DAEMON ]; then
		log_progress_msg " \"$DAEMON\" not installed or not executable";
		log_end_msg 1		
		return 4
	fi

	if /sbin/start-stop-daemon  --start --quiet --pidfile $PIDFILE -u $USER -c $USER:$USER --exec $DAEMON -- --pidfile $PIDFILE --port $PORT --with-library $LIBRARY --daemonize > /dev/null
	then
		log_progress_msg " started"
		log_end_msg 0
		return 0
	else
		log_progress_msg " was already running"
		log_end_msg 2	
		return 1
	fi
}

stop(){
	
	log_daemon_msg "Closing $NAME"	
	if /sbin/start-stop-daemon --stop --quiet --pidfile $PIDFILE --retry forever/TERM/1 
	then
		rm $PIDFILE
		log_progress_msg "closed"	 	
		log_end_msg 0
		return 0
	else
		log_progress_msg "was not running"
		log_end_msg 2
		return 1
	fi
}

status(){
		status_of_proc "$DAEMON" "$NAME"
}


case "$1" in
	start)
		start
	;;
	stop)
		stop
	;;
	restart)
		stop
		sleep 1
		start
	;;
	status)
		status
	;;
 	*)
    echo "Usage: calibred {start|stop|restart|status}"
    exit 1
    ;;
esac

exit $?
