<script setup>
import {onMounted, reactive} from "vue";
import {BACKEND, doAjaxRequest} from "@/views/api.js";


// Pour réinitialiser le formuaire
const ArretVide = {
  id: "",
  debut: "",
  fin: "",
  nb_jours: "",
  objet: "",
  intervenant_num_ss: "",
};

// Pour réinitialiser le formuaire 2
const ArretVide2 = {
  id: "",
  debut: "",
  fin: "",
  categorie:"",
  nb_jours: "",
  objet: "",
  intervenant_num_ss: "",
};

// les différentes catégories d'arret ordinaire
let motifOrdinaireRanges = reactive({
  "Maladie ordinaire": 0,
  "Maladie de moyenne durée": 0,
  "Maladie de longue durée": 0,
});

// les différentes catégories d'arrets spéciaux
let motifSpéciauxRanges = reactive({
  "Maternité / Paternité ": 0,
  "Accident de travail / Maladie professionnelle": 0,
  "Congés spéciaux": 0,
});

let data = reactive({
  // Les données saisies dans le formulaire
  formulaireArret: {...ArretVide},
  formulaireArret2: {...ArretVide2},
  // La liste des arrets affichée sous forme de table
  listeArret: [],
  listeArret2: []
});

function chargeArrets() {
  doAjaxRequest(BACKEND + "/api/arrets?sort=debut")
      .then((json) => {
        data.listeArret = json._embedded.arrets;
        console.log(data.listeArret)
// on range les rrets en fonction du nombre de jours d'arrets pour les mettre dans différentes catégories
        data.listeArret.forEach((arret) => {
          const duree = arret.nb_jours;
          if (duree >= 0 && duree <= 6) {
            motifOrdinaireRanges["Maladie ordinaire"]++;
          } else if (duree >= 7 && duree <= 182) {
            motifOrdinaireRanges["Maladie de moyenne durée"]++;
          } else if (duree >=183) {
            motifOrdinaireRanges["Maladie de longue durée"]++;
          }
        });
        console.log( motifOrdinaireRanges)
      })
      .catch((error) => {
        console.error(error);
        alert("Erreur lors de la récupération de l'intervenant.");
      });
}

function chargeArrets2() {
  doAjaxRequest(BACKEND + "/api/arret2s?sort=debut")
      .then((json) => {
        data.listeArret2 = json._embedded.arret2s;
        console.log(data.listeArret2)
        // on tri les arret en fonction de leur catégorie
        data.listeArret2.forEach((arret) => {
          const categorie = arret.categorie;
          if (categorie==1) {
            motifSpéciauxRanges["Maternité / Paternité "]++;
          } else if (categorie==2) {
            motifSpéciauxRanges["Accident de travail / Maladie professionnelle"]++;
          } else if (categorie==3) {
            motifSpéciauxRanges["Congés spéciaux"]++;
          }
        });
        console.log( motifSpéciauxRanges)
      })
      .catch((error) => {
        console.error(error);
        alert("Erreur lors de la récupération de l'intervenant.");
      });
}

// on calcule le % de chaque catégorie
function calculatePercentage(count) {
  const totalCount = Object.values(motifOrdinaireRanges).reduce((a, b) => a + b, 0);
  return ((count / totalCount) * 100).toFixed(1);
}

// on calcule le nombre total d'arret
function calculateTotalCount() {
  let totalCount = 0;
  for (const count of Object.values(motifOrdinaireRanges)) {
    totalCount += count;
  }
  return totalCount;
}

// on calcule le % de chaque catégorie
function calculatePercentage2(count) {
  const totalCount = Object.values(motifSpéciauxRanges).reduce((a, b) => a + b, 0);
  return ((count / totalCount) * 100).toFixed(1);
}

// on calcule le nombre total d'arret spéciaux
function calculateTotalCount2() {
  let totalCount = 0;
  for (const count of Object.values(motifSpéciauxRanges)) {
    totalCount += count;
  }
  return totalCount;
}
// A l'affichage du composant, on affiche la liste des arrets et arrets spéciaux
onMounted(() => {
  chargeArrets();
  chargeArrets2()
});

</script>

<template>
  <main>
    <div>
      <nav>
        <ul id="bandeau">
          <li>
            <div class="menu">
              Taux d'absentéisme par motif
            </div>
          </li>
        </ul>
      </nav>

    </div>
    <div class="table-container right-align">
      <table class="tableintervenant">
        <thead>
        <tr class="head">
          <th>Motif</th>
          <th>Nombre d'arrêts</th>
          <th> Pourcentage </th>
          <th> Total des arrêts </th>
        </tr>
        </thead>
        <tbody>
        <tr v-for="(pair, index) in Object.entries(motifOrdinaireRanges)" :key="index">
          <td>{{ pair[0] }}</td>
          <td>{{ pair[1] }}</td>
          <td>{{ calculatePercentage(pair[1]) }}%</td>
          <template v-if="index === Object.entries(motifOrdinaireRanges).length - 1">

            <td>{{ calculateTotalCount() }}</td>
          </template>
        </tr>

        </tbody>
      </table>
    </div>

    <div class="table-container">
      <table class="tableintervenant">
        <thead>
        <tr class="head">
          <th>Motif</th>
          <th>Nombre d'arrêts</th>
          <th> Pourcentage </th>
          <th> Total des arrêts </th>
        </tr>
        </thead>
        <tbody>
        <tr v-for="(pair, index) in Object.entries(motifSpéciauxRanges)" :key="index">
          <td>{{ pair[0] }}</td>
          <td>{{ pair[1] }}</td>
          <td>{{ calculatePercentage2(pair[1]) }}%</td>
          <template v-if="index === Object.entries(motifSpéciauxRanges).length - 1">

            <td>{{ calculateTotalCount2() }}</td>
          </template>
        </tr>

        </tbody>
      </table>
    </div>
  </main>
</template>

<style scoped>

bouton{
  padding-left: 10px;
}

/* Bandeau */
#bandeau{
  height: 47px;
  display: flex;  /*répartit les titres sur toute la ligne du bandeau*/
  padding: 0px;
  background-color: white;
  width: 100%;    /*s'étale sur toute la largeur de l'écran*/
  top: 0px;   /* fixe le bandeau tout en haut de la page*/
  margin: 0 auto;
}

#bandeau li{
  flex: auto;     /*met le texte du bandeau sur 1 ligne en créant des cases de différentes tailles*/
  list-style-type: none;
  text-align: center;
  line-height: auto;
  position: relative;
}

#bandeau .menu{
  background-color: white;
  text-transform: uppercase;
  color: #659ABD;
  text-decoration: none;
  display: block;
  padding: 15px 0px;
  font-weight: bold;
  font-family: Georgia, serif;
  font-size: 30px;
  text-decoration: underline;
  text-align: center;
}

nav #bandeau::after{
  display: table;
}

/* Tableau d'affichage des intervenants */
main{
  padding-top: 20px;

}
.right-align {
  float: right;
}

.table-container {
  padding-top: 30px;
  height: 500px; /* Hauteur maximale de votre tableau */
  overflow-y: auto; /* Ajoute une barre de défilement verticale */

}
tbody{
  padding-top: 30px;
}
.tableintervenant {
  margin: 0 auto;
}


.head{
  position: sticky;/* Bloque le bandeau pour qu'il ne bouge pas quand on défile */
  z-index: 1; /*  contrôle la position d'un élément dans la pile d'affichage */
  top: 0;
}

td,
th {
  border: 1px solid #ddd;
  padding: 10px;
}
th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: #659ABD;
  color: rgb(255, 255, 255);
}
</style>