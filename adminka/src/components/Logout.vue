<template>
  <v-container fluid fill-height>
    <v-layout align-center justify-center>
      <v-flex xs12 sm8 md6>
        <v-card class="elevation-12">
          <v-toolbar dark color="primary">
            <v-toolbar-title>Выход</v-toolbar-title>
          </v-toolbar>

          <v-card-text>
            {{ $store.getters.getUser.username }}<br />
            {{ $store.getters.getUser.position }}<br />
            {{ $store.getters.getUser.subdivision }}<br />
            <v-alert type="error" v-if="message">
              {{ message }}
            </v-alert>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="primary" @click="goback">Отмена</v-btn>
            <v-btn color="primary" @click="logout">Выход</v-btn>
          </v-card-actions>
        </v-card>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script lang="ts">
import Vue from "vue";
import { typeResult } from "../interfaces/typeauth.js";
import axios from "axios";

export default Vue.extend({
  name: "Logout",
  data() {
    return {
      message: "",
      login: "",
      password: "",
    };
  },
  props: {
    source: String,
  },
  methods: {
    goback() {
      this.$router.go(-1);
    },
    logout() {
      let r: typeResult;
      axios
        .delete(process.env.VUE_APP_RESTSERVER + "/auth", {
          headers: { authorization: this.$store.getters.getToken },
        })
        .then((response) => {
          r = response.data;
          this.$store.dispatch("setToken", "");
          this.message = r.error;
          this.$router.push("/");
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
