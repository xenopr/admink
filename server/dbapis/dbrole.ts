//работа в базе с ролями
import { simpleExecute, BIND_IN, BIND_OUT, DB_TYPE_NUMBER } from "../services/database.js";

export async function dbgetRoles(roleid: number | null) {
  const baseQuery = `
  --список ролей
  --15 09 2021 220921
  select
    r.id,
    r.name,
    r.description,
    auth.pkgauth.getRoleUsers(r.id) roleusers,
    auth.pkgauth.getRoleRights(r.id) rolerights,
    auth.pkgauth.getRoleRights(r.id,'ids') rolerightsids
  from
    auth.role r
  where
    r.id=nvl(:roleid,r.id)
  order by
    lower(r.name)
  `;
  const binds = { roleid: roleid };
  const result: any = await simpleExecute(baseQuery, binds);
  return result.rows;
}

export async function dbcreateRole(v_name: string, v_description: string, v_rights: number[]) {
  const baseQuery = `
    begin
      :v_roleid:=auth.pkgauth.createRole(:v_name,:v_description,:v_rights);
    end;  
  `;
  const binds = {
    v_roleid: {
      type: DB_TYPE_NUMBER,
      dir: BIND_OUT,
    },
    v_name: v_name,
    v_description: v_description,
    v_rights: {
      type: "AUTH.PKGAUTH.TYPEIDS",
      dir: BIND_IN,
      val: v_rights,
    },
  };
  const result: any = await simpleExecute(baseQuery, binds);
  return result.outBinds.v_roleid;
}

export async function dbupdateRole(v_roleid: number, v_name: string, v_description: string, v_rights: number[]) {
  const baseQuery = `
    begin
      auth.pkgauth.updateRole(:v_roleid, :v_name,:v_description,:v_rights);
    end;  
  `;
  const binds = {
    v_roleid: v_roleid,
    v_name: v_name,
    v_description: v_description,
    v_rights: {
      type: "AUTH.PKGAUTH.TYPEIDS",
      dir: BIND_IN,
      val: v_rights,
    },
  };
  const result: any = await simpleExecute(baseQuery, binds);
  return result;
}

export async function dbdeleteRole(v_roleid: number) {
  const baseQuery = `
    begin
      auth.pkgauth.deleteRole(:v_roleid);
    end;  
  `;
  const binds = {
    v_roleid: v_roleid,
  };
  const result: any = await simpleExecute(baseQuery, binds);
  return result;
}
