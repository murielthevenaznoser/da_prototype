<template>
  <section class="demo">
    <header class="header">
      <h1>DEMO</h1>
      <h2 v-if="isLoading">Loading...</h2>     
      <input class="check-medication" autofocus autocomplete="off" placeholder="Quel médicament doit être recherché ?" v-model="searchInput"
        @keyup.enter="searchMedication" />
    </header>
    <footer class="footer">Copyright by ALLIANs allergY SaRL</footer>
  </section>
</template>


<script lang="js">
const MEDICATIONS = "/data-api/rest/medications";
const CATEGORIES = "/data-api/rest/categories";
const HEADERS = { 'Accept': 'application/json', 'Content-Type': 'application/json;charset=utf-8' };


export default {

  data() {
    return {
      searchInput: '',
      response: [],
      isLoading: false
    };
  },

  methods: {
    searchMedication: function () {
      this.isLoading = true;

      var value = this.searchInput && this.searchInput.trim();
      if (!value) return;
      fetch(MEDICATIONS, {
        headers: HEADERS,
        method: "GET"})
      .then(res => {
        console.log('response', res);
        if (res.ok) {
          this.searchInput = ''
          return res.json();
        }
      }).then(res => {
        this.response = res.value;
        this.isLoading = false;
      })
    }
  },
};

</script>

