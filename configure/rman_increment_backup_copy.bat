#
NLS_LANG=RUSSIAN_RUSSIA.AL32UTF8
ORACLE_BASE=/opt/oracle/database
ORACLE_HOME=$ORACLE_BASE/db-11.2.0.4
ORACLE_SID=rman
BACKUP_DIR=/zfssa/dbm01/backup
BACKUP_CTL_DIR=/zfssa/dbm01
#export BACKUP_DIR=/zfssa/dbm01/backup/increment_backup_copy

export TIME_BACKUP=`date +%Y-%m-%d`
#export TIME_BACKUP=`date +%Y-%m-%d-%T`
#echo $TIME_BACKUP

PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin
export PATH ORACLE_BASE ORACLE_HOME ORACLE_SID NLS_LANG BACKUP_DIR BACKUP_CTL_DIR

rman log=${BACKUP_DIR}/logs/rman_INCREMENT_backup_copy_${TIME_BACKUP}.log <<EOF
connect target sys/welcome1@dbm01 
connect catalog rman/rman@rman
run{
sql 'alter system set "_backup_file_bufcnt"=64 scope=memory';
sql 'alter system set "_backup_file_bufsz"=1048576 scope=memory';

#allocate channel ch01 type disk format '${BACKUP_DIR}/increment_backup_copy/%d_${TIME_BACKUP}_%p_%s.rman';
#allocate channel ch01 type disk connect 'sys/welcome1@dbm01' format '${BACKUP_DIR}/increment_backup_copy/%d_${TIME_BACKUP}_%p_%s.rman';

#recover copy of database with tag 'INCREMENT_COPY_DB' until time 'sysdate-7';

backup  incremental level 1 for recover of copy with tag 'INCREMENT_COPY_DB' database;
backup archivelog all;
}
#crosscheck backup; #Проверяем испорченные или поврежденные архивы
#delete noprompt expired backup of database; #Удаляем испорченные или поврежденные архивы
#delete noprompt obsolete;
#list backup;
#report obsolete;
#list incarnation;
EOF
#
exit
