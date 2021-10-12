<template>
  <v-container>
    <v-dialog v-model="dialog" persistent max-width="500px">
      <v-card class="pa-2" outlined>
        <v-card-title class="text-h6">{{ title }}</v-card-title>
        <v-text-field
          v-model="edt.name"
          label="Наименование"
          required
        ></v-text-field>
        <v-text-field v-model="edt.description" label="Описание"></v-text-field>
        <div v-for="item in rights" v-bind:key="item.ID">
          <v-row dense>
            <v-col md="2"> </v-col>
            <v-col md="5">
              <v-checkbox
                dense
                :label="item.NAME"
                :value="item.ID"
                v-model="edt.rights"
              >
              </v-checkbox>
            </v-col>
            <v-col md="5" text-align: center> {{ item.DESCRIPTION }}</v-col>
          </v-row>
        </div>
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
import { typeEdtRole } from "../interfaces/typeauth.js";

export default Vue.extend({
  name: "RoleEdtDlg",
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
      edt: {} as typeEdtRole,
      rights: [] as number[],
    };
  },
  watch: {
    dialog(visible) {
      if (visible) {
        this.message = "";
        this.edt.rights = [];
        this.edt.name = this.info.NAME;
        this.edt.description = this.info.DESCRIPTION;
        if (this.info.NAME == undefined) {
          this.title = "Создать новую роль";
        } else {
          this.title = 'Редактировать роль "' + this.info.NAME + '"';
        }
        axios
          .get(process.env.VUE_APP_RESTSERVER + "/dir/rights", {
            headers: { authorization: this.$store.getters.getToken },
          })
          .then((response) => {
            this.rights = response.data;
            if (this.info.ROLERIGHTSIDS) {
              this.edt.rights = this.info.ROLERIGHTSIDS.split(",").map(
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
  },
  methods: {
    cancel() {
      this.$emit("update:dialog", false);
    },
    doit() {
      if (this.info.NAME == undefined) {
        //создаем новую роль
        axios
          .post(process.env.VUE_APP_RESTSERVER + "/role", this.edt, {
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
        //изменение существующей
        axios
          .put(
            process.env.VUE_APP_RESTSERVER + "/role/" + this.info.ID,
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
