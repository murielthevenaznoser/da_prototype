<template>
  <section class="demo">
    <header class="header">
      <h1>DEMO</h1>
      <h2 v-if="isLoading">Loading...</h2>
      <input autofocus autocomplete="off" placeholder="Quel médicament doit être recherché ?" v-model="searchInput"
        @keyup.enter="searchMedication" />
    </header>
    <div id="message" v-if="message">{{ message }}</div>
    <section v-show="response.length > 0">
      <ul>
        <li v-for="category in response">
          <div>
            <label>{{ category.name }}</label>
            <p class="titel">Recommandation immédiate:</p>
            <p class="value">{{ category.primaryEffect }}</p>
            <p class="titel">Recommandation à long terme:</p>
            <p class="value">{{ category.secondaryEffect }}</p>
            <p></p>
            <p class="titel">List des médicaments concernés:</p>
            <ul>
              <li v-for="medication in category.medications">
                <div>
                  <label>{{ medication.name }}</label>
                </div>
              </li>
            </ul>
          </div>
        </li>
      </ul>
    </section>
  </section>
</template>


<script lang="js">
import { Category } from '../models/category.model';
import { Medication } from '../models/medication.model';

const MEDICATION = "/data-api/rest/medication";
const CATEGORIE = "/data-api/rest/categorie";
const HEADERS = { 'Accept': 'application/json', 'Content-Type': 'application/json;charset=utf-8' };


export default {

  data() {
    return {
      searchInput: '',
      response: [],
      medications: [],
      categories: [],
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

  mounted() {
    this.getCategories();
    this.getMedications();
  },

  methods: {
    searchMedication: function () {
      this.isLoading = true;
      this.response = [];
      this.message = '';

      var value = this.searchInput && this.searchInput.trim();
      if (!value) {
        this.showError();
        return;
      }
        var medsWithInputName = this.medications.filter(m => m.name === value);
        if (!medsWithInputName || medsWithInputName.length === 0) 
        {
          this.message = "Pas de médicament trouvé pour ce nom";
          this.isLoading = false;
          return;
        }

        var resultingCategories = [];
        medsWithInputName.forEach(m => {
          var category = this.categories.find(c => c.id === m.categoryId);
          resultingCategories.push(category);
        })

        if (resultingCategories.length === 0)
        {
          this.showError();
          return;
        }

        this.response = resultingCategories.map(cat => {
          var medEntries = this.medications.filter(m => m.categoryId === cat.id);
          if (medEntries.length === 0)
          {
            this.showError();
            return;
          }
          cat.medications = medEntries;
          return cat;
        })
        this.loading = false;
    },

    getMedications: function() {
      fetch(MEDICATION, {
        headers: HEADERS,
        method: "GET"
      })
        .then(res => { return res.json(); })
        .then(res => {
          this.medications = res?.value === null || res?.value === undefined ? [] : res.value.map(e => new Medication(e));
        });
    },

    getCategories: function() {
      fetch(CATEGORIE, {
        headers: HEADERS,
        method: "GET"
      })
        .then(res => { return res.json(); })
        .then(res => {
          this.categories = res?.value === null || res?.value === undefined ? [] : res.value.map(e => new Category(e));
        });
    },

    showError: function () {
      this.message = "Une erreur s'est produite."
      this.isLoading = false;
    }
  },
};

</script>

