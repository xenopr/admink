<template>
  <v-container>
    <v-toolbar flat color="primary" dark>
      <v-toolbar-title>Редактор прав доступа</v-toolbar-title>
    </v-toolbar>
    <v-tabs background-color="primary" dark>
      <v-tab> Пользователи </v-tab>
      <v-tab> Роли </v-tab>
      <v-tab-item>
        <Users />
      </v-tab-item>
      <v-tab-item>
        <Roles />
      </v-tab-item>
    </v-tabs>
  </v-container>
</template>

<script lang="ts">
import Vue from "vue";
import Roles from "./Roles.vue";
import Users from "./Users.vue";

export default Vue.extend({
  components: {
    Roles,
    Users,
  },
  data() {
    return {};
  },
});
</script>
