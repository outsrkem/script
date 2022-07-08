#!/bin/bash
#   */10 * * * * root /bin/echo '0' > /tmp/jiankong
#   */2 * * * * root /bin/bash /root/80.sh &>/dev/null
PWD=/root
URL="localhost"
Token(){
to=$1;subject=$2;text=$3
curl 'https://oapi.dingtalk.com/robot/send?access_token=02ff07a076d044f26bbfd7342fc91e322cbbf8eeec3f641497e5a4e197d20f11' \
-H 'Content-Type: application/json' \
-d '
{"msgtype": "text",
	"text": {
	    "content": "'"$text"'"
	},
	"at":{
	    "atMobiles": [ "'"$1"'" ],
	    "isAtAll": false
	}
}'
}
MoniTor(){
    HTTP_CODE=`/usr/bin/curl -o /dev/null -s -w "%{http_code}" "${URL}"` 
    if [ $HTTP_CODE == 200 ];then
	   Token "15378080182" "监控消息"  "'"$HOSTNAME"'httpd服务启动成功，网页返回码: '"$HTTP_CODE"' 请悉知！"
    fi  
}
MoniToring(){
HTTP_CODE=`/usr/bin/curl -o /dev/null -s -w "%{http_code}" "${URL}"` 
if [ $HTTP_CODE != 200 ]
    then
	Token "15378080182" "监控消息"  "'"$HOSTNAME"'服务器状态异常，网页返回码: '"$HTTP_CODE"' 请及时处理！"  
    service httpd restart
    MoniTor
else
    exit 0
fi
}
#=====================================
for((m=0;m<5;m++))
do
    MoniToring
    sleep 4
done