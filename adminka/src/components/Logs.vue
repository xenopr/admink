<template>
  <v-container>
    <v-toolbar flat color="primary" dark>
      <v-toolbar-title>Журнал событий</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn icon color="white" @click="refresh">
        <v-icon>mdi-cached</v-icon>
      </v-btn>
    </v-toolbar>
    <v-card background-color="primary">
      <v-card-title>
        <v-row>
          <v-col md="3">
            <v-menu
              ref="menu1"
              v-model="menu1"
              :close-on-content-click="false"
              :nudge-right="40"
              transition="scale-transition"
              offset-y
              max-width="290px"
              min-width="290px"
            >
              <template v-slot:activator="{ on }">
                <v-text-field
                  v-model="dtfFormatted"
                  dense
                  label="Показать с"
                  persistent-hint
                  prepend-icon="mdi-calendar"
                  readonly
                  v-on="on"
                ></v-text-field>
              </template>
              <v-date-picker
                v-model="dtf"
                locale="ru-RU"
                first-day-of-week="1"
                no-title
                @input="menu1 = false; refresh()"
              ></v-date-picker>
            </v-menu>
          </v-col>
          <v-col md="3">
            <v-menu
              ref="menu2"
              v-model="menu2"
              :close-on-content-click="false"
              :nudge-right="40"
              transition="scale-transition"
              offset-y
              max-width="290px"
              min-width="290px"
            >
              <template v-slot:activator="{ on }">
                <v-text-field
                  v-model="dttFormatted"
                  dense
                  label="по"
                  persistent-hint
                  prepend-icon="mdi-calendar"
                  readonly
                  v-on="on"
                ></v-text-field>
              </template>
              <v-date-picker
                v-model="dtt"
                locale="ru-RU"
                first-day-of-week="1"
                no-title
                @input="menu2 = false; refresh()"
              ></v-date-picker>
            </v-menu>
          </v-col>
        </v-row>
      </v-card-title>
      <v-card-subtitle>
        <v-row>
          <v-col md="12">
            <v-text-field
              dense
              v-model="search"
              prepend-icon="mdi-magnify"
              label="искать.."
              single-line
              hide-details
            ></v-text-field>
          </v-col>
        </v-row>
      </v-card-subtitle>
      <v-data-table
        dense
        :loading="loading"
        :headers="headers"
        :items="logrecords"
        :search="search"
        :items-per-page="100"
        :expanded.sync="expanded"
        item-key="ID"
        show-expand
        class="elevation-1"
        :footerProps="{
          itemsPerPageOptions: [100],
        }"
      >
        <template v-slot:expanded-item="{ headers, item }">
          <td :colspan="headers.length">{{ item.RECORD }}</td>
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
  </v-container>
</template>

<script lang="ts">
import Vue from "vue";
import axios from "axios";

export default Vue.extend({
  data() {
    return {
      search: "",
      loading: false,
      dtf: new Date().toISOString().substr(0, 10) as string,
      dtt: new Date().toISOString().substr(0, 10) as string,
      menu1: false,
      menu2: false,
      expanded: [],
      headers: [
        { text: "", value: "data-table-expand" },
        { text: "Время", align: "start", value: "TSTAMP" },
        { text: "Результат", value: "NAMER" },
        { text: "Событие", value: "NAMEE" },
        { text: "Пользователь", value: "USERNAME" },
        { text: "IP", value: "IP" },
        { text: "API", value: "RESTAPI" },
        { text: "Сущность", value: "WHENCE" },
        { text: "Цель", value: "TARGET" },
        { text: "Операция", value: "OPERATION" },
      ],
      logrecords: [],
      messageshow: false,
      message: "",
    };
  },
  computed: {
    dtfFormatted(): string {
      return this.formatDate(this.dtf);
    },
    dttFormatted(): string {
      return this.formatDate(this.dtt);
    },
  },
  methods: {
    refresh() {
      this.loading=true;
      axios
        .get(process.env.VUE_APP_RESTSERVER + "/log?dtf="+this.dtf+"&dtt="+this.dtt, {
          headers: { authorization: this.$store.getters.getToken },
        })
        .then((response) => {
          this.logrecords = response.data;
          this.loading=false;
        })
        .catch((error) => {
          this.message = error?.response?.data?.message || error;
          this.messageshow = true;
          this.loading=false;
        });
    },
    formatDate(date: string): string {
      if (!date) return date;
      const [year, month, day] = date.split("-");
      return `${day}.${month}.${year}`;
    },
  },
  mounted() {
    this.refresh();
  },
});
</script>
