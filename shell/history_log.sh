# Place the script in /etc/profile.d/
# 2019-04-22 Fri 18:08:09 CST
function __history_log {
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
    local  login=$(who -m 2>/dev/null |awk '{print $2" "$NF}')
    local  msg=$(history 1 |{ read x y; echo "$y"; })
    local  num=$(history 1 |{ read x y; echo "$x"; })
    local  base_dir=$(pwd) # Show absolute path
    # local  base_dir=$(basename `pwd`) Only the current directory name is displayed
    if [ "${num}" != "${LastComandNum}" ] && [ "${LastComandNum}" != "" -o "${num}" == "1" ];then
        logger -t "[${SHELL}]" "[${base_dir}]" "[${msg}]" "${result_str}" "[${user}(uid=$user_id)]" "[$login]"
    fi
    LastComandNum=${num}
}

function variable_readonly {
    local  var="$1"
    local  val="$2"
    local  ret=$(readonly -p |grep -w "${var}" |awk -F "${var}=" '{print $NF}')
    if [ "${ret}" = "\"${val}\"" ];then
        return
    else
        export "${var}"="${val}"
        readonly "${var}"
    fi
}

export HISTCONTROL='' >/dev/null 2>&1
variable_readonly HISTTIMEFORMAT "" >/dev/null 2>&1
variable_readonly PROMPT_COMMAND __history_log >/dev/null 2>&1

