import express from "express";
import { findUsers } from "../services/ad.js";
import { getLogin } from "../services/token.js";
import * as log from "../dbapis/dblog.js";

export async function get(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    const users = await findUsers("mail=" + getLogin(req.headers.authorization));
    log.toLog(req, log.SUCCESS, log.TEST, "test", "testad", "инфо из AD", "тестовый запрос из active directory");
    res.status(200).json(users);
  } catch (error) {
    next(error);
  }
}
