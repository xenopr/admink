<template>
  <v-container>
    <v-dialog
      v-model="dialog"
      persistent
      max-width="1000px"
      max-height="1000px"
      min-height="800px"
    >
      <v-card class="pa-2" outlined>
        <v-card-title class="text-h6">{{ title }}</v-card-title>
        <v-card-subtitle class="text-h7">{{ subtitle }}</v-card-subtitle>
        <v-row>
          <v-col md="10">
            <v-autocomplete
              v-model="searchmodel"
              prepend-icon="mdi-magnify"
              :loading="searchload"
              :items="searchitems"
              :search-input.sync="searchad"
              placeholder="найти и заполнить..."
              hide-no-data
              item-text="displayName"
              item-value="mail"
              return-object
            >
            </v-autocomplete>
          </v-col>
        </v-row>
        <v-row dense>
          <v-col md="10">
            <v-text-field
              v-model="edt.login"
              label="Логин"
              required
            ></v-text-field>
            <v-text-field
              v-model="edt.username"
              label="ФИО"
              required
            ></v-text-field>
            <v-text-field
              v-model="edt.position"
              label="Должность"
            ></v-text-field>
            <v-text-field
              v-model="edt.subdivision"
              label="Подразделение"
            ></v-text-field>
            <v-text-field v-model="edt.description" label="Описание">
            </v-text-field>
          </v-col>
        </v-row>
        <v-row dense>
          <v-col md="10">
            <div v-for="item in roles" v-bind:key="item.ID">
              <v-row dense>
                <v-col md="2"> </v-col>
                <v-col md="5">
                  <v-checkbox
                    dense
                    :label="item.NAME"
                    :value="item.ID"
                    v-model="edt.roles"
                  >
                  </v-checkbox>
                </v-col>
                <v-col md="5" text-align: center> {{ item.DESCRIPTION }}</v-col>
              </v-row>
            </div>
          </v-col>
        </v-row>
        <v-alert type="error" v-if="message">
          {{ message }}
        </v-alert>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="cancel">Отмена</v-btn>
          <v-btn color="blue darken-1" text @click="doit">Сохранить</v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script lang="ts">
import Vue from "vue";
import axios from "axios";
import { typeEdtUser } from "../interfaces/typeauth.js";

export default Vue.extend({
  name: "UserEdtDlg",
  props: {
    dialog: {
      default: false,
    },
    info: {
      type: Object,
    },
  },
  data() {
    return {
      message: "",
      title: "",
      subtitle: "",
      searchmodel: null,
      searchload: false,
      searchitems: [],
      searchad: "",
      edt: {} as typeEdtUser,
      roles: [] as number[],
    };
  },
  watch: {
    dialog(visible) {
      if (visible) {
        this.searchload = false;
        this.searchad = "";
        this.searchmodel = null;
        this.searchitems = [];
        this.message = "";
        this.edt.roles = [];
        this.edt.login = this.info.LOGIN;
        this.edt.username = this.info.USERNAME;
        this.edt.position = this.info.POSITION;
        this.edt.subdivision = this.info.SUBDIVISION;
        this.edt.description = this.info.DESCRIPTION;
        if (this.info.LOGIN == undefined) {
          this.title = "Создать нового пользователя";
          this.subtitle = "";
        } else {
          this.title = "Редактировать пользователя";
          this.subtitle = '"' + this.info.USERNAME + '"';
        }
        axios
          .get(process.env.VUE_APP_RESTSERVER + "/dir/roles", {
            headers: { authorization: this.$store.getters.getToken },
          })
          .then((response) => {
            this.roles = response.data;
            if (this.info.USERROLESIDS) {
              this.edt.roles = this.info.USERROLESIDS.split(",").map(
                (iNum: string) => parseInt(iNum, 10)
              );
            }
          })
          .catch((error) => {
            this.message =
              error?.response?.data?.message || error?.response?.data || error;
          });
      }
    },
    searchad(value) {
      if (this.searchload) return;
      if (this.searchad && this.searchad.length >= 3) {
        this.searchload = true;
        axios
          .get(
            process.env.VUE_APP_RESTSERVER + "/user/findad?q=" + this.searchad,
            {
              headers: { authorization: this.$store.getters.getToken },
            }
          )
          .then((response) => {
            this.searchitems = response.data;
            this.edt.login = response.data[0]?.mail;
            this.edt.username = response.data[0]?.displayName;
            this.edt.position = response.data[0]?.extensionAttribute6 ?? "";
            this.edt.subdivision =
              "" + response.data[0]?.extensionAttribute3 ??
              "" + " " + response.data[0]?.extensionAttribute4 ??
              "" + " " + response.data[0]?.extensionAttribute5 ??
              "";
            this.edt.description = "Автозаполнено " + new Date().toString();
            this.searchload = false;
          })
          .catch((error) => {
            this.searchload = false;
            //this.message =
            //  error?.response?.data?.message || error?.response?.data || error;
          });
      }
    },
  },
  methods: {
    cancel() {
      this.$emit("update:dialog", false);
    },
    doit() {
      if (this.info.LOGIN == undefined) {
        //создаем нового
        axios
          .post(process.env.VUE_APP_RESTSERVER + "/user", this.edt, {
            headers: { authorization: this.$store.getters.getToken },
          })
          .then((response) => {
            this.$emit("update:dialog", false);
            this.$emit("dialogexec");
          })
          .catch((error) => {
            this.message =
              error?.response?.data?.message || error?.response?.data || error;
          });
      } else {
        //изменение
        axios
          .put(
            process.env.VUE_APP_RESTSERVER + "/user/" + this.info.ID,
            this.edt,
            {
              headers: { authorization: this.$store.getters.getToken },
            }
          )
          .then(() => {
            this.$emit("update:dialog", false);
            this.$emit("dialogexec");
          })
          .catch((error) => {
            this.message =
              error?.response?.data?.message || error?.response?.data || error;
          });
      }
    },
  },
});
</script>
