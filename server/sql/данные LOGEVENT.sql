prompt PL/SQL Developer Export Tables for user AUTH@ORCLPDB
prompt Created by ProtasovAA on 29 Сентябрь 2021 г.
set feedback off
set define off

prompt Loading LOGEVENT...
insert into LOGEVENT (id, name, namerus)
values (10, 'test', 'тест');
insert into LOGEVENT (id, name, namerus)
values (5, 'access', 'доступ');
insert into LOGEVENT (id, name, namerus)
values (1, 'login', 'вход');
insert into LOGEVENT (id, name, namerus)
values (2, 'logout', 'выход');
insert into LOGEVENT (id, name, namerus)
values (11, 'insert', 'создание');
insert into LOGEVENT (id, name, namerus)
values (12, 'update', 'изменение');
insert into LOGEVENT (id, name, namerus)
values (13, 'delete', 'удаление');
insert into LOGEVENT (id, name, namerus)
values (3, 'start', 'запуск');
insert into LOGEVENT (id, name, namerus)
values (4, 'stop', 'останов');
commit;
prompt 9 records loaded

set feedback on
set define on
prompt Done
