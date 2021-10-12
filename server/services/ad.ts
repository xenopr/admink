//функции работы с active directory
import { typeLogin } from "../interfaces/typeauth.js";
import { adConfig } from "../config/adconfig.js";
import ActiveDirectory from "activedirectory2";

const ad = new ActiveDirectory(adConfig);

export async function loginAuthentificate(loginobj: typeLogin): Promise<any> {
  return new Promise(async (resolve, reject) => {
    ad.authenticate(loginobj.login, loginobj.password, function (err: string, auth: boolean) {
      if (err) reject(err);
      resolve(auth);
    });
  });
}

export async function findUser(username: string): Promise<any> {
  return new Promise(async (resolve, reject) => {
    ad.findUser(username, function (err: object, user: object) {
      if (err) reject(err);
      resolve(user);
    });
  });
}

export async function findUsers(query: string): Promise<any> {
  return new Promise(async (resolve, reject) => {
    try {
      ad.findUsers(query, function (err: object, users: object[]) {
        if (err) reject(err);
        resolve(users);
      });
    } catch (error) {
      console.log(error);
      reject(error);
    }
  });
}
