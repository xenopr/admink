prompt PL/SQL Developer Export User Objects for user AUTH@ORCLPDB
prompt Created by ProtasovAA on 29 �������� 2021 �.
set define off
spool ������� AUTH.log

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
  is ' ��� ������� (������, ��������, ���������, ��������)';
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
  is ' ��������� ������� (�����, ������)';
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
  is ' ������������ �������';
comment on column AUTH.USERA.login
  is ' ����� �������� (email)';
comment on column AUTH.USERA.activeto
  is ' ���� ���������������� ��������, ���-����';
comment on column AUTH.USERA.username
  is ' ���';
comment on column AUTH.USERA.subdivision
  is ' �������������';
comment on column AUTH.USERA.position
  is ' ���������';
comment on column AUTH.USERA.description
  is '����������� ������';
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
  is ' ������ �������';
comment on column AUTH.LOG.dt
  is ' ���� ����� �������, ������������';
comment on column AUTH.LOG.logresultid
  is ' ��������� ������� (�����, ������)';
comment on column AUTH.LOG.logeventid
  is ' ��� ������� (�����, ������, ��������, ���������, ��������)';
comment on column AUTH.LOG.userid
  is ' �� ����� ������ �������';
comment on column AUTH.LOG.token
  is ' ����� ����������';
comment on column AUTH.LOG.restapi
  is ' ���� �� ��������� �������';
comment on column AUTH.LOG.ip
  is ' IP �������, ������� ������� �������';
comment on column AUTH.LOG.whence
  is ' ����������, ������� ������� �������';
comment on column AUTH.LOG.target
  is ' ��� ����� �������� ����������';
comment on column AUTH.LOG.operation
  is ' ��� ������� ������� ����������';
comment on column AUTH.LOG.record
  is ' �������� �������, ��� �������';
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
  is ' �������������� ����';
comment on column AUTH.RIGHT.name
  is ' �� �����';
