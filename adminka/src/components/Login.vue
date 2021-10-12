<template>
  <v-container fluid fill-height>
    <v-layout align-center justify-center>
      <v-flex xs12 sm8 md6>
        <v-card class="elevation-12">
          <v-toolbar dark color="primary">
            <v-toolbar-title>Авторизация</v-toolbar-title>
          </v-toolbar>
          <v-card-text>
            <v-form>
              <v-text-field
                name="login"
                label="Введите Email"
                type="text"
                v-model="login"
              ></v-text-field>
              <v-text-field
                id="password"
                name="password"
                label="Введите пароль"
                type="password"
                v-model="password"
                v-on:keyup.enter="logon"
              ></v-text-field>
            </v-form>
            <v-alert type="error" v-if="message">
              {{ message }}
            </v-alert>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="primary" @click="goback">Отмена</v-btn>
            <v-btn color="primary" @click="logon">Войти</v-btn>
          </v-card-actions>
        </v-card>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script lang="ts">
import Vue from "vue";
import { typeResult, typeLogin, typeToken } from "../interfaces/typeauth.js";
import axios from "axios";
import NodeRSA from "node-rsa";
// import jwt from "jsonwebtoken";

export default Vue.extend({
  name: "Login",
  data() {
    return {
      message: "",
      login: "",
      password: "",
    };
  },
  methods: {
    goback() {
      this.$router.go(-1);
    },
    logon() {
      //этот объект зашифруем и отправим на rest-сервер
      const obj: typeLogin = {
        login: this.login,
        password: this.password,
        date: String(new Date()),
      };
      //шифруем публичным ключом
      const key = new NodeRSA({ b: 512 });
      key.importKey(process.env.VUE_APP_PUBLICKEY || "");
      let encrypted: string = key.encrypt(obj, "base64");
      //отправка в rest-сервер запроса на аутентификацию
      let r: typeResult;
      axios
        .post(process.env.VUE_APP_RESTSERVER + "/auth", { login: encrypted })
        .then((response) => {
          r = response.data;
          this.$store.dispatch("setToken", r.token);
          this.$router.go(-1);
        })
        .catch((error) => {
          r = error.response.data;
          this.$store.dispatch("setToken", "");
          if (r.error) {
            this.message = r.level + " " + r.error;
          } else {
            this.message = error;
          }
        });
    },
  },
});
</script>

<style></style>
