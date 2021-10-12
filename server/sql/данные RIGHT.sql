prompt PL/SQL Developer Export Tables for user AUTH@ORCLPDB
prompt Created by ProtasovAA on 4 Октябрь 2021 г.
set feedback off
set define off

prompt Loading RIGHT...
insert into RIGHT (id, name, description)
values (1, 'ADMIN', 'Администратор');
insert into RIGHT (id, name, description)
values (2, 'TEST', 'Право на тест');
insert into RIGHT (id, name, description)
values (3, 'READONLY', 'Только чтение');
commit;
prompt 3 records loaded

set feedback on
set define on
prompt Done
