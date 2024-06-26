#
# User specific environment and startup programs
NLS_LANG=RUSSIAN_RUSSIA.AL32UTF8
ORACLE_BASE=/opt/oracle/database
ORACLE_HOME=$ORACLE_BASE/db-11.2.0.4
ORACLE_SID=rman
BACKUP_DIR=/zfssa/dbm01/backup

PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin
export PATH ORACLE_BASE ORACLE_HOME ORACLE_SID NLS_LANG

export TIME_BACKUP=`date +%Y-%m-%d`
#export TIME_BACKUP=`date +%Y-%m-%d-%T`
echo $TIME_BACKUP

rman log=${BACKUP_DIR}/logs/rman_full_backup_${TIME_BACKUP}.log <<EOF
connect target sys/welcome1@dbm01 
connect catalog rman/rman@rman
run{
  backup database 
  tag 'FULL_DB_BACKUP' 
  format '${BACKUP_DIR}/full_backup/%d_${TIME_BACKUP}_%p_%s.rman' 
  plus archivelog;
}
crosscheck backup; #Проверяем испорченные или поврежденные архивы
delete noprompt expired backup of database; #Удаляем испорченные или поврежденные архивы
delete noprompt obsolete;
list incarnation;
list backup;
report obsolete;
list expired backup;
EOF
#
exit
