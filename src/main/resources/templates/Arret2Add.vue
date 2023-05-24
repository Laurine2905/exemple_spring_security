<script setup>
import {BACKEND, doAjaxRequest} from "@/views/api.js";
import { useRoute } from 'vue-router'
import {onMounted, reactive} from "vue";

// on utilise route pour récupérer les num_ss qui est stocké dans la route -> on l'a récupéré via Intervenant fiche
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
  metier:""
};

let data = reactive({
  // Les données saisies dans le formulaire
  intervenant: {...IntervenantVide}
});

// permet d'ajouter un arret spécial
function handlerAdd(date_debut, date_fin, nb_jours, motif, categorie) {
  console.log(date_debut, date_fin, nb_jours, motif);

  let myHeaders = new Headers();
  myHeaders.append("Content-Type", "application/json");

  const fetchOptions = {
    method: "POST",
    headers: myHeaders,
    body: JSON.stringify({
      debut: date_debut,
      fin: date_fin,
      nb_jours: nb_jours,
      objet: motif,
      categorie: categorie,
      // route.params.num_SS = le num_SS de la personne qui avait la fiche personnelle
      // on rentre le lien de l'api
      intervenant: "http://localhost:8989/api/intervenants/" + route.params.num_SS
    }),
  };
// on met les informations dans l'entité contrat
  fetch("http://localhost:8989/api/arret2s", fetchOptions)
      .then((response) => {
        return response.json();
      })
      .then((dataJSON) => {
        console.log(dataJSON);
        window.alert("Arrêt ajouté"); // afficher fenêtre pop-up de succès
        // vider les champs
        document.getElementById("date_debut").value = "";
        document.getElementById("date_fin").value = "";
        document.getElementById("nb_jours").value = "";
        document.getElementById("objet").value = "";
        document.getElementById("categorie").value = "";
      })
      .catch((error) => console.log(error));

};

// on charge l'intervenant pour récupérer son num ss et le mettre directement dans l'ajout d'un arret
function chargeIntervenant() {
  const idIntervenant = route.params.num_SS // ID de l'intervenant que l'on souhaite afficher
  // Appel à l'API pour récupérer les informations de l'intervenant
  doAjaxRequest(`${BACKEND}/api/intervenants/${idIntervenant}`)
      .then((json) => {
        // Stocke les données dans la variable data.intervenant
        data.intervenant = json;
        console.log(data.intervenant); // Vérifie que les données sont correctement stockées
      })
      .catch((error) => {
        console.error(error);
        alert("Erreur lors de la récupération de l'intervenant.");
      });
};

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
              <!-- on affiche le nom et prénom de la personne concerné -->
              <div> Ajouter un arrêt spécial : {{data.intervenant.nom}} {{data.intervenant.prenom}} </div>
            </div>
          </li>
        </ul>
      </nav>

    </div>

    <div class="table-container">
      <table class="tableajout">
        <tr>
          <th class="colonne">Début de l'arrêt *</th>
          <th>
            <input id="date_debut" v-model="date_debut" type="date" placeholder="Date début">
          </th>
        </tr>
        <tr>
          <th class="colonne">Fin de l'arrêt *</th>
          <th>
            <input id="date_fin" v-model="date_fin" type="date" placeholder="Date fin">
          </th>
        </tr>
        <tr>
          <th class="colonne">Durée *</th>
          <th>
            <input id="nb_jours" v-model="nb_jours" type="number" placeholder="Durée en jours">
          </th>
        </tr>
        <tr>
          <th class="colonne">Objet *</th>
          <th>
            <input id="objet" v-model="objet" type="text" placeholder="Objet">
          </th>
        </tr>

        <tr>
          <th class="colonne">
            <div>
              Catégorie *
              <br>
              1: Maternité / Paternité
              <br>
              2: Accident du travail / Maladie professionnelle
              <br>
              3: Congés spéciaux
          </div>
          </th>
          <th>
            <input id="categorie" v-model="categorie" type="number" placeholder="1-2-3">
          </th>
        </tr>
        <tr>
          <th class="colonne">* Les champs suivants sont obligatoires</th>
          <th>
            <button class="add"
                    @click="handlerAdd(date_debut, date_fin, nb_jours, objet, categorie )">
              Ajouter
            </button>
          </th>
        </tr>
      </table>
    </div>
  </main>
</template>


<style scoped>
/* Bandeau */
main {
  padding-top: 20px;

}

bouton {
  padding-left: 10px;
}

.add {
  width: 100%;
}

input{
  width: 100%;
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

/*Tableau*/

.table-container {
  height: 500px; /* Hauteur maximale de votre tableau */
  overflow-y: auto; /* Ajoute une barre de défilement verticale */
  padding-top: 30px;
  display: flex;
  justify-content: center;
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
  background-color: white;
  color: black;
  font-weight: normal;
}
.colonne {
  background-color: #659ABD;
  color: white;
  font-weight: bold;
}
</style>