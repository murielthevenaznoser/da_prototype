<template>
  <section class="demo">
    <header class="header">
      <h1>DEMO</h1>
      <h2 v-if="isLoading">Loading...</h2>     
      <input autofocus autocomplete="off" placeholder="Quel médicament doit être recherché ?" v-model="searchInput"
        @keyup.enter="searchMedication" />
    </header>
    <div id="message" v-if="message">{{ message }}</div>
  </section>
</template>


<script lang="js">
const MEDICATION = "/data-api/rest/medication";
const CATEGORIE = "/data-api/rest/categorie";
const HEADERS = { 'Accept': 'application/json', 'Content-Type': 'application/json;charset=utf-8' };


export default {

  data() {
    return {
      searchInput: '',
      response: [],
      isLoading: false,
      message: ''
    };
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
    searchMedication: function () {
      this.isLoading = true;

      var value = this.searchInput && this.searchInput.trim();
      if (value) {
      var query = "?name=" + value;
      fetch(MEDICATION + query, {
        headers: HEADERS,
        method: "GET"})
      .then(res => { return res.json(); })
      .then(res => {
        this.response = res?.value == null ? [] : res.value;
        if (this.response.length === 0) {
          this.message = "Aucun médicament contre-indiqué";
        }
        this.isLoading = false;
      }, res => {
          this.message = "Une erreur s'est produite."
          this.isLoading = false;
      });
    }
    }
  },
};

</script>

