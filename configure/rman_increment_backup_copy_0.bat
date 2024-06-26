#
NLS_LANG=RUSSIAN_RUSSIA.AL32UTF8
ORACLE_BASE=/opt/oracle/database
ORACLE_HOME=$ORACLE_BASE/db-11.2.0.4
ORACLE_SID=rman
BACKUP_DIR=/zfssa/dbm01/backup
#export BACKUP_DIR=/zfssa/dbm01/backup/increment_backup_copy

export TIME_BACKUP=`date +%Y-%m-%d`
#export TIME_BACKUP=`date +%Y-%m-%d-%T`
#echo $TIME_BACKUP
#echo '${TIME_BACKUP}'

PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin
export PATH ORACLE_BASE ORACLE_HOME ORACLE_SID NLS_LANG BACKUP_DIR

rman log=${BACKUP_DIR}/logs/COPY_0_INC_${TIME_BACKUP}.log <<EOF
connect target sys/welcome1@dbm01 
connect catalog rman/rman@rman
run{
configure controlfile autobackup format for device type disk to '${BACKUP_DIR}/control_files/cf_%F.ctl';
allocate channel c1 type disk
format '${BACKUP_DIR}/increment_backup_copy/%d_${TIME_BACKUP}_%p_%s.rman';

#recover copy of database with tag 'COPY_DB' until time 'sysdate-7';
#format '${BACKUP_DIR}/increment_backup_copy/%d_${TIME_BACKUP}_%p_%s.rman';

backup incremental level 0 tag 'COPY_DB' database include current controlfile plus archivelog;
release channel c1;
}
#backup archivelog all not backed up;
#backup current controlfile;
#backup backupset all not backed up since time 'sysdate-1';
crosscheck backup; #Проверяем испорченные или поврежденные архивы
delete noprompt expired backup of database; #Удаляем испорченные или поврежденные архивы
delete noprompt obsolete;
list backup;
report obsolete;
list incarnation;
EOF
#
exit
