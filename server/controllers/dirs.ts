//контролеры отвечающие за вывод справочников
import express from "express";
import * as dbdirs from "../dbapis/dbdirs.js";

//вернуть справочник прав
export async function getRights(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    const rows = await dbdirs.dbRights();
    res.status(200).json(rows);
  } catch (err) {
    next(err);
  }
}

//вернуть справочник ролей
export async function getRoles(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    const rows = await dbdirs.dbRoles();
    res.status(200).json(rows);
  } catch (err) {
    next(err);
  }
}