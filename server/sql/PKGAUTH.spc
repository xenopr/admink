create or replace package PKGAUTH is
  --Created : 03.09.2021 14:20:10
  --������� �������� � ���������������

  --���, ������ id ��� �������� ��� ��������
  type typeIDs is table of number;
  
  --�������� ������ ����� ������������
  function getUserRoles(user_id number) return varchar2;
  
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
