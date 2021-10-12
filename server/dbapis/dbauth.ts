import {simpleExecute} from '../services/database.js';

export async function findLogin(loginname: string) {
  const baseQuery = `
  --запрос перечня прав пользователя
  --для auth
  --протасов аа
  --11 08 2021
  --03 09 2021
  select 
     u.*,
     auth.pkgauth.getUserRoles(u.id) userroles,
     auth.pkgauth.getUserRights(u.id) userrights,
     (case when sysdate>u.activeto then 0 else 1 end) active
   from
     auth.usera u           
  where
     lower(u.login)=lower(:loginname)
  `;
  const binds = { loginname: loginname };
  const result:any = await simpleExecute(baseQuery, binds);
  return result.rows;
}
