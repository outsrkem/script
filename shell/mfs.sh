#!/bin/bash
#chkconfig: 2345 95 33
#description: MFS start

case "$1" in
    start) /usr/local/mfs/sbin/mfschunkserver start
        ;;
    *)
        echo "please input stop|start|.";exit 1
esac
      