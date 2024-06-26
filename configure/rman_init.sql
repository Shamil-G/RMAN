spool create_rman_user.log

drop user rman cascade
/
create user rman identified by rman
default tablespace rmancat
temporary tablespace temp
quota 512M on rmancat
/
grant recovery_catalog_owner to rman
/