#!/bin/bash
DUMP="/usr/local/bin/docker exec mysqld /bin/mysqldump"
IPADDR=127.0.0.1
PORT=3306
USER=backupuser
PASSWD=backupuser
DATABASE=(uiasdb snmsdb)
ROOT_DIR=/data
LogFile=/data/mysqldunp.log
BACKDIR="${ROOT_DIR}/mysql/`date +%Y/%m/%d`"
MYSQLDUMP="$DUMP -h$IPADDR -P$PORT -u$USER -p$PASSWD"

function log_info(){
    echo -e "[`date +%Y-%m-%d\ %H:%M:%S`] - INFO "  $@" " >> $LogFile
}
function log_error(){
    echo -e "[`date +%Y-%m-%d\ %H:%M:%S`] - ERROR " $@" " >> $LogFile
}
function backup(){
    local database=$1
    local outdir="${BACKDIR}"
    local tm="`date +%Y%m%d-%H%M%S`"
    [ -d $outdir ] || mkdir -p $outdir
    $MYSQLDUMP --databases --skip-extended-insert $database |gzip > ${outdir}/${database}-${tm}.sql.gz
    if [ $? == 0 ];then
        log_info  "${database} database ${table} table Backup successfully!"
    else
        log_error "${database}-${table} Backup failure 100"
        exit 100
    fi
}
function uploadobs(){
    local dir=$1
    /usr/local/bin/obsutil sync $dir obs://obs-bucket${dir}
}


log_info "Database backup starts `date +%Y-%m-%d\ %H:%M:%S`"
for db in ${DATABASE[*]};do
    backup $db
done

# backup to obs
#uploadobs $BACKDIR

