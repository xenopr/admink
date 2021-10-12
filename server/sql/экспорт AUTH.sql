prompt PL/SQL Developer Export User Objects for user AUTH@ORCLPDB
prompt Created by ProtasovAA on 29 Сентябрь 2021 г.
set define off
spool экспорт AUTH.log

prompt
prompt Creating table LOGEVENT
prompt =======================
prompt
create table AUTH.LOGEVENT
(
  id      NUMBER(10) not null,
  name    VARCHAR2(100) not null,
  namerus VARCHAR2(100)
)
;
comment on table AUTH.LOGEVENT
  is ' Тип события (Логаут, Создание, Изменение, Удаление)';
alter table AUTH.LOGEVENT
  add constraint PK_RECORDEVENT primary key (ID);
grant select on AUTH.LOGEVENT to GEOUSER;

prompt
prompt Creating table LOGRESULT
prompt ========================
prompt
create table AUTH.LOGRESULT
(
  id      NUMBER(10) not null,
  name    VARCHAR2(100) not null,
  namerus VARCHAR2(100)
)
;
comment on table AUTH.LOGRESULT
  is ' Результат события (успех, ошибка)';
alter table AUTH.LOGRESULT
  add constraint PK_RECORDTYPE primary key (ID);
grant select on AUTH.LOGRESULT to GEOUSER;

prompt
prompt Creating table USERA
prompt ====================
prompt
create table AUTH.USERA
(
  id          NUMBER(10) not null,
  login       VARCHAR2(100) not null,
  activeto    DATE,
  username    VARCHAR2(1000),
  subdivision VARCHAR2(1000),
  position    VARCHAR2(1000),
  description VARCHAR2(4000)
)
;
comment on table AUTH.USERA
  is ' Пользователи системы';
comment on column AUTH.USERA.login
  is ' Логин аккаунта (email)';
comment on column AUTH.USERA.activeto
  is ' Срок действительности аккаунта, вкл-выкл';
comment on column AUTH.USERA.username
  is ' ФИО';
comment on column AUTH.USERA.subdivision
  is ' Подразделение';
comment on column AUTH.USERA.position
  is ' Должность';
comment on column AUTH.USERA.description
  is 'Комментарий админа';
create unique index AUTH.UQ_LOGIN on AUTH.USERA (LOWER(LOGIN));
alter table AUTH.USERA
  add constraint PK_USER primary key (ID);
grant select on AUTH.USERA to GEOUSER;

prompt
prompt Creating table LOG
prompt ==================
prompt
create table AUTH.LOG
(
  id          NUMBER(20) not null,
  dt          TIMESTAMP(3) default SYSTIMESTAMP not null,
  logresultid NUMBER(10) not null,
  logeventid  NUMBER(10) not null,
  userid      NUMBER(10),
  token       VARCHAR2(4000),
  restapi     VARCHAR2(100),
  ip          VARCHAR2(100),
  whence      VARCHAR2(4000),
  target      VARCHAR2(1000),
  operation   VARCHAR2(1000),
  record      VARCHAR2(4000)
)
;
comment on table AUTH.LOG
  is ' Журнал событий';
comment on column AUTH.LOG.dt
  is ' Дата время события, миллисекунды';
comment on column AUTH.LOG.logresultid
  is ' Результат события (Успех, Ошибка)';
comment on column AUTH.LOG.logeventid
  is ' Тип события (Логон, Логаут, Создание, Изменение, Удаление)';
comment on column AUTH.LOG.userid
  is ' От чьего логина событие';
comment on column AUTH.LOG.token
  is ' Токен вызвавшего';
comment on column AUTH.LOG.restapi
  is ' Путь из заголовка запроса';
comment on column AUTH.LOG.ip
  is ' IP клиента, который вызывал событие';
comment on column AUTH.LOG.whence
  is ' Контроллер, который записал событие';
comment on column AUTH.LOG.target
  is ' Что хотел изменить контроллер';
comment on column AUTH.LOG.operation
  is ' Что пытался сделать контроллер';
comment on column AUTH.LOG.record
  is ' Описание события, что сделано';
create index AUTH.IDX_LOGDT on AUTH.LOG (DT);
create index AUTH.IDX_LOGEVENT on AUTH.LOG (LOGEVENTID);
create index AUTH.IDX_LOGIP on AUTH.LOG (IP);
create index AUTH.IDX_LOGRESTAPI on AUTH.LOG (RESTAPI);
create index AUTH.IDX_LOGRESULT on AUTH.LOG (LOGRESULTID);
alter table AUTH.LOG
  add constraint PK_LOG primary key (ID);
alter table AUTH.LOG
  add constraint FK_LOG_EVENT foreign key (LOGEVENTID)
  references AUTH.LOGEVENT (ID);
