<template>
  <v-container>
    <v-dialog v-model="dialog" persistent max-width="500px">
      <v-card outlined>
        <v-card-title class="text-h6"> Аккаунт пользователя </v-card-title>
        <v-card-subtitle class="text-h7">"{{ info.USERNAME }}"</v-card-subtitle>
        <v-date-picker
          v-model="edt.activeto"
          locale="ru-RU"
          first-day-of-week="1"
        ></v-date-picker>

        <v-alert type="error" v-if="message">
          {{ message }}
        </v-alert>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="cancel">Отмена</v-btn>
          <v-btn color="blue darken-1" text @click="doit"
            >Отключить с
            {{
              edt.activeto ? new Date(edt.activeto).toLocaleDateString() : ""
            }}</v-btn
          >
          <v-btn color="blue darken-1" text @click="doon">Включить</v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script lang="ts">
import Vue from "vue";
import axios from "axios";

export default Vue.extend({
  name: "UserActDlg",
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
      edt: {
        activeto: "",
      },
      message: "",
    };
  },
  watch: {
    dialog(visible) {
      if (visible) {
        this.message = "";
        if (this.info.ACTIVETO) {
          this.edt.activeto =
            new Date(this.info.ACTIVETO).getFullYear().toString() +
            "-" +
            (new Date(this.info.ACTIVETO).getMonth() + 1)
              .toString()
              .padStart(2, "0") +
            "-" +
            new Date(this.info.ACTIVETO).getDate().toString().padStart(2, "0");
        } else {
          this.edt.activeto = new Date().toISOString().substr(0, 10) as string;
        }
      }
    },
  },
  methods: {
    cancel() {
      this.$emit("update:dialog", false);
    },
    doit() {
      axios
        .put(
          process.env.VUE_APP_RESTSERVER +
            "/user/" +
            this.info.ID +
            "/activeto",
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
    },
    doon() {
      this.edt.activeto = "";
      this.doit();
    },
  },
});
</script>
