prompt PL/SQL Developer Export Tables for user AUTH@ORCLPDB
prompt Created by ProtasovAA on 29 Сентябрь 2021 г.
set feedback off
set define off

prompt Loading LOGRESULT...
insert into LOGRESULT (id, name, namerus)
values (1, 'success', 'успех');
insert into LOGRESULT (id, name, namerus)
values (2, 'failure', 'провал');
commit;
prompt 2 records loaded

set feedback on
set define on
prompt Done
