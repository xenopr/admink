import express from "express";
export const router = express.Router();
import { authcheck } from "../middleware/authcheck.js";
import { get as testdbGet } from "../controllers/testdb.js";
import { get as testadGet } from "../controllers/testad.js";
import { get as testjwtGet } from "../controllers/testjwt.js";
import { post as authPost } from "../controllers/auth.js";
import { del as authDel } from "../controllers/auth.js";
import * as lg from "../controllers/log.js";

import * as role from "../controllers/role.js"
import * as user from "../controllers/user.js"
import * as dirs from "../controllers/dirs.js"

import * as swaggerUi from "swagger-ui-express";
import YAML from "yamljs";
const swaggerDocument = YAML.load("./config/swagger.yaml");
let swaggerOptions = {
  //explorer: true,
};

router.use("/api-docs", swaggerUi.serve);
router.get("/api-docs", swaggerUi.setup(swaggerDocument, swaggerOptions));

router.route("/").get(function (req: express.Request, res: express.Response) {
  res.send("Hello ! I am GEOREST ! I am live !");
});
router.route("/testdb").get(authcheck(["TEST"],[]), testdbGet);
router.route("/testad").get(authcheck(["TEST"],[]), testadGet);
router.route("/testjwt").get(testjwtGet);
router.route("/log100").get(authcheck(["ADMIN"],[]), lg.get100Log);
router.route("/log").get(authcheck(["ADMIN"],[]), lg.getLog);

router.route("/role/:roleid?").get(authcheck(["ADMIN"],[]),role.getRole);
router.route("/role").post(authcheck(["ADMIN"],["READONLY"]),role.postRole);
router.route("/role/:roleid").put(authcheck(["ADMIN"],["READONLY"]),role.putRole);
router.route("/role/:roleid").delete(authcheck(["ADMIN"],["READONLY"]),role.deleteRole);

router.route("/user/findad").get(authcheck(["ADMIN"],[]),user.findAD);
router.route("/user/:userid?").get(authcheck(["ADMIN"],[]),user.getUser);
router.route("/user").post(authcheck(["ADMIN"],["READONLY"]),user.postUser);
router.route("/user/:userid/activeto").put(authcheck(["ADMIN"],["READONLY"]),user.activeUser);
router.route("/user/:userid").put(authcheck(["ADMIN"],["READONLY"]),user.putUser);
router.route("/user/:userid").delete(authcheck(["ADMIN"],["READONLY"]),user.deleteUser);

router.route("/auth").post(authPost);
router.route("/auth").delete(authDel);

router.route("/dir/rights").get(authcheck(["ADMIN"],[]),dirs.getRights);
router.route("/dir/roles").get(authcheck(["ADMIN"],[]),dirs.getRoles);
