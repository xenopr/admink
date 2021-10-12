//запросы в базу за справочниками
import { simpleExecute } from "../services/database.js";

export async function dbRights() {
  const baseQuery = `
    select r.id,r.name,r.description from auth.right r order by r.name
  `;
  const result: any = await simpleExecute(baseQuery, {});
  return result.rows;
}

export async function dbRoles() {
  const baseQuery = `
    select r.id,r.name,r.description from auth.role r order by r.name
  `;
  const result: any = await simpleExecute(baseQuery, {});
  return result.rows;
}