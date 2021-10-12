<template>
  <v-container>
    <v-toolbar flat color="primary" dark>
      <v-toolbar-title>Пользователи</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-text-field
        dense
        v-model="search"
        prepend-icon="mdi-magnify"
        single-line
        hide-details
      ></v-text-field>
      <v-btn icon color="white" @click="createItem">
        <v-icon>mdi-plus</v-icon>
      </v-btn>
      <v-btn icon color="white" @click="refresh">
        <v-icon>mdi-cached</v-icon>
      </v-btn>
    </v-toolbar>
    <v-card background-color="primary">
      <v-data-table
        dense
        :headers="headers"
        :items="items"
        :search="search"
        :items-per-page="50"
        :expanded.sync="expanded"
        item-key="ID"
        show-expand
        class="elevation-1"
        :footerProps="{
          itemsPerPageOptions: [50],
        }"
      >
        <template v-slot:[`item.ACTIVETO`]="{ item }">
          <v-chip :color="colorActive(item)" @click="activeItem(item)">
            {{ item.ACTIVETO ? "x" : " " }}
          </v-chip>
        </template>
        <template v-slot:expanded-item="{ headers, item }">
          <td :colspan="headers.length">{{ item.DESCRIPTION }}</td>
        </template>
        <template v-slot:[`item.actions`]="{ item }">
          <v-icon small class="mr-2" @click="editItem(item)">mdi-pencil</v-icon>
          <v-icon small @click="deleteItem(item)">mdi-delete</v-icon>
        </template>
        <template v-slot:no-data>
          <!-- <v-btn color="primary" @click="refresh"> Reset </v-btn> -->
        </template>
      </v-data-table>
    </v-card>
    <v-snackbar v-model="messageshow" timeout="2000" color="red" centered>
      {{ message }}
      <template v-slot:action="{ attrs }">
        <v-btn color="white" text v-bind="attrs" @click="messageshow = false">
          ОК
        </v-btn>
      </template>
    </v-snackbar>
    <user-del-dlg
      v-bind:info="edtItem"
      v-bind:dialog.sync="dialogdelete"
      v-on:dialogexec="refresh"
    />
    <user-edt-dlg
      v-bind:info="edtItem"
      v-bind:dialog.sync="dialogedit"
      v-on:dialogexec="refresh"
    />
    <user-act-dlg
      v-bind:info="edtItem"
      v-bind:dialog.sync="dialogact"
      v-on:dialogexec="refresh"
    />
  </v-container>
</template>

<script lang="ts">
import Vue from "vue";
import axios from "axios";
import UserDelDlg from "./UserDelDlg.vue";
import UserEdtDlg from "./UserEdtDlg.vue";
import UserActDlg from "./UserActDlg.vue";

export default Vue.extend({
  name: "Users",
  components: {
    UserDelDlg,
    UserEdtDlg,
    UserActDlg,
  },
  data() {
    return {
      expanded: [],
      dialogdelete: false,
      dialogedit: false,
      dialogact: false,
      edtItem: {},
      search: "",
      headers: [
        { text: "", value: "ACTIVETO" },
        { text: "", value: "ID" },
        { text: "Логин", align: "start", value: "LOGIN" },
        { text: "ФИО", value: "USERNAME" },
        { text: "Должность", value: "POSITION" },
        { text: "Подразделение", value: "SUBDIVISION" },
        { text: "Роли", value: "USERROLES" },
        { text: "Действия", value: "actions", sortable: false },
      ],
      items: [],
      messageshow: false,
      message: "",
    };
  },
  computed: {},
  methods: {
    refresh() {
      axios
        .get(process.env.VUE_APP_RESTSERVER + "/user", {
          headers: { authorization: this.$store.getters.getToken },
        })
        .then((response) => {
          this.items = response.data;
        })
        .catch((error) => {
          this.message = error?.response?.data?.message || error;
          this.messageshow = true;
        });
    },
    colorActive(item: any): string {
      if (item.ACTIVE) {
        return "green";
      } else {
        return "red";
      }
    },
    checkActive(item: any): boolean {
      if (item.ACTIVETO) {
        return true;
      } else {
        return false;
      }
    },
    activeItem(item: any) {
      this.edtItem = Object.assign({}, item);
      this.dialogact = true;
    },
    createItem(item: any) {
      this.edtItem = {};
      this.dialogedit = true;
    },
    editItem(item: any) {
      this.edtItem = Object.assign({}, item);
      this.dialogedit = true;
    },
    deleteItem(item: any) {
      this.edtItem = Object.assign({}, item);
      this.dialogdelete = true;
    },
  },
  mounted() {
    this.refresh();
  },
});
</script>
