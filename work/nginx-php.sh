#/bin/bash

VDIR="/data/wwwroot"
VUSER="www"

WUID=`ls $VDIR -dl | awk '{print $3}'`
WGID=`ls $VDIR -dl | awk '{print $4}'`
# 目录属户属组为数字时更改
if [ -n "$(echo $WUID| sed -n "/^[0-9]\+$/p")" ];then
   usermod -u $WUID $VUSER
   groupmod -g $WGID $VUSER
fi
