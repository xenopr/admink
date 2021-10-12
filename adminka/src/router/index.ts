import Vue from "vue";
import VueRouter, { RouteConfig } from "vue-router";
//import Home from "../views/Home.vue";
import Dirs from "../components/Dirs.vue";
import Logs from "../components/Logs.vue";
import Test from "../components/Test.vue";
import Login from "../components/Login.vue";
import Logout from "../components/Logout.vue";
import About from "../components/About.vue";

Vue.use(VueRouter);

const routes: Array<RouteConfig> = [
  // {
  //   path: "/",
  //   name: "Home",
  //   component: Home,
  // },
  {
    path: "/about",
    component: About,
  },
  {
    path: "/",
    component: About,
  },
  {
    path: "/dirs",
    name: "Dirs",
    component: Dirs,
  },
  {
    path: "/logs",
    name: "Logs",
    component: Logs,
  },
  {
    path: "/test",
    name: "Test",
    component: Test,
  },
  {
    path: "/login",
    name: "Login",
    component: Login,
  },
  {
    path: "/logout",
    name: "Logout",
    component: Logout,
  },  
];

const router = new VueRouter({
  routes,
});

export default router;
