prompt PL/SQL Developer Export Tables for user AUTH@ORCLPDB
prompt Created by ProtasovAA on 4 ������� 2021 �.
set feedback off
set define off

prompt Loading RIGHT...
insert into RIGHT (id, name, description)
values (1, 'ADMIN', '�������������');
insert into RIGHT (id, name, description)
values (2, 'TEST', '����� �� ����');
insert into RIGHT (id, name, description)
values (3, 'READONLY', '������ ������');
commit;
prompt 3 records loaded

set feedback on
set define on
prompt Done
