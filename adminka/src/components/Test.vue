<template>
  <v-container>
    <v-toolbar flat color="primary" dark>
      <v-toolbar-title>Тест связи</v-toolbar-title>
    </v-toolbar>
    <v-card background-color="primary">
      <v-btn color="primary" @click="testad">Тест active directory</v-btn>
      <v-btn color="primary" @click="testdb">Тест базы данных</v-btn>
      <v-btn color="primary" @click="testjwt">Проверить токен</v-btn>
      <p>Результат теста:</p>
      <p>{{ testresult }}</p>
    </v-card>
  </v-container>
</template>

<script lang="ts">
import Vue from "vue";
import axios from "axios";

export default Vue.extend({
  data() {
    return {
      testresult: "",
    };
  },
  methods: {
    testad() {
      axios
        .get(process.env.VUE_APP_RESTSERVER + "/testad", {
          headers: { authorization: this.$store.getters.getToken },
        })
        .then((response) => {
          this.testresult = response.data;
        })
        .catch((error) => {
          this.testresult = error?.response?.data || error;
        });
    },
    testdb() {
      axios
        .get(process.env.VUE_APP_RESTSERVER + "/testdb", {
          headers: { authorization: this.$store.getters.getToken },
        })
        .then((response) => {
          this.testresult = response.data;
        })
        .catch((error) => {
          this.testresult = error?.response?.data || error;
        });
    },
    testjwt() {
      axios
        .get(process.env.VUE_APP_RESTSERVER + "/testjwt", {
          headers: { authorization: this.$store.getters.getToken },
        })
        .then((response) => {
          this.testresult =
            "Токен: "+this.$store.getters.getToken + "\nДекодированый: " + JSON.stringify(response.data);
        })
        .catch((error) => {
          this.testresult = error?.response?.data || error;
        });
    },
  },
});
</script>
