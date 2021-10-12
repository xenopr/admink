<template>
  <v-app>
    <v-navigation-drawer app v-model="drawer" color="primary">
      <v-list>
        <v-list-item two-line>
          <v-list-item-avatar>
            <v-icon x-large>mdi-account</v-icon>
          </v-list-item-avatar>

          <v-list-item-content>
            <v-list-item-title>{{ shortfio }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-divider></v-divider>
        <v-list-item
          v-for="link in links"
          :key="link.text"
          router
          :to="link.route"
          active-class="white--text text--accent-4"
        >
          <v-list-item-icon>
            <v-icon v-text="link.icon"></v-icon>
          </v-list-item-icon>
          <v-list-item-title>
            {{ link.text }}
          </v-list-item-title>
          <v-list-group v-if="link.items">
            <template v-slot:activator>
              <v-list-item-title>{{ link.text }}</v-list-item-title>
            </template>
            <v-list-item
              dense
              v-for="sublink in link.items"
              :key="sublink.text"
              router
              :to="sublink.route"
              active-class="white--text text--accent-4"
            >
              <v-list-item-icon>
                <v-icon v-text="sublink.icon"></v-icon>
              </v-list-item-icon>
              <v-list-item-title>
                {{ sublink.text }}
              </v-list-item-title>
            </v-list-item>
          </v-list-group>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>

    <v-app-bar app color="primary">
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>Панель администратора</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-tooltip bottom>
        <template v-slot:activator="{ on, attrs }">
          <div v-bind="attrs" v-on="on">
            {{ $store.getters.getUser.username }}
            <v-btn icon>
              <v-icon @click="loginClick">mdi-account</v-icon>
            </v-btn>
          </div>
        </template>
        <span>
          <v-card>
            {{ $store.getters.getUser.login }}
          </v-card>
        </span>
      </v-tooltip>
    </v-app-bar>

    <v-main>
      <v-container fluid>
        <router-view />
      </v-container>
    </v-main>
  </v-app>
</template>

<script lang="ts">
import Vue from "vue";

export default Vue.extend({
  data() {
    return {
      drawer: false,
      links: [
        //{ icon: "mdi-home", text: "Начало", route: "/" },
        { icon: "mdi-cog", text: "Доступ", route: "/dirs" },
        { icon: "mdi-book", text: "Журнал", route: "/logs" },
        { icon: "mdi-checkbox-multiple-outline", text: "Тест", route: "/test" },
        { icon: "mdi-information", text: "О программе", route: "/about" },
      ],
    };
  },
  computed: {
    shortfio() {
      let s: string = this.$store.getters.getUser.username;
      return (
        s.substring(0, s.indexOf(" ")) +
        s.substr(s.indexOf(" "), 2) +
        "." +
        s.substr(s.indexOf(" ", 2) + 1, 1) +
        "."
      );
    },
  },
  methods: {
    loginClick() {
      if (this.$store.getters.getUser.username !== "") {
        this.$router.push("/logout");
      } else {
        this.$router.push("/login");
      }
    },
  },
});
</script>
