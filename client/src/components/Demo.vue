<template>
  <section class="demo">
    <header class="header">
      <h1>DEMO</h1>
      <h2 v-if="isLoading">Loading...</h2>     
      <input class="check-medication" autofocus autocomplete="off" placeholder="Quel médicament doit être recherché ?" v-model="medication"
        @keyup.enter="searchMedication" />
    </header>
    <section class="main" v-show="response.length">
      <ul class="response-list">        
        <li v-for="response in response-list" class="response" :key="response.id"></li>
      </ul>
    </section>
  </section>
</template>

<script lang="js">
const API = "/data-api/rest/medications";
const HEADERS = { 'Accept': 'application/json', 'Content-Type': 'application/json;charset=utf-8' };


export default {

  data() {
    return {
      response: [],
      isLoading: false
    };
  },

  mounted() {    
    this.getMedications();
  },

  watch: {
    isLoading(newValue) {
      if (newValue == true) {
        this.$Progress.start();    
      }       
      if (newValue == false) {
        this.$Progress.finish();
      } 
    }
  },

  methods: {
    getMedications: function () {
      this.isLoading = true;
      
      fetch(API, { headers: HEADERS, method: "GET" })
        .then(res => { return res.json(); })
        .then(res => {
          this.response = res == null ? [] : res.value;                                            
          this.isLoading = false;          
        }, res => {
          this.isLoading = false;
        });
    }
  },
};

</script>

