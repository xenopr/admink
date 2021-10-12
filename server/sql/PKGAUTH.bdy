create or replace package body PKGAUTH is

  --получить список ролей пользователя
  function getUserRoles(user_id number) return varchar2
  is
    r varchar(4000) default '';
  begin
    for ii in (select r.name 
                 from auth.userrole ur, auth.role r 
                where ur.userid=user_id and r.id=ur.roleid 
               order by r.name) loop
      r:=r||','||ii.name;
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
