import "dotenv/config";

import {
  initialize as initializeWeb,
  close as closeWeb,
} from "./services/web-server.js";

import {
  initialize as initializeDB,
  close as closeDB,
} from "./services/database.js";
import * as log from "./dbapis/dblog.js";

async function startup() {
  console.log("Starting application");
  try {
    console.log("Initializing database module");
    await initializeDB();
  } catch (err) {
    console.error(err);
    process.exit(1); // Non-zero failure code
  }
  try {
    console.log("Initializing web server module");
    await initializeWeb();
  } catch (err) {
    console.error(err);
    process.exit(1); // Non-zero failure code
  }
  await log.toLogStartStop(log.START);
}

startup();

async function shutdown(e: object) {
  let err = e;
  console.log("Shutting down");
  await log.toLogStartStop(log.STOP);
  try {
    console.log("Closing web server module");
    await closeWeb();
  } catch (e) {
    console.log("Encountered error", e);
    err = err || e;
  }

  try {
    console.log("Closing database module");
    await closeDB();
  } catch (err) {
    console.log("Encountered error", e);
    err = err || e;
  }

  console.log("Exiting process");
  if (err) {
    process.exit(1); // Non-zero failure code
  } else {
    process.exit(0);
  }
}

process.on("SIGTERM", () => {
  console.log("Received SIGTERM");
  shutdown({});
});

process.on("SIGINT", () => {
  console.log("Received SIGINT");
  shutdown({});
});

process.on("uncaughtException", (err) => {
  console.log("Uncaught exception");
  console.error(err);
  shutdown(err);
});
