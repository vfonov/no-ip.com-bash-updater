#!/bin/bash

# No-IP uses emails as usernames, so make sure that you encode the @ as %40
USERNAME=
PASSWORD=
HOST=

# TODO: set appropriate location 
LOGFILE=/tmp/noip.log
STOREDIPFILE=/tmp/noip.ip

USERAGENT="Simple Bash No-IP Updater/0.4.1 vladimir.fonov@gmail.com"

if [ x"$USERNAME"x == xx ];then
    echo "$0: Update configuration!" 1>&2
    exit 1
fi


if [ ! -e $STOREDIPFILE ]; then
    touch $STOREDIPFILE
fi

NEWIP=$(curl --silent http://icanhazip.com/ )
STOREDIP=$(cat $STOREDIPFILE)

if [ "$NEWIP" != "$STOREDIP" ]; then
	RESULT=$(curl  --silent --user-agent "$USERAGENT" "https://$USERNAME:$PASSWORD@dynupdate.no-ip.com/nic/update?hostname=$HOST&myip=$NEWIP")

	LOGLINE="[$(date +"%Y-%m-%d %H:%M:%S")] $RESULT"
	echo $NEWIP > $STOREDIPFILE
#else # VF: no need to tell me ech time
#	LOGLINE="[$(date +"%Y-%m-%d %H:%M:%S")] No IP change"
    echo $LOGLINE >> $LOGFILE
fi

exit 0