alter table AUTH.LOG
  add constraint FK_LOG_RESULT foreign key (LOGRESULTID)
  references AUTH.LOGRESULT (ID);
alter table AUTH.LOG
  add constraint FK_USER_LOG foreign key (USERID)
  references AUTH.USERA (ID);
grant select on AUTH.LOG to GEOUSER;

prompt
prompt Creating table RIGHT
prompt ====================
prompt
create table AUTH.RIGHT
(
  id          NUMBER(10) not null,
  name        VARCHAR2(30) not null,
  description VARCHAR2(4000)
)
;
comment on table AUTH.RIGHT
  is ' Идентификаторы прав';
comment on column AUTH.RIGHT.name
  is ' ИД права';
comment on column AUTH.RIGHT.description
  is ' Описание, что дает право';
create unique index AUTH.UQ_RIGHT on AUTH.RIGHT (NAME);
alter table AUTH.RIGHT
  add constraint PK_RIGHT primary key (ID);
grant select on AUTH.RIGHT to GEOUSER;

prompt
prompt Creating table ROLE
prompt ===================
prompt
create table AUTH.ROLE
(
  id          NUMBER(10) not null,
  name        VARCHAR2(30) not null,
  description VARCHAR2(300)
)
;
comment on table AUTH.ROLE
  is ' Роли, наборы прав

';
create unique index AUTH.UQ_ROLE on AUTH.ROLE (NAME);
alter table AUTH.ROLE
  add constraint PK_ROLE primary key (ID);
grant select on AUTH.ROLE to GEOUSER;

prompt
prompt Creating table ROLERIGHT
prompt ========================
prompt
create table AUTH.ROLERIGHT
(
  id      NUMBER(10) not null,
  rightid NUMBER(10) not null,
  roleid  NUMBER(10) not null
)
;
comment on table AUTH.ROLERIGHT
  is ' Список прав у роли';
create unique index AUTH.UQ_ROLERIGHT on AUTH.ROLERIGHT (RIGHTID, ROLEID);
alter table AUTH.ROLERIGHT
  add constraint PK_ROLERIGHT primary key (ID);
alter table AUTH.ROLERIGHT
  add constraint FK_RIGHT_ROLERIGHT foreign key (RIGHTID)
  references AUTH.RIGHT (ID);
alter table AUTH.ROLERIGHT
  add constraint FK_ROLE_ROLERIGHT foreign key (ROLEID)
  references AUTH.ROLE (ID);
grant select on AUTH.ROLERIGHT to GEOUSER;

prompt
prompt Creating table USERROLE
prompt =======================
prompt
create table AUTH.USERROLE
(
  id     NUMBER(10) not null,
  userid NUMBER(10) not null,
  roleid NUMBER(10) not null
)
;
comment on table AUTH.USERROLE
  is ' Список ролей для пользователя системы';
create unique index AUTH.UQ_USERROLE on AUTH.USERROLE (USERID, ROLEID);
alter table AUTH.USERROLE
  add constraint PK_USERROLE primary key (ID);
alter table AUTH.USERROLE
  add constraint FK_ROLE_USERROLE foreign key (ROLEID)
  references AUTH.ROLE (ID);
alter table AUTH.USERROLE
  add constraint FK_USER_USERROLE foreign key (USERID)
  references AUTH.USERA (ID);
grant select on AUTH.USERROLE to GEOUSER;

prompt
prompt Creating sequence SQ_LOG
prompt ========================
prompt
create sequence AUTH.SQ_LOG
minvalue 1
maxvalue 9999999999999999999999999999
start with 1361
increment by 1
cache 20;
grant select on AUTH.SQ_LOG to GEOUSER;


prompt
prompt Creating sequence SQ_ROLE
prompt =========================
prompt
create sequence AUTH.SQ_ROLE
minvalue 1
maxvalue 9999999999999999999999999999
start with 142
increment by 1
cache 20;
grant select on AUTH.SQ_ROLE to GEOUSER;


prompt
prompt Creating sequence SQ_ROLERIGHT
prompt ==============================
prompt
create sequence AUTH.SQ_ROLERIGHT
minvalue 1
maxvalue 9999999999999999999999999999
start with 162
increment by 1
cache 20;
grant select on AUTH.SQ_ROLERIGHT to GEOUSER;


prompt
prompt Creating sequence SQ_USERA
prompt ==========================
prompt
create sequence AUTH.SQ_USERA
minvalue 1
maxvalue 9999999999999999999999999999
start with 22
increment by 1
cache 20;
grant select on AUTH.SQ_USERA to GEOUSER;


prompt
prompt Creating sequence SQ_USERROLE
prompt =============================
prompt
create sequence AUTH.SQ_USERROLE
minvalue 1
maxvalue 9999999999999999999999999999
start with 62
increment by 1
cache 20;
grant select on AUTH.SQ_USERROLE to GEOUSER;


