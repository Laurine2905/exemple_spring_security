<script setup>
import {Chart} from 'chart.js';
import {onMounted, reactive} from "vue";
import {BACKEND, doAjaxRequest} from "@/views/api.js";


// Pour réinitialiser le formuaire
const IntervenantVide = {
  num_SS: "",
  nom: "",
  prenom: "",
  nom_jeune_fille: "",
  date_naiss: "",
  adresse: "",
  entree_collectivité: "",
  date_titularisation: "",
  grade: "",
  libelle_temps_travail: "",
  temps_travail_pourcentage: "",
  titulaire: "",
  metier: ""
};

// les différentes catégories d'âge
let ageRanges = reactive({
  range1: { label: "Moins de 20 ans", count: 0 },
  range2: { label: "20-29", count: 0 },
  range3: { label: "30-39", count: 0 },
  range4: { label: "40-49", count: 0 },
  range5: { label: "50-54", count: 0 },
  range6: { label: "55-59", count: 0 },
  range7: { label: "60-64", count: 0 },
  range8: { label: "Plus de 65 ans", count: 0 },
});

let data = reactive({
  // Les données saisies dans le formulaire
  formulaireIntervenant: {...IntervenantVide},
  intervenant: {...IntervenantVide},
  // La liste des catégories affichée sous forme de table
  listeIntervenant: []
});

// on charge les intervenants et on les range dans la bonne tranche d'age
function chargeIntervenant() {
  doAjaxRequest(BACKEND + "/api/intervenants")
      .then((json) => {
        data.listeIntervenant = json._embedded.intervenants;
        console.log(data.listeIntervenant);
// pour chaque intervenant dans la liste
        data.listeIntervenant.forEach((intervenant) => {
          // on calcule l'âge de chaque intervenant
          const age = calculateAge(intervenant.date_naiss);
          // range l'intervenant dans la bonne catégorie en fonction de son age
          if (age >= 0 && age <= 19) {
            ageRanges.range1.count++;
          } else if (age >= 20 && age <= 29) {
            ageRanges.range2.count++;
          } else if (age >= 30 && age <= 39) {
            ageRanges.range3.count++;
          } else if (age >= 40 && age <= 49) {
            ageRanges.range4.count++;
          } else if (age >= 50 && age <= 54) {
            ageRanges.range5.count++;
          } else if (age >= 55 && age <= 59) {
            ageRanges.range6.count++;
          } else if (age >= 60 && age <= 64) {
            ageRanges.range7.count++;
          } else if (age >= 65) {
            ageRanges.range8.count++;
          }
        });
        console.log(ageRanges)
        const labels = Object.values(ageRanges).map(range => range.label);
        const chartData = Object.values(ageRanges).map(range => calculatePercentage(range.count));
        console.log(chartData);
        // Créer un diagramme circulaire avec Chart.js
        const ctx = document.getElementById('myChart').getContext('2d');
        new Chart(ctx, {
          type: "bar",
          data: {
            labels: labels,
            datasets: [{
              data: chartData,
              backgroundColor: [
                '#FF6384',
                '#36A2EB',
                '#FFCE56',
                '#7C4DFF',
                '#00CCFF',
                '#FF9900',
                '#33FF33',
                '#FF66CC'
              ], // Couleurs pour chaque tranche d'âge
            }]
          }
        });
      })
      .catch((error) => alert(error.message));

}

// calcule l'âge de la personne en fonction de sa date de naissance et de la date d'aujourd'hui
function calculateAge(dateDeNaissance) {
  // fonction pour calculer l'âge en fonction de la date de naissance
  const birthday = new Date(dateDeNaissance);
  const ageDifMs = Date.now() - birthday.getTime();
  const ageDate = new Date(ageDifMs);
  return Math.abs(ageDate.getUTCFullYear() - 1970);
}

// calcule le pourcentage d'intervenant sur chaque ligne
function calculatePercentage(count) {
  const totalCount = Object.values(ageRanges).reduce((a, b) => a + b.count, 0);

  return ((count / totalCount) * 100).toFixed(1);
}

// A l'affichage du composant, on affiche la liste des intervenants
onMounted(chargeIntervenant);

</script>

<template>
  <main>
    <div>
      <nav>
        <ul id="bandeau">
          <li>
            <div class="menu">
              Nombre d'agents par tranche d'âge
            </div>
          </li>
        </ul>
      </nav>
      <canvas id="myChart"></canvas>

    </div>
    <div class="table-container right-align">
      <table class="tableintervenant">
        <thead>
        <tr class="head">
          <th>Tranche d'âge</th>
          <th>Nombre d'agents</th>
          <th> Pourcentage</th>
        </tr>
        </thead>
        <tbody>
        <!-- on fait une boucle de ageRanges -->
        <tr v-for="(count, range) in ageRanges" :key="range">
          <!-- Nom de la colonne indiqué dans angeRange -->
          <td>{{ range }}</td>
          <!-- Nombre d'agents dans la colonne -->
          <td>{{ count }}</td>
          <!-- pourcentage de chaque colonne -->
          <td>{{ calculatePercentage(count) }}%</td>
        </tr>
        </tbody>
      </table>
    </div>
  </main>
</template>

<style scoped>

/* Bandeau */
#bandeau {
  height: 47px;
  display: flex; /*répartit les titres sur toute la ligne du bandeau*/
  padding: 0px;
  background-color: white;
  width: 100%; /*s'étale sur toute la largeur de l'écran*/
  top: 0px; /* fixe le bandeau tout en haut de la page*/
  margin: 0 auto;
}

#bandeau li {
  flex: auto; /*met le texte du bandeau sur 1 ligne en créant des cases de différentes tailles*/
  list-style-type: none;
  text-align: center;
  line-height: auto;
  position: relative;
}

#bandeau .menu {
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

nav #bandeau::after {
  display: table;
}

/* Tableau d'affichage des intervenants */
main {
  padding-top: 20px;

}

.right-align {
  float: right;
  padding-right: 10px;
}


.table-container {
  padding-top: 90px;
  height: 500px; /* Hauteur maximale de votre tableau */
  overflow-y: auto; /* Ajoute une barre de défilement verticale */

}

.tableintervenant {
  margin: 0 auto;
}


.head {
  position: sticky; /* Bloque le bandeau pour qu'il ne bouge pas quand on défile */
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