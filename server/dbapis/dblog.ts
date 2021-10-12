import { simpleExecute, BIND_OUT, DB_TYPE_NUMBER, DB_TYPE_DATE } from "../services/database.js";
import { decodeToken } from "../services/token.js";
import { typeToken } from "../interfaces/typeauth.js";
import express from "express";

export const SUCCESS = 1;
export const FAILED = 2;

export const LOGIN = 1;
export const LOGOUT = 2;
export const START = 3;
export const STOP = 4;
export const ACCESS = 5;
export const TEST = 10;
export const INSERT = 11;
export const UPDATE = 12;
export const DELETE = 13;

//вызываем из контроллеров
//всю инфу о том кто и что пытался сделать получаем из http-запроса, из req
export async function toLog(
  req: express.Request,
  logresultid: number,
  logeventid: number,
  whence: string,
  target: string,
  operation: string,
  record: string,
  token: string | undefined = undefined
) {
  const baseQuery = `
  begin
    :v_id:=auth.pkgauth.toLog(:v_logresultid,:v_logeventid,:v_userid,:v_token,:v_restapi,:v_ip,:v_whence,:v_target,:v_operation,:v_record);
  end;
  `;
  try {
    const tokenobj: typeToken = decodeToken(token || req.headers.authorization);
    const binds = {
      v_id: {
        type: DB_TYPE_NUMBER,
        dir: BIND_OUT,
      },
      v_logresultid: logresultid,
      v_logeventid: logeventid,
      v_userid: tokenobj?.userid,
      v_token: token || req.headers.authorization,
      v_restapi: req.method + " " + req.originalUrl,
      v_ip: req.ip.split("::ffff:").slice(-1)[0],
      v_whence: whence,
      v_target: target,
      v_operation: operation,
      v_record: record,
    };
    const result: any = await simpleExecute(baseQuery, binds);
    return result.outBinds.v_id;
  } catch (error) {
    console.log("Ошибка записи в журнал", error);
  }
}

// вызываем из index, req нет по определению
// старт стоп REST-сервера
export async function toLogStartStop(logeventid: number) {
  const baseQuery = `
  begin
    :v_id:=auth.pkgauth.toLog(:v_logresultid,:v_logeventid,:v_userid,:v_token,:v_restapi,:v_ip,:v_whence,:v_target,:v_operation,:v_record);
  end;
  `;
  try {
    const binds = {
      v_id: {
        type: DB_TYPE_NUMBER,
        dir: BIND_OUT,
      },
      v_logresultid: SUCCESS,
      v_logeventid: logeventid,
      v_userid: null,
      v_token: null,
      v_restapi: null,
      v_ip: null,
      v_whence: "server",
      v_target: null,
      v_operation: null,
      v_record: null,
    };
    const result: any = await simpleExecute(baseQuery, binds);
    return result.outBinds.v_id;
  } catch (error) {
    console.log("Ошибка записи в журнал", error);
  }
}

//простой запрос последних 100 строк из журнала
export async function dbget100Log() {
  const baseQuery = `
  --посмотреть журнал
  --06 09 2021 --230921
  select 
   l.id,
   l.dt,
   to_char(l.dt,'dd.mm.yy hh24:mi:ss') tstamp,
   lr.namerus namer,
   le.namerus namee,
   (case when instr(u.username,' ',-1)>0 
         then substr(u.username,1,instr(u.username,' ')-1)||substr(u.username,instr(u.username,' '),2)||'.'||substr(u.username,instr(u.username,' ',-1)+1,1)||'.' 
         else u.username end) username,
   l.ip,
   l.restapi,
   l.token,
   l.whence,
   l.target,
   l.operation,
   l.record
  from
    auth.log l
    join auth.logresult lr on lr.id=l.logresultid
    join auth.logevent le on le.id=l.logeventid
    left join auth.usera u on u.id=l.userid
  order by
   l.dt desc
  fetch next 100 rows only  
  
  `;
  const binds = {};
  const result: any = await simpleExecute(baseQuery, binds);
  return result.rows;
}

//запрос строк из журнала за период
export async function dbgetLog(dtf: number, dtt: number) {
  const baseQuery = `
  --посмотреть журнал весь за период
  --24 09 2021
  select 
   l.id,
   l.dt,
   to_char(l.dt,'dd.mm.yy hh24:mi:ss') tstamp,
   lr.namerus namer,
   le.namerus namee,
   (case when instr(u.username,' ',-1)>0 
         then substr(u.username,1,instr(u.username,' ')-1)||substr(u.username,instr(u.username,' '),2)||'.'||substr(u.username,instr(u.username,' ',-1)+1,1)||'.' 
         else u.username end) usernameshort,
   u.username,
   l.ip,
   l.restapi,
   l.token,
   l.whence,
   l.target,
   l.operation,
   l.record
  from
    auth.log l
    join auth.logresult lr on lr.id=l.logresultid
    join auth.logevent le on le.id=l.logeventid
    left join auth.usera u on u.id=l.userid
  where
    trunc(dt) between :dtf and :dtt
    --trunc(dt) between to_date('21.09.2021','dd.mm.yyyy') and to_date('23.09.2021','dd.mm.yyyy')
  order by
   l.dt desc   
    `;
  const binds = {
    dtf: {
      type: DB_TYPE_DATE,
      val: new Date(dtf),
    },
    dtt: {
      type: DB_TYPE_DATE,
      val: new Date(dtt),
    },
  };
  const result: any = await simpleExecute(baseQuery, binds);
  return result.rows;
}
