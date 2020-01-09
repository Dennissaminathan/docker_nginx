#!/bin/sh

INITIALSTART=0

echo "start.sh: Running start.sh script of nginx"

# set initstart variable
if [ ! -f /home/appuser/data/nginx/firststart.flg ]
then 
    echo "start.sh: First start, set initialstart variable to 1"
    INITIALSTART=1
    echo `date +%Y-%m-%d_%H:%M:%S_%z` > /home/appuser/data/nginx/firststart.flg
else
	echo "start.sh: It's not the first start, skip first start section"
fi

if [ "$INITIALSTART" == "1" ]
then
	echo "start.sh: First start. Create initial certificates"
	/home/appuser/app/helper/createcerts.sh
	if [ "$?" == "1" ]; then exit 1; fi
else
	echo "start.sh: It's not the first start, skip first start section"
fi

echo "start.sh: Test nginx configuration file"
nginx -t -c /home/appuser/data/nginx/nginx.cnf

echo "start.sh: Start nginx"
nginx -c /home/appuser/data/nginx/nginx.cnf

#touch /tmp/debug.log
#tail -f /tmp/debug.log