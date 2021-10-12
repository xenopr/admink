create or replace package PKGAUTH is
  --Created : 03.09.2021 14:20:10
  --Функции связаные с аутентификацией

  --тип, список id для передачи как параметр
  type typeIDs is table of number;
  
  --получить список ролей пользователя
  function getUserRoles(user_id number) return varchar2;
  
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
