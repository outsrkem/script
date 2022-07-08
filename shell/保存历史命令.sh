cat << 'EOF' > /etc/profile.d/history.sh
#!/bin/bash
#保存历史命令
#vim /etc/profile.d/history.sh
#history
#历史命令保存路径/var/log/.hist/~
USER_IP=$(who -u am i 2>/dev/null| awk '{print$NF}'|sed -e 's/[()]//g')
DT=$(date +%Y%m%d)
HISTDIR=/var/log/.hist
if [ -z ${USER_IP} ];then
    USER_IP=$(hostname)
fi
if [ ! -d $HISTDIR ];then
    mkdir -p ${HISTDIR}
    chmod 777 ${HISTDIR}
fi
if [ ! -d ${HISTDIR}/${LOGNAME} ];then
    mkdir -p ${HISTDIR}/${LOGNAME}
    chmod 300 ${HISTDIR}/${LOGNAME}
fi
chmod 600 ${HISTDIR}/${LOGNAME}/* &>/dev/null
export PROMPT_COMMAND='history -a'
export HISTTIMEFORMAT="%F %T  "
export HISTSIZE=4096
export HISTFILE="$HISTDIR/${LOGNAME}/history-$DT-${USER_IP}"
EOF