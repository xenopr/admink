prompt PL/SQL Developer Export Tables for user AUTH@ORCLPDB
prompt Created by ProtasovAA on 4 Октябрь 2021 г.
set feedback off
set define off

prompt Loading ROLE...
insert into ROLE (id, name, description)
values (7, 'Руководитель', 'Все видит, ничего не делает');
insert into ROLE (id, name, description)
values (124, 'Читатель', 'Видит что надо');
insert into ROLE (id, name, description)
values (1, 'Администратор', 'Администратор системы');
commit;
prompt 3 records loaded
prompt Loading ROLERIGHT...
insert into ROLERIGHT (id, rightid, roleid)
values (1, 1, 1);
insert into ROLERIGHT (id, rightid, roleid)
values (130, 1, 7);
insert into ROLERIGHT (id, rightid, roleid)
values (2, 2, 1);
insert into ROLERIGHT (id, rightid, roleid)
values (132, 2, 7);
insert into ROLERIGHT (id, rightid, roleid)
values (131, 3, 7);
insert into ROLERIGHT (id, rightid, roleid)
values (144, 3, 124);
commit;
prompt 6 records loaded
prompt Loading USERA...
insert into USERA (id, login, activeto, username, subdivision, position, description)
values (13, 'user4@mydomain.ru', null, 'Фамилия4 Имя Отчество', 'Служба информационного обеспечения', 'Начальник службы', 'Автозаполнено Mon Sep 27 2021 17:09:42 GMT+0500 (Екатеринбург, стандартное время)');
insert into USERA (id, login, activeto, username, subdivision, position, description)
values (14, 'user3@mydomain.ru', to_date('30-09-2021', 'dd-mm-yyyy'), 'Фамилия3 Имя Отчество', 'Служба производственно-хозяйственного обеспечения', 'Уборщик производственных и служебных помещений 2  разряда', 'Автозаполнено Mon Sep 27 2021 17:20:31 GMT+0500 (Екатеринбург, стандартное время)');
insert into USERA (id, login, activeto, username, subdivision, position, description)
values (1, 'user1@mydomain.ru', null, 'Фамилия1 Имя Отчество', 'Служба информационного обеспечения', 'Ведущий инженер-программист', 'Автозаполнено Mon Sep 27 2021 17:26:36 GMT+0500 (Екатеринбург, стандартное время)');
insert into USERA (id, login, activeto, username, subdivision, position, description)
values (2, 'user2@mydomain.ru', null, 'Фамилия2 Имя Отчество', 'Служба информационного обеспечения', 'Ведущий инженер-программист', 'Автозаполнено Mon Sep 27 2021 17:20:57 GMT+0500 (Екатеринбург, стандартное время)');
commit;
prompt 4 records loaded
prompt Loading USERROLE...
insert into USERROLE (id, userid, roleid)
values (28, 1, 1);
insert into USERROLE (id, userid, roleid)
values (25, 2, 1);
insert into USERROLE (id, userid, roleid)
values (50, 13, 7);
insert into USERROLE (id, userid, roleid)
values (24, 14, 124);
commit;
prompt 4 records loaded

set feedback on
set define on
prompt Done
