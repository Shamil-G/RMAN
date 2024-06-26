#
rman target sys/welcome1@dbm01 catalog rman/rman@rman log=rman_delete_all_backup.log<<EOF

run{
 delete backup;
}
