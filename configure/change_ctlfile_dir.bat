sqlplus sys/welcome1@dbm01 as sysdba <<EOF
execute sys.dbms_backup_restore.cfilesetsnapshotname('+RECOC1/dbm01/autobackup/snapcf_dbm01.f');
EOF