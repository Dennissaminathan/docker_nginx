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

# delete old config files
if [ -f /home/appuser/data/nginx/conf.d/nginx_init.cnf ]; then echo "delete old config file"; rm /home/appuser/data/nginx/conf.d/nginx_init.cnf; fi

echo "Use config template which is stored in /home/appuser/app"
cp /home/appuser/app/nginx_init.conf /home/appuser/data/conf.d/nginx_init.conf

echo "patch configuration file"
sed -i -e "s/#DNS_IPADDR#/${DNS_IPADDR}/g" /home/appuser/data/conf.d/nginx_init.conf
sed -i -e "s/#NGX_PORT#/${NGX_PORT}/g" /home/appuser/data/conf.d/nginx_init.conf
sed -i -e "s/#DNS_INITDOMAIN#/${DNS_INITDOMAIN}/g" /home/appuser/data/conf.d/nginx_init.conf
sed -i -e "s/#GT_PORT#/${GT_PORT}/g" /home/appuser/data/conf.d/nginx_init.conf
sed -i -e "s/#JKS_PORT#/${JKS_PORT}/g" /home/appuser/data/conf.d/nginx_init.conf
sed -i -e "s/#VLT_PORT#/${VLT_PORT}/g" /home/appuser/data/conf.d/nginx_init.conf
sed -i -e "s/#NXS_PORT#/${NXS_PORT}/g" /home/appuser/data/conf.d/nginx_init.conf
sed -i -e "s/#NXS_DOCKERPORT#/${NXS_DOCKERPORT}/g" /home/appuser/data/conf.d/nginx_init.conf

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