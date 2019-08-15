#/bin/bash

WUID=`ls /data/wwwroot -dl | awk '{print $3}'`

if [ $WUID != 'www' ];then
   usermod -u $WUID www
fi