comment on column AUTH.RIGHT.description
  is ' ��������, ��� ���� �����';
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
  is ' ����, ������ ����

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
  is ' ������ ���� � ����';
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
  is ' ������ ����� ��� ������������ �������';
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
  --������� �������� � ���������������

  --���, ������ id ��� �������� ��� ��������
  type typeIDs is table of number;
  
  --�������� ������ ����� ������������, ids-��������������
  function getUserRoles(user_id number, v_type varchar2 default 'str') return varchar2;
  
  --�������� ������ ���� ������������
  function getUserRights(user_id number) return varchar2;
  
  --�������� ������ ���� ���� str-������������, ids-��������������
  function getRoleRights(v_roleid number, v_type varchar2 default 'str') return varchar2;
 
  --�������� ������ ������������� ���� 
  function getRoleUsers(v_roleid number) return varchar2; 
  
  --�������� ������ � ������
  function toLog(v_logresultid in number, v_logeventid in number, v_userid in number, v_token in varchar2, v_restapi in varchar2, v_ip in varchar2, v_whence in varchar2, v_target in varchar2, v_operation in varchar2, v_record in varchar2) return number;
  
  --CRUD ����� 
  --������� ����� ����
  --�� ����� ������������, ��������, ������ � �������� id ����. ��������� id ����� ����
  function createRole(v_name in varchar2, v_description in varchar2, v_rights in typeIDs) return number;
  --�������� ���� 
  procedure updateRole(v_roleid in number, v_name in varchar2, v_description in varchar2, v_rights in typeIDs);
  --������� ���� 
  procedure deleteRole(v_roleid in number);
  
  --CRUD �������������
  --������� ������ ������������ 
  function createUser(v_login in varchar2,v_username in varchar2,v_position in varchar2,v_subdivision in varchar2,v_description in varchar2,v_roles in typeIDs) return number;
  --�������� ������������ 
  procedure updateUser(v_userid in number,v_login in varchar2,v_username in varchar2,v_position in varchar2,v_subdivision in varchar2,v_description in varchar2,v_roles in typeIDs); 
  --������� ������������
  procedure deleteUser(v_userid in number);
  --�������� ��������� �������
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

  --�������� ������ ����� ������������
  --str-������������, ids-�������������� 270921
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
  
  --�������� ������ ���� ������������
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
  
  --�������� ������ ���� ����  --15 09 2021 --� JS ������ split - ������� ������ 
  --str-������������, ids-�������������� 220921
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

  --�������� ������ ������������� ����  --15 09 2021 --� JS ������ split - ������� ������ 
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
  
  --�������� ������ � ������  --20 09 2021
  function toLog(v_logresultid in number, v_logeventid in number, v_userid in number, v_token in varchar2, v_restapi in varchar2, v_ip in varchar2, v_whence in varchar2, v_target in varchar2, v_operation in varchar2, v_record in varchar2) return number
  is
    v_id number;
  begin
    --������� ������ � ������
   insert into auth.log
    (log.id, log.logresultid, log.logeventid, log.userid, log.token, log.restapi, log.ip, log.whence, log.target, log.operation, log.record)
   values
    (auth.sq_log.nextval, v_logresultid, v_logeventid, v_userid, v_token, v_restapi, v_ip, v_whence, v_target, v_operation, v_record)
   returning log.id into v_id;
   return v_id;
  end;  
  
  --������� ����� ���� --13 09 2021
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
  
  --�������� ���� --14 09 2021
  procedure updateRole(v_roleid in number,v_name in varchar2,v_description in varchar2,v_rights in typeIDs)
  is
  begin
    update auth.role 
    set name=v_name, description=v_description
    where id=v_roleid;
    if SQL%NOTFOUND then
       raise_application_error(-20000,'�� ���� �������� ������������ ���� id='||to_char(v_roleid));
    end if;      
    delete from auth.roleright where roleid=v_roleid;
    for ii in (select COLUMN_VALUE v_rightid from table(v_rights)) loop
      insert into auth.roleright(id,roleid,rightid)
      values (auth.sq_roleright.nextval,v_roleid, ii.v_rightid);
    end loop;
  end;  
  
  --������� ���� --14 09 2021
  procedure deleteRole(v_roleid in number)
  is
  begin
    delete from auth.roleright where roleid=v_roleid;
    delete from auth.role where id=v_roleid;
    if SQL%NOTFOUND then
       raise_application_error(-20000,'�� ���� ������� ������������ ���� id='||to_char(v_roleid));
    end if;   
  end;  
  
  --������� ������ ������������ --14 09 2021
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
  
  --�������� ������������ --14 09 2021
  procedure updateUser(v_userid in number,v_login in varchar2,v_username in varchar2,v_position in varchar2,v_subdivision in varchar2,v_description in varchar2,v_roles in typeIDs)
  is
  begin
    update auth.usera u
    set u.login=v_login, u.username=v_username, u.position=v_position, u.subdivision=v_subdivision, description=v_description
    where id=v_userid;
    if SQL%NOTFOUND then
       raise_application_error(-20000,'�� ���� �������� ������������� ������������ id='||to_char(v_userid));
    end if;       
    delete from auth.userrole where userid=v_userid;
    for ii in (select COLUMN_VALUE v_roleid from table(v_roles)) loop
      insert into auth.userrole(id,userid,roleid)
      values (auth.sq_userrole.nextval,v_userid, ii.v_roleid);
    end loop;
  end;  
  
  --������� ������������ --14 09 2021
  procedure deleteUser(v_userid in number)
  is
  begin
    delete from auth.userrole where userid=v_userid;
    delete from auth.usera where id=v_userid;
    if SQL%NOTFOUND then
       raise_application_error(-20000,'�� ���� ������� ������������� ������������ id='||to_char(v_userid));
    end if;      
  end; 
  
  --�������� ��������� ������� --14 09 2021
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
