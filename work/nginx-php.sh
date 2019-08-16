#/bin/bash

WUID=`ls /data/wwwroot -dl | awk '{print $3}'`
WGID=`ls /data/wwwroot -dl | awk '{print $4}'`
# 目录属户属组为数字时更改
if [ -n "$(echo $WUID| sed -n "/^[0-9]\+$/p")" ];then
   usermod -u $WUID www
   groupmod -g $WGID www
fi
