//функции работы с БД. Инициализации, останов и выполнения произвольного sql
import oracledb from "oracledb";
import { dbConfig } from "../config/database.js";

export const DB_TYPE_NUMBER=oracledb.DB_TYPE_NUMBER;
export const DB_TYPE_DATE=oracledb.DB_TYPE_DATE;
export const BIND_OUT=oracledb.BIND_OUT;
export const BIND_IN=oracledb.BIND_IN;

export async function initialize() {
  // Increase thread pool size by poolMax
  const defaultThreadPoolSize = 4;
  process.env.UV_THREADPOOL_SIZE = String(dbConfig.poolMax + defaultThreadPoolSize);
  //console.log(dbConfig);
  await oracledb.createPool(dbConfig);
  oracledb.autoCommit = true;
  oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
}

export async function close() {
  await oracledb.getPool().close();
}

export function simpleExecute(statement: string, binds: oracledb.BindParameters) {
  return new Promise(async (resolve, reject) => {
    let conn: oracledb.Connection | undefined;
    try {
      conn = await oracledb.getConnection();
      let result = await conn.execute(statement, binds);
      resolve(result);
    } catch (err) {
      reject(err);
    } finally {
      if (conn) await conn.close();
    }
  });
}
