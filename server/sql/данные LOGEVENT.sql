prompt PL/SQL Developer Export Tables for user AUTH@ORCLPDB
prompt Created by ProtasovAA on 29 �������� 2021 �.
set feedback off
set define off

prompt Loading LOGEVENT...
insert into LOGEVENT (id, name, namerus)
values (10, 'test', '����');
insert into LOGEVENT (id, name, namerus)
values (5, 'access', '������');
insert into LOGEVENT (id, name, namerus)
values (1, 'login', '����');
insert into LOGEVENT (id, name, namerus)
values (2, 'logout', '�����');
insert into LOGEVENT (id, name, namerus)
values (11, 'insert', '��������');
insert into LOGEVENT (id, name, namerus)
values (12, 'update', '���������');
insert into LOGEVENT (id, name, namerus)
values (13, 'delete', '��������');
insert into LOGEVENT (id, name, namerus)
values (3, 'start', '������');
insert into LOGEVENT (id, name, namerus)
values (4, 'stop', '�������');
commit;
prompt 9 records loaded

set feedback on
set define on
prompt Done
