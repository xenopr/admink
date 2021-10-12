import {simpleExecute} from '../services/database.js';

export async function getTestRow() {
  const baseQuery = `
  select
  SYS_CONTEXT('USERENV','HOST') fromhost,
  SYS_CONTEXT('USERENV','IP_ADDRESS') fromip,
  SYS_CONTEXT('USERENV','SERVER_HOST') serverhost,
  SYS_CONTEXT('USERENV','SERVICE_NAME') servicename,
  SYS_CONTEXT('USERENV','CURRENT_USER') dbuser,
  to_char(systimestamp) systime,
  replace(to_char(sysdate,'dd month yyyy, day, hh24:mi:ss'),'  ','') sysdat
 from 
  dual
  `;
  const result:any = await simpleExecute(baseQuery,{});
  return result.rows;
}

