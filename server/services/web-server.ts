import * as http from "http";
import express from "express";
import morgan from "morgan";
import cors from "cors";
import { router } from "./router.js";
import { webServerConfig } from "../config/web-server.js";

let httpServer: http.Server;

export function initialize() {
  return new Promise<void>((resolve, reject) => {
    const app = express();
    httpServer = http.createServer(app);
    app.use(morgan("combined"));
    app.use(cors());
    // Parse incoming JSON requests and revive JSON.
    app.use(
      express.json({
        reviver: reviveJson,
      })
    );
    app.use("/", router);

    httpServer
      .listen(webServerConfig.port)
      .on("listening", () => {
        console.log(
          `Web server listening on localhost:${webServerConfig.port}`
        );
        resolve();
      })
      .on("error", (err) => {
        reject(err);
      });
  });
}

export function close() {
  return new Promise<void>((resolve, reject) => {
    httpServer.close((err) => {
      if (err) {
        reject(err);
        return;
      }
      resolve();
    });
  });
}

const iso8601RegExp = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{3})?Z$/;

function reviveJson(key: any, value: string | number | Date) {
  // revive ISO 8601 date strings to instances of Date
  if (typeof value === "string" && iso8601RegExp.test(value)) {
    return new Date(value);
  } else {
    return value;
  }
}
