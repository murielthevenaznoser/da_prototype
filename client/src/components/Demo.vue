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

        var categories = this.getCategories(value);

        if (categories === null) {
          this.message = "Une erreur s'est produite."
          this.isLoading = false;
          return;
        }

        if (categories.length === 0) {
          this.message = "Aucun médicament contre-indiqué";
          this.isLoading = false;
          return;
        }

        return this.getMedicationsForCategories(categories);
      }
    },

    getCategories: function (value) {
      fetch(MEDICATION + `?name=${value}`, {
        headers: HEADERS,
        method: "GET"
      })
        .then(res => { return res.json(); })
        .then(res => {
          var entries = res?.value === null ? [] : res.value;
          console.log('entries', entries);
          var categories = [];
          foreach(entry in entries)
          {
            console.log('entry', entry);
            var category = this.getCategoryInfos(entry.id);
            categories.push(category);
          }
          return categories;
        }
        );
    },

    getCategoryInfos: function (id) {
      fetch(CATEGORIE + `/id/${id}`, {
        headers: HEADERS,
        method: "GET"
      })
        .then(res => { return res.json(); }, () => {return} )
        .then(res => {
          console.log('category', res);
          return new Category(res);
        });
    },

    getMedicationsForCategories: function (categories) {
      foreach(category in categories)
      {
        fetch(MEDICATION + `?categoryId=${category.id}`, {
          headers: HEADERS,
          method: "GET"
        })
          .then(res => { return res.json(); }, () => {return} )
          .then(res => {
            console.log('all meds', res);
            var medications = res?.value === null ? [] : res.value.map(v => new Medication(v));
            console.log('after model', medications);
            category.medications = medications;
            this.response.push(category);
          });
      }
    }
  },
};

</script>

