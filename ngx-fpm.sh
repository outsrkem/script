#!/bin/bash
#chkconfig: 2345 99 33
#description: nginx server control tools
ngxc="/usr/local/nginx/sbin/nginx"
pidf="usr/local/nginx/logs/nginx.pid"
ngxc_fpm="/usr/local/php7/sbin/php-fpm"
pidf_fpm="/usr/local/php7/var/run/php-fpm.pid"
case "$1" in
	start)
		$ngxc -t &> /dev/null
		if [ $? -eq 0 ];then
			$ngxc
			$ngxc_fpm
			echo "nginx service start success!"
		else
			$ngxc -t
		fi
	;;
	stop)
		kill -s QUIT $(cat $pidf)
		kill -s QUIT $(cat $pidf_fpm)
		echo "nginx service stop success!"
	;;
	restart)
		$0 stop
		$0 start
	;;
	reload)
		$ngxc -t &> /dev/null
		if [ $? -eq 0 ];then
		kill -s HUP $(cat $pidf)
		kill -s HUP $(cat $pidf_fpm)
		echo "reload nginx config success!"
		else
		$ngxc -t
		fi
	;;
	*)
		echo "please input stop|start|restart|reload."
		exit 1
esac