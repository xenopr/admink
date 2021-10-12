import express from "express";
import * as dblog from "../dbapis/dblog.js";

export async function get100Log(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    const rows = await dblog.dbget100Log();
    res.status(200).json(rows);
  } catch (err) {
    next(err);
  }
}

export async function getLog(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    const rows = await dblog.dbgetLog(
      Date.parse(req.query.dtf+""),
      Date.parse(req.query.dtt+"")
    );
    res.status(200).json(rows);
  } catch (err) {
    next(err);
  }
}
