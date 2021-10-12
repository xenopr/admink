import express from "express";
import { findLogin } from "../dbapis/dbauth.js";
import { getLogin } from "../services/token.js";
//import { getTestRow } from "../dbapis/dbtest.js";
import * as log from "../dbapis/dblog.js";

export async function get(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    const rows = await findLogin(getLogin(req.headers.authorization));
    if (rows.length === 0) {
      res.status(404).end();
    } else {
      log.toLog(req, log.SUCCESS, log.TEST, "test", "testdb", "инфо из БД", "тестовый запрос из базы");
      res.status(200).json(rows);
    }
  } catch (err) {
    next(err);
  }
}
