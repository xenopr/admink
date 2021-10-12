//проверка доступа к роуту на основе переданого токена в секции авторизация http-запроса
import express from "express";
import { typeToken, typeApiAnswer } from "../interfaces/typeauth.js";
import { verifyToken, decodeToken } from "../services/token.js";
import * as log from "../dbapis/dblog.js";

//проверяем, присутсвует ли право в переданом токене в перечне прав переданных в функцию
//т.е. проверяем, что в токене имеется хоть одно право из тех, что разрешают доступ к данному роуту
//также проверяем наличие права на запрет
export function authcheck(rights: string[], rightsban: string[]) {
  return function (req: express.Request, res: express.Response, next: express.NextFunction) {
    if (req.method === "OPTIONS") next();
    let tokenDecode: any;
    try {
      tokenDecode = decodeToken(req.headers.authorization);
      const tokenobj: typeToken = verifyToken(req.headers.authorization);
      let hasRight = false;
      rights.forEach((right) => {
        if (tokenobj.rights.includes(right)) hasRight = true;
      });
      if (!hasRight) {
        //попытка доступа без надлежащих прав
        const r: typeApiAnswer = {
          message: "Пользователю " + tokenobj.username + " запрещено, необходимо наличие " + rights.toString(),
          needrights: rights,   //нужно
          banrights: rightsban, //не нужно
          tokenrights: tokenobj.rights, //указаны в токене
          path: req.method + " " + req.originalUrl, //путь
        };
        log.toLog(req, log.FAILED, log.ACCESS, "middleware", "", "", r.message);
        return res.status(401).json(r);
      }
      hasRight = false;
      rightsban.forEach((right) => {
        if (tokenobj.rights.includes(right)) hasRight = true;
      });
      if (hasRight) {
        //попытка доступа, куда пользователю с данным правом доступ запрещен
        const r: typeApiAnswer = {
          message: "Пользователю " + tokenobj.username + " запрещено, необходимо отсутсвие " + rightsban.toString(),
          needrights: rights, //нужно
          banrights: rightsban, //не нужно
          tokenrights: tokenobj.rights, //указаны в токене
          path: req.method + " " + req.originalUrl, //путь
        };
        log.toLog(req, log.FAILED, log.ACCESS, "middleware", "", "", r.message);
        return res.status(401).json(r);
      }
      next();
    } catch (e) {
      const r: typeApiAnswer = {
        message: "Пользователь не авторизирован",
        needrights: rights, //нужно
        banrights: rightsban, //не нужно
        tokenrights: [],
        path: req.method + " " + req.originalUrl,
      };
      if (tokenDecode) {
        if ("username" in tokenDecode) {
          r.message = "Пользователь " + tokenDecode.username + " не авторизован";
        }
        if ("exp" in tokenDecode) {
          r.message =
            r.message +
            ", истек авторизации до " +
            new Date(tokenDecode.exp * 1000).toLocaleDateString() +
            " " +
            new Date(tokenDecode.exp * 1000).toTimeString();
        }
      }
      log.toLog(req, log.FAILED, log.ACCESS, "middleware", "", "", r.message);
      return res.status(401).json(r);
    }
  };
}
