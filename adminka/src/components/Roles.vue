<template>
  <v-container>
    <v-toolbar flat color="primary" dark>
      <v-toolbar-title>Роли пользователей</v-toolbar-title>
      <v-spacer></v-spacer>
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
        :items-per-page="50"
        :expanded.sync="expanded"
        item-key="ID"
        show-expand
        class="elevation-1"
        :footerProps="{
          itemsPerPageOptions: [50],
        }"
      >
        <template v-slot:expanded-item="{ headers, item }">
          <td :colspan="headers.length">{{ item.ROLEUSERS }}</td>
        </template>
        <template v-slot:[`item.actions`]="{ item }">
          <v-icon small class="mr-2" @click="editItem(item)">mdi-pencil</v-icon>
          <v-icon small @click="deleteItem(item)">mdi-delete</v-icon>
        </template>
        <template v-slot:no-data>
          <v-btn color="primary" @click="refresh"> Reset </v-btn>
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
    <role-del-dlg
      v-bind:info="edtItem"
      v-bind:dialog.sync="dialogdelete"
      v-on:dialogexec="refresh"
    />
    <role-edt-dlg
      v-bind:info="edtItem"
      v-bind:dialog.sync="dialogedit"
      v-on:dialogexec="refresh"
    />
  </v-container>
</template>

<script lang="ts">
import Vue from "vue";
import axios from "axios";
import RoleDelDlg from "./RoleDelDlg.vue";
import RoleEdtDlg from "./RoleEdtDlg.vue";

export default Vue.extend({
  name: "Roles",
  components: {
    RoleDelDlg,
    RoleEdtDlg,
  },
  data() {
    return {
      expanded: [],
      dialogdelete: false,
      dialogedit: false,
      edtItem: {},
      headers: [
        { text: "", value: "ID" },
        { text: "Наименование", align: "start", value: "NAME" },
        { text: "Описание", value: "DESCRIPTION" },
        { text: "Права", value: "ROLERIGHTS" },
        { text: "Действия", value: "actions", sortable: false },
      ],
      items: [],
      messageshow: false,
      message: "",
    };
  },
  methods: {
    refresh() {
      axios
        .get(process.env.VUE_APP_RESTSERVER + "/role", {
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
    createItem(item: any) {
      this.edtItem = {};
      this.dialogedit = true;
    },
    editItem(item: any) {
      this.edtItem = Object.assign({}, item);
      this.dialogedit = true;
    },
    // editedItem() {
    //   this.refresh();
    // },
    deleteItem(item: any) {
      this.edtItem = Object.assign({}, item);
      this.dialogdelete = true;
    },
    // deletedItem() {
    //   this.refresh();
    // },
  },
  mounted() {
    this.refresh();
  },
});
</script>
