#
rman target sys/welcome1@dbm01 catalog rman/rman@rman;
#<<EOF
#
#run{
#report backup; 
#show all;
#list copy;
#delete obsolete;
#y
#}
#EOF

