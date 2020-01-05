#!/bin/sh

INITIALSTART=0

echo "running start.sh script of nginx"

# set initstart variable
if [ ! -f /home/appuser/data/nginx/firststart.flg ]
then 
    echo "first start, set initialstart variable to 1"
    INITIALSTART=1
    echo `date +%Y-%m-%d_%H:%M:%S_%z` > /home/appuser/data/nginx/firststart.flg
else
	echo "It's not the first start, skip first start section"
fi

if [ "$INITIALSTART" == "1" ]
then
	echo "First start. Create initial certificates"
	/home/appuser/app/helper/createcerts.sh
else
	echo "It's not the first start, skip first start section"
fi

echo "test nginx configuration file"
nginx -t -c /home/appuser/data/nginx/nginx.cnf

echo "start nginx"
nginx -c /home/appuser/data/nginx/nginx.cnf

#touch /tmp/debug.log
#tail -f /tmp/debug.log