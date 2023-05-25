<script setup>
import {useRoute} from 'vue-router'
import {BACKEND, doAjaxRequest} from "@/views/api.js";
import {onMounted, reactive} from "vue";

const route = useRoute();

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
// Pour réinitialiser le formuaire
const ArretVide = {
  id: "",
  debut: "",
  fin: "",
  nb_jours: "",
  objet: "",
  intervenant_num_ss: "",
};

let data = reactive({
  // Les données saisies dans le formulaire
  intervenant: {...IntervenantVide},
  arret: {...ArretVide},
  // La liste des catégories affichée sous forme de table
  listeArret: []
});

// Change le format des dates pour ne plus afficher l'heure
function formatDate(date) {
  if (!(date instanceof Date)) {
    return "";
  }
  const options = {year: 'numeric', month: 'long', day: 'numeric'};
  return date.toLocaleDateString('fr-FR', options);
};

// converti un string en format date pour pouvoir utiliser la fonction format date
// on récupére les date sous un format string dans l'api
function parseISODate(dateString) {
  const year = dateString.substr(0, 4);
  const month = dateString.substr(5, 2) - 1; // Les mois commencent à 0
  const day = dateString.substr(8, 2);
  const hours = dateString.substr(11, 2);
  const minutes = dateString.substr(14, 2);
  const seconds = dateString.substr(17, 2);

  return new Date(year, month, day, hours, minutes, seconds);
};

// permet de récupérer les données de l'intervenant ici nom et prenom a partir de son id
// un seul intervenant
function chargeIntervenant() {
  // ID de l'intervenant que l'on souhaite afficher
  const idIntervenant = route.params.num_SS
  // Appel à l'API pour récupérer les informations de l'intervenant
  doAjaxRequest(`${BACKEND}/api/intervenants/${idIntervenant}`)
      .then((json) => {
        // Stocke les données dans la variable data.intervenant
        data.intervenant = json;
        // Vérifie que les données sont correctement stockées
        console.log(data.intervenant);
      })
      .catch((error) => {
        console.error(error);
        alert("Erreur lors de la récupération de l'intervenant.");
      });
};

// charges les données de l'arret
// liste d'arrets
function chargeArret() {
  const idIntervenant = route.params.num_SS // ID de l'intervenant que l'on souhaite afficher
  // Appel à l'API pour avoir la liste des arrets
  doAjaxRequest(`${BACKEND}/api/intervenants/${idIntervenant}/arrets?sort=debut&fin`)
      .then((json) => {
        data.listeArret = json._embedded.arrets;

      })
      .catch((error) => alert(error.message));
}

// A l'affichage du composant
// on charge les intervenants et les arrets
onMounted(() => {
  chargeIntervenant();
  chargeArret();
});
</script>


<template>
  <main>
    <div>
      <nav>
        <ul id="bandeau">
          <li>
            <div class="menu">
              Arrêts :
            </div>
          </li>
        </ul>
      </nav>

    </div>

    <div>
      <div class="table-container">
        <table class="tableintervenant">
          <tr class="head">
            <th class="colonne">Nom</th>
            <th class="colonne">Prénom</th>
            <th class="colonne">Date de début</th>
            <th class="colonne">Date de fin</th>
            <th class="colonne">Nombre de jour</th>
            <th class="colonne">Objet</th>
          </tr>
          <tr class="body" v-for="arrets in data.listeArret" :key="arrets.id">
            <!-- on met les informations de l'intervenant -->
            <td>{{ data.intervenant.nom }}</td>
            <td>{{ data.intervenant.prenom }}</td>
            <!-- on met sous format date -->
            <td>{{ formatDate(parseISODate(arrets.debut)) }}</td>
            <!-- on met sous format date -->
            <td>{{ formatDate(parseISODate(arrets.fin)) }}</td>
            <td>{{ arrets.nb_jours }}</td>
            <td>{{ arrets.objet }}</td>
          </tr>

        </table>
      </div>
    </div>
  </main>
</template>


<style scoped>
/* Bandeau */
main {
  padding-top: 20px;

}

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
  text-transform: uppercase; /* on met en majuscule */
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


bouton {
  padding-left: 10px;
  float: right;
}


.table-container {
  height: 700px; /* Hauteur maximale de votre tableau */
  overflow-y: auto; /* Ajoute une barre de défilement verticale */
  padding-top: 30px;
  width: 100%;
}

.tableintervenant {
  margin: 0 auto;
}

.head {
  position: sticky;/* Bloque le bandeau pour qu'il ne bouge pas quand on défile */
  z-index: 1; /*  contrôle la position d'un élément dans la pile d'affichage */
  top: 0;
}

.colonne {
  background-color: #659ABD;
  color: white;
  border: 1px solid grey;
}


td,
th {
  border: 1px solid #ddd;
  padding: 20px;
}

th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: white;
  color: black;
  font-weight: normal;
}
</style>