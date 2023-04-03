<template>  
  <vue-progress-bar></vue-progress-bar>
  <Demo />
</template>

<script>
import Demo from './components/Demo.vue'
import { getCurrentInstance } from "vue";

export default {  
  name: 'App',
  components: {
    Demo
  },
  setup() {
    const internalInstance = getCurrentInstance();
    //  [App.vue specific] When App.vue is first loaded start the progress bar
    internalInstance.appContext.config.globalProperties.$Progress.start();
    setTimeout(() => {
      internalInstance.appContext.config.globalProperties.$Progress.finish();
    }, 3500);
  }
}
</script>

<style>
  @import url("https://unpkg.com/todomvc-app-css@2.2.0/index.css");
  @import url("./styles/custom.css");
</style>