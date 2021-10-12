import express from "express";
import { typeToken } from "../interfaces/typeauth.js";
import { decodeToken, checkToken } from "../services/token.js";

export async function get(
  req: express.Request,
  res: express.Response,
  next: express.NextFunction
) {
  try {
    const tokenobj: typeToken = decodeToken(req.headers.authorization);
    if (req.headers.authorization === undefined) {
      res.status(401).json("Токен не передан");
    } else if (tokenobj === null) {
      res.status(401).json("Токен не декодируемый");
    } else if (!checkToken(req.headers.authorization)) {
      res.status(401).json(tokenobj);
    } else {
      res.status(200).json(tokenobj);
    }
  } catch (error) {
    res.status(401).json(error);
  }
}
