#!/bin/bash
DUMP=/usr/bin/mysqldump
MYSQL=/usr/bin/mysql
IPADDR=127.0.0.1
PORT=3306
USER=abc
PASSWD=123456
DATABASE=(test qweqwe sad)
ROOT_DIR=/data
LogFile=/var/log/mysqldump.log
DATE="`date +%Y%m%d`"
MYSQLCMD="$MYSQL -h$IPADDR -P$PORT -u$USER -p$PASSWD"
MYSQLDUMP="$DUMP -h$IPADDR -P$PORT -u$USER -p$PASSWD"
OUTDIR="${ROOT_DIR}/mysql/${DATE}/${DATABASE}"
function log_info(){
    echo -e "[`date +%Y-%m-%d\ %H:%M:%S`] - INFO "  $@" " >> $LogFile
}
function log_error(){
    echo -e "[`date +%Y-%m-%d\ %H:%M:%S`] - ERROR " $@" " >> $LogFile
}
function backup(){
    database=$1
    table=$2
    $MYSQLDUMP $DATABASE $table > ${OUTDIR}/${DATE}-${database}-${table}.sql
    if [ $? == 0 ];then
        log_info  "${database} database ${table} table Backup successfully!"
    else
        log_error "${database}-${table} Backup failure 100"
        exit 100
    fi
}
function create_directory(){
    database=$1
    outdir="${ROOT_DIR}/mysql/${DATE}/${database}"
    [ -d $outdir ] || mkdir -p $outdir
    if [ -d $outdir ];then
        log_info "Directory created successfully! --> ${outdir}"
    else
        log_error "${outdir}  Directory creation failed."
        log_error "Backup to terminate."
    fi
}
function tables_bak(){
    database=$1
    table=(`$MYSQLCMD -e "show tables from $database;" | sed '1d'`)
    log_info "${#table[*]} tables : ${table[*]}"
    for table in  ${table[*]}
    do
        backup $database $table
    done
}
log_info "Database backup starts `date +%Y-%m-%d\ %H:%M:%S`"
for db in ${DATABASE[*]}
do
    create_directory $db
    tables_bak $db
done