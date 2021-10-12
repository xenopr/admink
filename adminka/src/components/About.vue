<template>
  <v-container>
    <v-toolbar flat color="primary" dark>
      <v-toolbar-title>О программе</v-toolbar-title>
    </v-toolbar>
    <div class="about text-center">
      <h1>Заготовка</h1>
      <h2>Админка</h2>
      <h3>Панель администратора</h3>
      <h4>Версия 0</h4>
      <v-card-text>
        <v-row>
          <v-col  md="4">
            Логин: <br />
            Пользователь: <br />
            Должность: <br />
            Подразделение:<br />
            Роли: <br />
            Права:<br />
          </v-col>
          <v-col md="4">
            {{ $store.getters.getUser.login }}<br />
            {{ $store.getters.getUser.username }}<br />
            {{ $store.getters.getUser.position }}<br />
            {{ $store.getters.getUser.subdivision }}<br />
            {{ String($store.getters.getUser.roles) }}<br />
            {{ String($store.getters.getUser.rights) }}<br />
          </v-col>
        </v-row>
      </v-card-text>
    </div>
  </v-container>
</template>
