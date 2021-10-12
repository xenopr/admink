//контроллеры отвечающие за работу с ролями
import express from "express";
import * as dbrole from "../dbapis/dbrole.js";
import * as log from "../dbapis/dblog.js";

export async function getRole(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    const rows = await dbrole.dbgetRoles(parseInt(req.params.roleid) || null);
    if (rows.length === 0) {
      res.status(404).json(rows);
    } else {
      res.status(200).json(rows);
    }
  } catch (err) {
    next(err);
  }
}

export async function postRole(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    const rows = await dbrole.dbcreateRole(req.body.name, req.body.description, req.body.rights);
    log.toLog(req, log.SUCCESS, log.INSERT, "role", rows, "создал роль", "создал новую роль "+req.body.name+" id="+rows+" дал права "+req.body.rights);
    res.status(201).json(rows);
  } catch (err) {
    res.status(406).json(String(err));
  }
}

export async function putRole(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    await dbrole.dbupdateRole(
      parseInt(req.params.roleid),
      req.body.name,
      req.body.description,
      req.body.rights
    ); 
    log.toLog(req, log.SUCCESS, log.UPDATE, "role", req.params.roleid, "изменил роль", "изменил роль id="+req.params.roleid+" на "+req.body.name+" дал права "+req.body.rights);
    res.status(202).end();
  } catch (err) {
    res.status(404).json(String(err));
  }
}

export async function deleteRole(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    await dbrole.dbdeleteRole(parseInt(req.params.roleid));
    log.toLog(req, log.SUCCESS, log.DELETE, "role", req.params.roleid, "удалил роль", "удалил роль id="+req.params.roleid);
    res.status(204).end();
  } catch (err) {
    res.status(404).json(String(err));
  }
}
