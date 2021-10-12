<template>
  <NavBar />
</template>

<script lang="ts">
import Vue from "vue";
import NavBar from "./components/NavBar.vue";

export default Vue.extend({
  name: "App",
  components: {
    NavBar,
  },
  data: () => ({
    //
  }),
});
</script>
