//работа в базе с пользователями
import { simpleExecute, BIND_IN, BIND_OUT, DB_TYPE_NUMBER, DB_TYPE_DATE } from "../services/database.js";

export async function dbgetUsers(userid: number | null) {
  const baseQuery = `
  --список пользователей
  --27 09 2021 29 09 21
  select
    u.id,
    u.login,
    u.username,
    u.position,
    u.subdivision,
    u.description,
    u.activeto,
    (case when sysdate>u.activeto then 0 else 1 end) active,
    (case when u.activeto is null then 0 else 1 end) activechk,
    auth.pkgauth.getUserRoles(u.id) userroles,
    auth.pkgauth.getUserRoles(u.id,'ids') userrolesids
  from
    auth.usera u
  where
    u.id=nvl(:userid,u.id)
  order by
    lower(u.username)
  
  `;
  const binds = { userid: userid };
  const result: any = await simpleExecute(baseQuery, binds);
  return result.rows;
}

export async function dbcreateUser(
  v_login: string,
  v_username: string,
  v_position: string,
  v_subdivision: string,
  v_description: string,
  v_roles: number[]
) {
  const baseQuery = `
    begin
      :v_userid:=auth.pkgauth.createUser(:v_login, :v_username, :v_position, :v_subdivision, :v_description, :v_roles);
    end;  
  `;
  const binds = {
    v_userid: {
      type: DB_TYPE_NUMBER,
      dir: BIND_OUT,
    },
    v_login: v_login,
    v_username: v_username,
    v_position: v_position,
    v_subdivision: v_subdivision,
    v_description: v_description,
    v_roles: {
      type: "AUTH.PKGAUTH.TYPEIDS",
      dir: BIND_IN,
      val: v_roles,
    },
  };
  const result: any = await simpleExecute(baseQuery, binds);
  return result.outBinds.v_userid;
}

export async function dbupdateUser(
  v_userid: number,
  v_login: string,
  v_username: string,
  v_position: string,
  v_subdivision: string,
  v_description: string,
  v_roles: number[]
) {
  const baseQuery = `
    begin
      auth.pkgauth.updateUser(:v_userid, :v_login, :v_username, :v_position, :v_subdivision, :v_description, :v_roles);
    end;  
  `;
  const binds = {
    v_userid: v_userid,
    v_login: v_login,
    v_username: v_username,
    v_position: v_position,
    v_subdivision: v_subdivision,
    v_description: v_description,
    v_roles: {
      type: "AUTH.PKGAUTH.TYPEIDS",
      dir: BIND_IN,
      val: v_roles,
    },
  };
  const result: any = await simpleExecute(baseQuery, binds);
  return result;
}

export async function dbdeleteUser(v_userid: number) {
  const baseQuery = `
    begin
      auth.pkgauth.deleteUser(:v_userid);
    end;  
  `;
  const binds = {
    v_userid: v_userid,
  };
  const result: any = await simpleExecute(baseQuery, binds);
  return result;
}

export async function dbactiveUser(v_userid: number, v_activeto: number) {
  const baseQuery = `
    begin
      auth.pkgauth.activeUser(:v_userid, :v_activeto);
    end;  
  `;
  const binds = {
    v_userid: v_userid,
    v_activeto: {
      type: DB_TYPE_DATE,
      val: v_activeto ? new Date(v_activeto) : null,
    },
  };
  const result: any = await simpleExecute(baseQuery, binds);
  return result;
}
