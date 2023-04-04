<template>
  <section class="demo">
    <header class="header">
      <h1>DEMO</h1>
      <h2 v-if="isLoading">Loading...</h2>
      <input autofocus autocomplete="off" placeholder="Quel médicament doit être recherché ?" v-model="searchInput"
        @keyup.enter="searchMedication" />
    </header>
    <div id="message" v-if="message">{{ message }}</div>
    <section v-show="response.length">
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
    searchMedication: async function () {
      this.isLoading = true;
      this.response = [];
      this.message = '';

      var value = this.searchInput && this.searchInput.trim();
      if (value) {

        var categories = await this.getCategories(value);

        if (!categories) {
          this.message = "Une erreur s'est produite."
          this.isLoading = false;
          return;
        }

        if (categories.length === 0) {
          this.message = "Aucun médicament contre-indiqué";
          this.isLoading = false;
          return;
        }
        console.log('cat', categories);
        this.getMedicationsForCategories(categories);
      }
    },

    getCategories: async function (value) {
      return await fetch(MEDICATION, {
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
            if (!category) {
              return null;
            }
            categories.push(new Category(category));
          });
          return categories;
        }
        );
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
          return res.value[0];
        });
    },

    getMedicationsForCategories: function (categories) {
      categories.forEach(category => {
        var medEntries = this.medications.filter(m => m.categoryId === category.id);
        console.log('medentries', medEntries);
        category.medications = medEntries;
        this.response.push(category);
      });
      console.log('response', this.response);
    },
  },
};

</script>

