<script setup>
import {reactive, onMounted} from "vue";
import {BACKEND, doAjaxRequest} from "@/views/api.js";
import router from "@/../../../../exemple_spring_security/src/main/resources/static/js";

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
  formulaireIntervenant: {...IntervenantVide},
  intervenant: {...IntervenantVide},
  // La liste des catégories affichée sous forme de table
  listeIntervenant: []
});


function chargeIntervenant() {
  // Appel à l'API pour avoir la liste des intervenants
  // on tri par ordre alphabétique
  doAjaxRequest(BACKEND + "/api/intervenants?sort=nom&prenom")
      .then((json) => {
        data.listeIntervenant = json._embedded.intervenants;
      })
      .catch((error) => alert(error.message));
}
// fonction qui récupere le num_SS de la fonction sur laquelle on a cliquer et la stocke pour pouvoir la réutiliser dans IntervenantFiche et faire une fiche individuelle
function afficherFiche(num_SS) {
  router.push({ name: 'intervenantfiche', params: { num_SS } });
}

// A l'affichage du composant, on affiche la liste
onMounted(chargeIntervenant);
</script>


<template>
  <main>
    <div class="hautpage">
      <nav>
        <ul id="bandeau">
          <li>
            <div class="menu">
           Les agents
            </div>
          </li>
          <li>

          </li>
          <li>
            <div class="action">
              <!-- revoie vers la composant IntervenantAdd -->
              <button>
                <router-link to="/intervenant/rechercher" class="nav-link">Gérer les agents</router-link>
              </button>
              <!-- revoie vers la composant IntervenantAdd -->
            <button>
              <router-link to="/ajouterIntervenant" class="nav-link">Ajouter un agent</router-link>
            </button>
            </div>
          </li>
        </ul>
      </nav>

      </div>


      <div class="table-container">
      <table class="tableintervenant">
        <tr class="head">
          <th>Num SS</th>
          <th>Nom</th>
          <th>Prénom</th>
          <th>Métier</th>
          <th>Fiche individuelle</th>
        </tr>
        <!-- Si le tableau des catégories est vide -->
        <tr class="body" v-if="!data.listeIntervenant">
          <td colspan="6">Veuillez patienter, chargement des intervenants...</td>
        </tr>
        <!-- Si le tableau des catégories n'est pas vide -->
        <!-- on n'affiche pas toutes les informations juste un résumé, toutes les infos sont dans les fiches individuelles -->
        <tr class="body" v-for="intervenants in data.listeIntervenant" :key="intervenants.num_SS">
          <td>{{ intervenants.num_SS }}</td>
          <td>{{ intervenants.nom }}</td>
          <td>{{ intervenants.prenom}}</td>
          <td>{{ intervenants.metier}}</td>
          <td>
            <!-- on va sur la fiche individuelle de l'intervenant -->
            <button class="add" @click="afficherFiche(intervenants.num_SS)">
              <img src="../assets/fleche-droite.png" height="30" width="30" alt="acceder"/>
            </button>
          </td>
        </tr>
      </table>
    </div>
  </main>
</template>



<style scoped>
.hautpage{
  background-color: white;
  z-index: 1;
  min-height:90px;
}
bouton{
  padding-left: 10px;
}

.rechercher:hover{
  border: 1px solid #659ABD;
}

.add{
  float: right;
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

#bandeau .action{
  padding-top: 20px;
}

nav #bandeau::after{
  display: table;
}

/* Tableau d'affichage des intervenants */
main{
  padding-top: 20px;

}
.add {
  width: 100%; /* etale sur toute la largeur */
}

.table-container {
  height: 700px; /* Hauteur maximale de votre tableau */
  overflow-y: auto; /* Ajoute une barre de défilement verticale */

}

.tableintervenant {
  margin: 0 auto;
}

.head{
  position: sticky;/* Bloque le bandeau pour qu'il ne bouge pas quand on défile */
  z-index: 1; /*  contrôle la position d'un élément dans la pile d'affichage */
  top: 0;
}
.body{
  z-index: 2;
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