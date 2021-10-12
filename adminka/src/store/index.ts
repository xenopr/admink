import { typeToken } from "../interfaces/typeauth.js";
import Vue from "vue";
import Vuex, { Store } from "vuex";
import jwt from "jsonwebtoken";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    TOKEN: window.localStorage.getItem("token"),
  },
  mutations: {
    async updateToken(state, token: string) {
      state.TOKEN=token;
      window.localStorage.setItem("token", token);
    },
  },
  actions: {
    setToken(context, token: string) {
      context.commit("updateToken", token);
    },
  },
  getters: {
    getToken(state) {
      return state.TOKEN;
    },
    getUser(state) {
      const t: any = jwt.decode(state.TOKEN || "");
      const r: typeToken = {
        userid: t?.userid ?? 0,
        login: t?.login ?? "",
        username: t?.username ?? "",
        subdivision: t?.subdivision ?? "",
        position: t?.position ?? "",
        description: t?.description ?? "",
        roles: t?.roles ?? [""],
        rights: t?.rights ?? [""],
      };
      return r;
    },
  },
  modules: {},
});