prompt
prompt Creating package PKGAUTH
prompt ========================
prompt
create or replace package auth.PKGAUTH is
  --Created : 03.09.2021 14:20:10
  --Функции связаные с аутентификацией

  --тип, список id для передачи как параметр
  type typeIDs is table of number;
  
  --получить список ролей пользователя, ids-идентификаторы
  function getUserRoles(user_id number, v_type varchar2 default 'str') return varchar2;
  
  --получить список прав пользователя
  function getUserRights(user_id number) return varchar2;
  
  --получить список прав роли str-наименования, ids-идентификаторы
  function getRoleRights(v_roleid number, v_type varchar2 default 'str') return varchar2;
 
  --получить список пользователей роли 
  function getRoleUsers(v_roleid number) return varchar2; 
  
  --вставить запись в журнал
  function toLog(v_logresultid in number, v_logeventid in number, v_userid in number, v_token in varchar2, v_restapi in varchar2, v_ip in varchar2, v_whence in varchar2, v_target in varchar2, v_operation in varchar2, v_record in varchar2) return number;
  
  --CRUD ролей 
  --создать новую роль
  --на входе наименование, описание, массив с перечнем id прав. возращает id новой роли
  function createRole(v_name in varchar2, v_description in varchar2, v_rights in typeIDs) return number;
  --изменить роль 
  procedure updateRole(v_roleid in number, v_name in varchar2, v_description in varchar2, v_rights in typeIDs);
  --удалить роль 
  procedure deleteRole(v_roleid in number);
  
  --CRUD пользователей
  --создать нового пользователя 
  function createUser(v_login in varchar2,v_username in varchar2,v_position in varchar2,v_subdivision in varchar2,v_description in varchar2,v_roles in typeIDs) return number;
  --изменить пользователя 
  procedure updateUser(v_userid in number,v_login in varchar2,v_username in varchar2,v_position in varchar2,v_subdivision in varchar2,v_description in varchar2,v_roles in typeIDs); 
  --удалить пользователя
  procedure deleteUser(v_userid in number);
  --включить выключить аккаунт
  procedure activeUser(v_userid in number, v_activeto in date);
  
end PKGAUTH;
/
grant execute on AUTH.PKGAUTH to GEOUSER;


prompt
prompt Creating type TYPETEST
prompt ======================
prompt
create or replace type auth.typetest as object
(
  ID NUMBER
)
/

