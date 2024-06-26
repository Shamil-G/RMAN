#
#target sys/Welcome1@rman 
TIME_BACKUP=`date +%Y-%m-%d`

rman target sys/welcome1@dbm01 catalog rman/rman@rman log=rman_first_configure_${TIME_BACKUP}.log @first_configure.parm



