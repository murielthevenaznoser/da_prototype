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
            <p>Recommandation immédiate: {{ category.primaryEffect }}</p>
            <p>Recommandation à long terme: {{ category.secondaryEffect }}</p>
            <p>List des médicaments concernés: {{ category.secondaryEffect }}</p>
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
      this.response = [];
      this.message = '';

      var value = this.searchInput && this.searchInput.trim();
      if (value) {
        this.getCategories(value);
      }
      else {
        this.showError();
      }
    },

    getCategories: function (value) {
      fetch(MEDICATION, {
        headers: HEADERS,
        method: "GET"
      })
        .then(res => { return res.json(); })
        .then(res => {
          this.medications = res?.value === null || res?.value === undefined ? [] : res.value;
          var entries = this.medications.filter(m => m.name === value).map(e => new Medication(e));
          var categories = [];

          entries.forEach(async entry => {
            var category = await this.getCategoryInfos(entry.categoryId);
            console.log('first cat after model', category);
            if (!category) {
              this.showError();
              return;
            }
            categories.push(category);
          });
          return categories;
        }, () => { this.showError(); }
        ).then(categories => {
          if (categories.length === 0) {
            this.message = "Aucun médicament contre-indiqué";
            this.isLoading = false;
            return;
          }
          this.getMedicationsForCategories(categories);
        });
    },

    getCategoryInfos: async function (id) {
      return await fetch(CATEGORIE + `/id/${id}`, {
        headers: HEADERS,
        method: "GET"
      })
        .then(res => { return res.json(); })
        .then(res => {
          if (!res?.value || res.value.length !== 1) {
            return null;
          }
          return new Category(res.value[0]);
        }, () => { this.showError(); });
    },

    getMedicationsForCategories: function (categories) {
      console.log('categories', categories);
      var response = [];
      categories.forEach(category => {
        console.log('cat', category);
        var medEntries = this.medications.filter(m => m.categoryId === category.id);
        console.log('medEntries', medEntries);
        response.push(category);
      });
      this.response = response.map(e => new Category(e));
      console.log('response 1', response);
      console.log('response 2', this.response);
      this.isLoading = false;
    },

    showError: function () {
      this.message = "Une erreur s'est produite."
      this.isLoading = false;
    }
  },
};

</script>