prompt
prompt Creating package body PKGAUTH
prompt =============================
prompt
create or replace package body auth.PKGAUTH is

  --получить список ролей пользователя
  --str-наименования, ids-идентификаторы 270921
  function getUserRoles(user_id number, v_type varchar2 default 'str') return varchar2
  is
    r varchar(4000) default '';
  begin
    for ii in (select r.id, r.name 
                 from auth.userrole ur, auth.role r 
                where ur.userid=user_id and r.id=ur.roleid 
               order by r.name) loop
      r:=r||','||(case v_type when 'ids' then to_char(ii.id) else ii.name end);
    end loop;  
    return ltrim(r,',');
  end;
  
  --получить список прав пользователя
  function getUserRights(user_id number) return varchar2
  is
    r varchar(4000) default '';
  begin
    for ii in (select distinct r.name 
                 from auth.userrole ur, auth.roleright rr, auth.right r
                where ur.userid=user_id and rr.roleid=ur.roleid and r.id=rr.rightid
               order by r.name) loop
      r:=r||','||ii.name;
    end loop;  
    return ltrim(r,',');
  end;
  
  --получить список прав роли  --15 09 2021 --в JS делаем split - получим массив 
  --str-наименования, ids-идентификаторы 220921
  function getRoleRights(v_roleid number, v_type varchar2 default 'str') return varchar2
  is
    r varchar(4000) default '';
  begin
    for ii in (select r.id, r.name 
                 from auth.roleright rr, auth.right r
                where rr.roleid=v_roleid and r.id=rr.rightid
               order by r.name) loop                  
      r:=r||','||(case v_type when 'ids' then to_char(ii.id) else ii.name end);
    end loop;  
    return ltrim(r,',');
  end;

  --получить список пользователей роли  --15 09 2021 --в JS делаем split - получим массив 
  function getRoleUsers(v_roleid number) return varchar2
  is
    r varchar(4000) default '';
  begin
    for ii in (select u.username 
                 from auth.userrole ur, auth.usera u
                where ur.roleid=v_roleid and u.id=ur.userid
               order by u.username) loop
      r:=r||','||ii.username;
    end loop;  
    return ltrim(r,',');
  end;
  
  --вставить запись в журнал  --20 09 2021
  function toLog(v_logresultid in number, v_logeventid in number, v_userid in number, v_token in varchar2, v_restapi in varchar2, v_ip in varchar2, v_whence in varchar2, v_target in varchar2, v_operation in varchar2, v_record in varchar2) return number
  is
    v_id number;
  begin
    --вставка записи в журнал
   insert into auth.log
    (log.id, log.logresultid, log.logeventid, log.userid, log.token, log.restapi, log.ip, log.whence, log.target, log.operation, log.record)
   values
    (auth.sq_log.nextval, v_logresultid, v_logeventid, v_userid, v_token, v_restapi, v_ip, v_whence, v_target, v_operation, v_record)
   returning log.id into v_id;
   return v_id;
  end;  
  
  --создать новую роль --13 09 2021
  function createRole(v_name in varchar2,v_description in varchar2,v_rights in typeIDs) return number
  is
    v_roleid number;
  begin
    insert into auth.role (id, name, description)
    values (auth.sq_role.nextval, v_name, v_description)
    returning id into v_roleid;
    for ii in (select COLUMN_VALUE v_rightid from table(v_rights)) loop
      insert into auth.roleright(id,roleid,rightid)
      values (auth.sq_roleright.nextval,v_roleid, ii.v_rightid);
    end loop;
    return v_roleid;
  end;
  
  --изменить роль --14 09 2021
  procedure updateRole(v_roleid in number,v_name in varchar2,v_description in varchar2,v_rights in typeIDs)
  is
  begin
    update auth.role 
    set name=v_name, description=v_description
    where id=v_roleid;
    if SQL%NOTFOUND then
       raise_application_error(-20000,'Не могу изменить отсутсвующую роль id='||to_char(v_roleid));
    end if;      
    delete from auth.roleright where roleid=v_roleid;
    for ii in (select COLUMN_VALUE v_rightid from table(v_rights)) loop
      insert into auth.roleright(id,roleid,rightid)
      values (auth.sq_roleright.nextval,v_roleid, ii.v_rightid);
    end loop;
  end;  
  
  --удалить роль --14 09 2021
  procedure deleteRole(v_roleid in number)
  is
  begin
    delete from auth.roleright where roleid=v_roleid;
    delete from auth.role where id=v_roleid;
    if SQL%NOTFOUND then
       raise_application_error(-20000,'Не могу удалить отсутсвующую роль id='||to_char(v_roleid));
    end if;   
  end;  
  
  --создать нового пользователя --14 09 2021
  function createUser(v_login in varchar2,v_username in varchar2,v_position in varchar2,v_subdivision in varchar2,v_description in varchar2,v_roles in typeIDs) return number
  is
    v_userid number;
  begin
    insert into auth.usera(id,login,username,position,subdivision,description)
    values( auth.sq_usera.nextval,v_login,v_username,v_position,v_subdivision,v_description)
    returning id into v_userid;
    for ii in (select COLUMN_VALUE v_roleid from table(v_roles)) loop
      insert into auth.userrole(id,userid,roleid)
      values (auth.sq_userrole.nextval,v_userid, ii.v_roleid);
    end loop;
    return v_userid;
  end;
  
  --изменить пользователя --14 09 2021
  procedure updateUser(v_userid in number,v_login in varchar2,v_username in varchar2,v_position in varchar2,v_subdivision in varchar2,v_description in varchar2,v_roles in typeIDs)
  is
  begin
    update auth.usera u
    set u.login=v_login, u.username=v_username, u.position=v_position, u.subdivision=v_subdivision, description=v_description
    where id=v_userid;
    if SQL%NOTFOUND then
       raise_application_error(-20000,'Не могу изменить отсутвующуего пользователя id='||to_char(v_userid));
    end if;       
    delete from auth.userrole where userid=v_userid;
    for ii in (select COLUMN_VALUE v_roleid from table(v_roles)) loop
      insert into auth.userrole(id,userid,roleid)
      values (auth.sq_userrole.nextval,v_userid, ii.v_roleid);
    end loop;
  end;  
  
  --удалить пользователя --14 09 2021
  procedure deleteUser(v_userid in number)
  is
  begin
    delete from auth.userrole where userid=v_userid;
    delete from auth.usera where id=v_userid;
    if SQL%NOTFOUND then
       raise_application_error(-20000,'Не могу удалить отсутвующуего пользователя id='||to_char(v_userid));
    end if;      
  end; 
  
  --включить выключить аккаунт --14 09 2021
  procedure activeUser(v_userid in number, v_activeto in date)
  is
  begin
    update auth.usera u set u.activeto=v_activeto where u.id=v_userid;
  end;
  
end PKGAUTH;
/
grant execute on AUTH.PKGAUTH to GEOUSER;



prompt Done
spool off
set define on
