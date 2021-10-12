//контроллеры отвечающие за работу с редактором пользователей
import express from "express";
import * as dbuser from "../dbapis/dbuser.js";
import * as log from "../dbapis/dblog.js";
import * as ad from "../services/ad.js";

export async function getUser(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    const rows = await dbuser.dbgetUsers(parseInt(req.params.userid) || null);
    if (rows.length === 0) {
      res.status(404).json(rows);
    } else {
      res.status(200).json(rows);
    }
  } catch (err) {
    next(err);
  }
}

export async function postUser(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    const rows = await dbuser.dbcreateUser(
      req.body.login,
      req.body.username,
      req.body.position,
      req.body.subdivision,
      req.body.description,
      req.body.roles
    );
    log.toLog(
      req,
      log.SUCCESS,
      log.INSERT,
      "user",
      rows,
      "создал пользователя",
      "создал нового пользователя " + req.body.username + " id=" + rows + " дал роли " + req.body.roles
    );
    res.status(201).json(rows);
  } catch (err) {
    res.status(406).json(String(err));
  }
}

export async function putUser(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    await dbuser.dbupdateUser(
      parseInt(req.params.userid),
      req.body.login,
      req.body.username,
      req.body.position,
      req.body.subdivision,
      req.body.description,
      req.body.roles
    );
    log.toLog(
      req,
      log.SUCCESS,
      log.UPDATE,
      "user",
      req.params.userid,
      "изменил пользователя",
      "изменил пользователя id=" + req.params.userid + " на " + req.body.username + " дал роли " + req.body.roles
    );
    res.status(202).end();
  } catch (err) {
    res.status(404).json(String(err));
  }
}

export async function deleteUser(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    await dbuser.dbdeleteUser(parseInt(req.params.userid));
    log.toLog(
      req,
      log.SUCCESS,
      log.DELETE,
      "user",
      req.params.userid,
      "удалил пользователя",
      "удалил пользователя id=" + req.params.userid
    );
    res.status(204).end();
  } catch (err) {
    res.status(404).json(String(err));
  }
}

export async function findAD(req: express.Request, res: express.Response, next: express.NextFunction) {
  let q: string = req.query.q+"";
  if (q.length >= 3) {
    try {
      //ищем в ad среди юзеров по email либо по отображаемому ФИО с присутсвующим email
      q="(&(objectCategory=person)(objectClass=user)(|(mail="+q+"*)(&(displayName="+q+"*)(mail=*))))";
      const rows = await ad.findUsers(q);
        res.status(200).json(rows);
    } catch (err) {
      res.status(404).json(err);
    }
  } else {
    res.status(404).end();
  }
}

export async function activeUser(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    await dbuser.dbactiveUser(parseInt(req.params.userid),Date.parse(req.body.activeto));
    log.toLog(
      req,
      log.SUCCESS,
      log.UPDATE,
      "user",
      req.params.userid,
      "изменил пользователя",
      "аккаунт пользователя id=" + req.params.userid + " действует до "+req.body.activeto
    );
    res.status(202).end();
  } catch (err) {
    res.status(404).json(String(err));
  }
}