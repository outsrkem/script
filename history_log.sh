#
# 将脚本放置在 /etc/profile.d/ 即可
#
function _history_log {
    local  result=$?
    local  result_str=""
    if [ ${result} -eq 0 ];then
        result_str="[code=0]"
    else
        result_str="[code=${result}]"
    fi
    history -a
    local  user=$(whoami)
    local  user_id=$(id -ur $user)
    local  login=$(who -m | awk '{print $2" "$NF}')
    local  msg=$(history 1 | { read x y; echo "$y"; })
    local  num=$(history 1 | { read x y; echo "$x"; })
    local  base_dir=$(pwd) # 显示绝对路径
    # local  base_dir=$(basename `pwd`) 只显示当前目录名
    if [ "${num}" != "${LastComandNum}" ] && [ "${LastComandNum}" != "" -o "${num}" == "1" ];then
        logger -t "[${SHELL}]" "[${base_dir}]" "[${msg}]" "${result_str}" "[${user}(uid=$user_id)]" "[$login]"
    fi
    LastComandNum=${num}
}

function variable_readonly {
    local  var="$1"
    local  val="$2"
    local  ret=$(readonly -p | grep -w "${var}" | awk -F "${var}=" '{print $NF}')
    if [ "${ret}" = "\"${val}\"" ];then
        return
    else
        export "${var}"="${val}"
        readonly "${var}"
    fi
}

export HISTCONTROL='' >/dev/null 2>&1
variable_readonly HISTTIMEFORMAT "" >/dev/null 2>&1
variable_readonly PROMPT_COMMAND _history_log >/dev/null 2>&1

