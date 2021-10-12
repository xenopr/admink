import express from "express";
import NodeRSA from "node-rsa";
import { findUser, loginAuthentificate } from "../services/ad.js";
import { findLogin } from "../dbapis/dbauth.js";
import { generateToken } from "../services/token.js";
import { typeResult, typeLogin, typeToken } from "../interfaces/typeauth.js";
import * as log from "../dbapis/dblog.js";

export async function post(
  req: express.Request,
  res: express.Response,
  next: express.NextFunction
) {
  const key = new NodeRSA({ b: 512 });
  key.importKey(process.env.PRIVATEKEY || "no key");
  try {
    let result: typeResult = {
      token: "",
      error: "текст сообщения причины отказа в авторизации",
      level: "текст этапа авторизации",
    };
    try {
      result.level = "Получение шифрованного запроса на авторизацию...";
      const encrypted: string = req.body.login;
      if (!encrypted) throw "Не передан запрос авторизации.";
      let loginobj: typeLogin;
      try {
        result.level = "Дешифрация запроса авторизации...";
        loginobj = JSON.parse(key.decrypt(encrypted, "utf8"));
      } catch (error) {
        throw "Неверный ключ шифрования запроса авторизации.";
      }
      result.level = "Проверка срока действия запроса авторизации...";
      if (isNaN(Date.parse(loginobj.date)))
        throw "Дата время запроса переданы неверно.";
      if (new Date().valueOf() - Date.parse(loginobj.date) > 60000)
        throw "Истек срок в 1 минуту жизни запроса авторизации.";
      if (new Date().valueOf() - Date.parse(loginobj.date) < -10000)
        throw "Запрос авторизации создан в будущем.";
      result.level = "Проверка наличия пользователя в AD...";
      let findeduser: any;
      try {
        findeduser = await findUser(loginobj.login);
      } catch (error) {
        console.log("Ошибка настройки сервиса авторизации в AD.", error);
        throw "Ошибка настройки сервиса авторизации в AD.";
      }
      if (!findeduser) throw "Нет пользователя " + loginobj.login + " в AD.";
      result.level = "Аутентификация в AD...";
      try {
        await loginAuthentificate(loginobj);
      } catch (error) {
        throw "Неверный пароль пользователя " + loginobj.login + " .";
      }
      result.level = "Проверка наличия доступа в БД...";
      let findedlogin: any;
      findedlogin = await findLogin(findeduser.mail);
      //console.log(findedlogin);
      if (findedlogin.length === 0)
        throw "Пользователю " + loginobj.login + " доступ запрещен.";
      if (findedlogin.ACTIVE === 0)
        throw "Пользователю " + loginobj.login + " доступ отключен.";
      //создаем объект токена, информация о залогинившимся пользователе с его правами
      let tokenobj: typeToken = {
        userid: findedlogin[0].ID,
        login: findedlogin[0].LOGIN,
        username: findedlogin[0].USERNAME,
        subdivision: findedlogin[0].SUBDIVISION,
        position: findedlogin[0].POSITION,
        description: findedlogin[0].DESCRIPTION,
        roles: (findedlogin[0].USERROLES ?? "").split(","),
        rights: (findedlogin[0].USERRIGHTS ?? "").split(","),
      };
      result.level = "Создание JWT-токена...";
      const tokenstr = generateToken(tokenobj);
      result.level = "Авторизация завершена успешно.";
      result.token = tokenstr;
      result.error = "";
      //здесь будет запись в лог события логон (асинхронно)
      log.toLog(
        req,
        log.SUCCESS,
        log.LOGIN,
        "auth",
        "",
        result.level,
        "Авторизация пользователя " + loginobj.login + " успешна.",
        tokenstr
      );
      res.status(200).json(result);
    } catch (err) {
      //здесь будет запись в лог события отказа в логоне (асинхронно)
      result.error = String(err);
      log.toLog(
        req,
        log.FAILED,
        log.LOGIN,
        "auth",
        "",
        result.level,
        "Отказ в доступе, этап: " + result.level + " ошибка: " + result.error
      );
      res.status(401).json(result);
    }
  } catch (err) {
    console.log("Необработана ошибка при авторизации: ", err);
    res.status(403).json(err);
  }
}

export async function del(req: express.Request, res: express.Response, next: express.NextFunction) {
  try {
    log.toLog(
      req,
      log.SUCCESS,
      log.LOGOUT,
      "auth",
      "",
      'Деавторизация',
      "Выход пользователя."
    );
    res.status(200).end();
  } catch (err) {
    next(err);
  }
}