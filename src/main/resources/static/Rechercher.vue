<script setup>
import { reactive, onMounted } from "vue";
import { ref } from "vue";
import { BACKEND, doAjaxRequest } from "@/views/api.js";
import router from "@/../../../../exemple_spring_security/src/main/resources/static/js";

// Pour réinitialiser le formulaire
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
  metier: "",
};

let data = reactive({
  // Les données saisies dans le formulaire
  formulaireIntervenant: { ...IntervenantVide },
  intervenant: { ...IntervenantVide },
  // La liste des catégories affichée sous forme de table
  listeIntervenant: [],
});

let showConfirmationPopup = ref(false); // Indicateur pour afficher/masquer la fenêtre contextuelle
let currentIntervenantId = null; // ID de l'intervenant en cours de suppression

function showError(error) {
  console.log("Erreur : status %d", error.status);
  console.log(error.body);
  alert(error.message);
}

function chargeIntervenant() {
  // Appel à l'API pour avoir la liste des intervenants
  // on trie par ordre alphabétique
  doAjaxRequest(BACKEND + "/api/intervenants?sort=nom&prenom")
      .then((json) => {
        data.listeIntervenant = json._embedded.intervenants;
      })
      .catch((error) => alert(error.message));
}

/**
 * Supprime une entité
 */
function supprimerIntervenant(intervenantId) {
   // Récupérer les contrats de l'intervenant
  doAjaxRequest(`${BACKEND}/api/intervenants/${intervenantId}/contrats`)
      .then((json) => {
        if (json._embedded && json._embedded.contrats) {
          const contrats = json._embedded.contrats; // Extraire le tableau de contrats
          // Supprimer chaque contrat
          contrats.forEach((contrat) => {
            const contratId = contrat.id;
            // Supprimer le contrat
            doAjaxRequest(BACKEND + "/api/contrats/" + contratId, { method: "DELETE" })
                .catch((error) => showError(error));
          });
        } else {
          console.log("Aucun contrat trouvé pour l'intervenant");
        }
      })
      .catch((error) => showError(error));

  // Récupérer les arrêts de travail de l'intervenant
  doAjaxRequest(`${BACKEND}/api/intervenants/${intervenantId}/arrets`)
      .then((json) => {
        // Supprimer chaque arrêt de travail
        if (json._embedded && json._embedded.arrets) {
          const arrets = json._embedded.arrets;
          arrets.forEach((arret) => {
            const arretId = arret.id;
            // Supprimer l'arrêt de travail
            doAjaxRequest(BACKEND + "/api/arrets/" + arretId, { method: "DELETE" })
                .catch((error) => showError(error));
          });
        } else {
          console.log("Aucun arrêt de travail trouvé pour l'intervenant");
        }
      })
      .catch((error) => showError(error));

  // Récupérer les arrêts de travail de l'intervenant
  doAjaxRequest(`${BACKEND}/api/intervenants/${intervenantId}/arrets2`)
      .then((json) => {
        // Supprimer chaque arrêt de travail
        if (json._embedded && json._embedded.arrets2) {
          const arrets2 = json._embedded.arrets2;
          arrets2.forEach((arret) => {
            const arretId = arret.id;
            // Supprimer l'arrêt de travail
            doAjaxRequest(BACKEND + "/api/arret2s/" + arretId, { method: "DELETE" })
                .catch((error) => showError(error));
          });
        } else {
          console.log("Aucun arrêt de travail spécial trouvé pour l'intervenant");
        }
      })
      .catch((error) => showError(error));

  // Supprimer l'intervenant lui-même
  doAjaxRequest(BACKEND + "/api/intervenants/" + intervenantId, { method: "DELETE" })
      .then(() => {
        // Actualiser la liste des intervenants après suppression
        chargeIntervenant();
      })
      .catch((error) => showError(error));
}

function popup(intervenantId){
  // Ouvrir la fenêtre pop-up de confirmation
  showConfirmationPopup.value = true;
  currentIntervenantId = intervenantId;
}
function cancelDeletion() {
  showConfirmationPopup.value = false; // Masquer la fenêtre contextuelle
  currentIntervenantId = null;
}

function confirmDeletion() {
  supprimerIntervenant(currentIntervenantId); // Supprimer l'intervenant
  showConfirmationPopup.value = false; // Masquer la fenêtre contextuelle
  currentIntervenantId = null;
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
              Gérer les agents
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
          <th>Supprimer</th>
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
            <button class="add" @click="popup(intervenants.num_SS)">
              <img src="assets/supprimer.png" height="30" width="30"/>
            </button>
          </td>
        </tr>
      </table>
    </div>

    <div v-if="showConfirmationPopup" class="popup">
      <div class="popup-content">
        <p>Voulez-vous vraiment supprimer cet agent ?</p>
        <div class="popup-buttons">
          <button @click="cancelDeletion">Annuler</button>
          <button @click="confirmDeletion">Confirmer</button>

        </div>
      </div>
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

/* Bouton pop up */

.popup-content {
  background-color: #fff;
  padding: 20px;
}

.popup-buttons {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
}

.popup-buttons button {
  margin-left: 10px;
}

.popup {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}


</style>
