<template>
  <v-container>
    <v-dialog v-model="dialog" persistent max-width="500px">
      <v-card>
        <v-card-title class="text-h6">Удалить пользователя "{{ info.USERNAME }}" ?</v-card-title>
        <v-alert type="error" v-if="message">
          {{ message }}
        </v-alert>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="cancel">Отмена</v-btn>
          <v-btn color="blue darken-1" text @click="doit">Удалить</v-btn>
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
  name: "UserDelDlg",
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
    };
  },
    watch: {
    dialog(visible) {
      if (visible) {
        this.message = "";
      }
    },
  },
  methods: {
    cancel() {
      this.$emit("update:dialog", false);
    },
    doit() {
      axios
        .delete(process.env.VUE_APP_RESTSERVER + "/user/" + this.info.ID, {
          headers: { authorization: this.$store.getters.getToken },
        })
        .then(() => {
          this.$emit("update:dialog", false);
          this.$emit("dialogexec");
        })
        .catch((error) => {
          this.message = error?.response?.data?.message || error?.response?.data || error;
        });
    },
  },
});
</script>
