//export {};
import { typeToken } from "../interfaces/typeauth.js";
import { tokenConfig } from "../config/tokenconfig.js";
import jwt from "jsonwebtoken";

export const generateToken = (tokenobj: typeToken): string => {
  return jwt.sign(tokenobj, tokenConfig.secret, {
    expiresIn: tokenConfig.live
  });
};

export const verifyToken = (tokenstr: string | undefined): typeToken => {
  return jwt.verify(tokenstr || "", tokenConfig.secret) as typeToken;
};

export const checkToken = (tokenstr: string): boolean => {
  try {
    jwt.verify(tokenstr, tokenConfig.secret);
    return true;
  } catch {
    return false;
  }
};

export const decodeToken = (tokenstr: string | undefined): typeToken => {
  return jwt.decode(tokenstr || "") as typeToken;
};

export const getLogin = (tokenstr: string | undefined): string => {
  return decodeToken(tokenstr).login;
};
