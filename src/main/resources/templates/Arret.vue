<script setup>
import {reactive, onMounted} from "vue";
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

// Pour réinitialiser le formuaire
const ArretVide = {
  id: "",
  debut: "",
  fin: "",
  nb_jours: "",
  objet: "",
  intervenant_num_ss: "",
};

// Pour réinitialiser le formuaire
const ArretVide2 = {
  id: "",
  debut: "",
  fin: "",
  nb_jours: "",
  objet: "",
  categorie:"",
  intervenant_num_ss: "",
};

let data = reactive({
  // Les données saisies dans le formulaire
  formulaireArret: {...ArretVide},
  formulaireArret2: {...ArretVide2},
  intervenant: {...IntervenantVide},
  // La liste des arrets affichée sous forme de table
  listeArret: [],
  listeArret2: []
});

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
}

// Change le format des dates pour ne plus afficher l'heure
function formatDate(date) {
  if (!(date instanceof Date)) {
    return "";
  }
  const options = {year: 'numeric', month: 'long', day: 'numeric'};
  return date.toLocaleDateString('fr-FR', options);
}



function chargeArrets() {
  // Appel à l'API pour avoir la liste des arrets
  // on trie par date de début pour avoir un meilleur affichage
  console.log("chargement arret 1")
  doAjaxRequest(BACKEND + "/api/arrets?sort=debut")
      .then((json) => {
        data.listeArret = json._embedded.arrets;
        console.log(data.listeArret)

        // Récupération des intervenants pour chaque arrêt pour l'affichage des noms et prénom
        data.listeArret.forEach((arret) => {
          console.log(data.listeArret)
          // on appelle la fonction chargeIntervenant avec l'id de l'arret qu'on est en train de train pour récupéré l'intervenant correspondant
          chargeIntervenant(arret.id);
        });
      })
      .catch((error) => {
        console.error(error);
        alert("Erreur lors de la récupération de l'intervenant.");
      });
}

function chargeArrets2() {
  // Appel à l'API pour avoir la liste des arrets
  // on trie par date de début pour avoir un meilleur affichage
  console.log("Chargement arret 2")
  doAjaxRequest(BACKEND + "/api/arret2s?sort=debut")
      .then((json) => {
        data.listeArret2 = json._embedded.arret2s;
        console.log(data.listeArret2)

        // Récupération des intervenants pour chaque arrêt pour l'affichage des noms et prénom
        data.listeArret2.forEach((arret) => {
          console.log(data.listeArret2)
          // on appelle la fonction chargeIntervenant avec l'id de l'arret qu'on est en train de train pour récupéré l'intervenant correspondant
          chargeIntervenant2(arret.id);
        });
      })
      .catch((error) => {
        console.error(error);
        alert("Erreur lors de la récupération de l'intervenant.");
      });
}

function chargeIntervenant(idArret) {
  // Appel à l'API pour récupérer les informations de l'intervenant
  // on passe par les arret -> son id -> intervenant correspondant
  console.log("Chargement intervenant")
  doAjaxRequest(`${BACKEND}/api/arrets/${idArret}/intervenant`)
      .then((json) => {
        // Stocke les données dans le tableau d'intervenants pour l'arrêt en question
        const intervenant = json;
        const arret = data.listeArret.find((arret) => arret.id === idArret);
        if (arret) {
          if (!arret.intervenants) {
            arret.intervenants = [intervenant];
          } else {
            // on met l'intervenant dans la liste d'arret
            arret.intervenants.push(intervenant);
          }
        }
      })
      .catch((error) => {
        console.error(error);
        alert("Erreur lors de la récupération de l'intervenant.");
      });
};

function chargeIntervenant2(idArret) {
  // Appel à l'API pour récupérer les informations de l'intervenant
  // on passe par les arret -> son id -> intervenant correspondant
  console.log("Chargement intervenant")
  doAjaxRequest(`${BACKEND}/api/arret2s/${idArret}/intervenant`)
      .then((json) => {
        // Stocke les données dans le tableau d'intervenants pour l'arrêt en question
        const intervenant = json;
        const arret = data.listeArret2.find((arret) => arret.id === idArret);
        if (arret) {
          if (!arret.intervenants) {
            arret.intervenants = [intervenant];
          } else {
            // on met l'intervenant dans la liste d'arret
            arret.intervenants.push(intervenant);
          }
        }
      })
      .catch((error) => {
        console.error(error);
        alert("Erreur lors de la récupération de l'intervenant.");
      });
};

// A l'affichage du composant, on affiche la liste des arrets et des intervenants
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
              Les arrêts
            </div>
          </li>
        </ul>
      </nav>

    </div>

    <div>
      <div class="table-container">
        <table class="tableintervenant">
          <tr class="head">
            <th>Nom</th>
            <th>Prénom</th>
            <th>Date de début</th>
            <th>Date de fin</th>
            <th>Durée en jours </th>
            <th>Objet</th>
          </tr>
          <!-- Si le tableau des catégories est vide -->
          <tr v-if="!data.listeArret">
            <td colspan="4">Veuillez patienter, chargement des produits...</td>
          </tr>
          <!-- Si le tableau des catégories n'est pas vide -->
          <!-- boucle pour récuperer les arrets -->
          <tr v-for="arret in data.listeArret" :key="arret.id">
            <td>
              <!-- boucle pour récuperer les intervenants correspondants aux arrets -->
              <div v-for="intervenant in arret.intervenants" :key="intervenant.num_SS">
                {{ intervenant.nom }}
              </div>
            </td>
            <td>
              <!-- boucle pour récuperer les intervenants correspondants aux arrets -->
              <div v-for="intervenant in arret.intervenants" :key="intervenant.num_SS">
                {{ intervenant.prenom }}
              </div>
            </td>
            <!-- On converti les date pour qu'elle soient plus faciles à lire et sans l'affichage de l'heure -->
            <td>{{ formatDate(parseISODate(arret.debut)) }}</td>
            <!-- On converti les date pour qu'elle soient plus faciles à lire et sans l'affichage de l'heure -->
            <td>{{ formatDate(parseISODate(arret.fin)) }}</td>
            <td>{{ arret.nb_jours }}</td>
            <td>{{ arret.objet }}</td>
          </tr>
          <tr class="head">
            <th>Nom</th>
            <th>Prénom</th>
            <th>Date de début</th>
            <th>Date de fin</th>
            <th>Durée en jours </th>
            <th>Objet</th>
          </tr>
          <!-- boucle pour récuperer les arrets -->
          <tr v-for="arret in data.listeArret2" :key="arret.id">
            <td>
              <!-- boucle pour récuperer les intervenants correspondants aux arrets -->
              <div v-for="intervenant in arret.intervenants" :key="intervenant.num_SS">
                {{ intervenant.nom }}
              </div>
            </td>
            <td>
              <!-- boucle pour récuperer les intervenants correspondants aux arrets -->
              <div v-for="intervenant in arret.intervenants" :key="intervenant.num_SS">
                {{ intervenant.prenom }}
              </div>
            </td>
            <!-- On converti les date pour qu'elle soient plus faciles à lire et sans l'affichage de l'heure -->
            <td>{{ formatDate(parseISODate(arret.debut)) }}</td>
            <!-- On converti les date pour qu'elle soient plus faciles à lire et sans l'affichage de l'heure -->
            <td>{{ formatDate(parseISODate(arret.fin)) }}</td>
            <td>{{ arret.nb_jours }}</td>
            <td>{{ arret.objet }}</td>
          </tr>
        </table>
      </div>
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

.table-container {
  height: 500px; /* Hauteur maximale de votre tableau */
  overflow-y: auto; /* Ajoute une barre de défilement verticale */
  padding-top: 30px;
}

.tableintervenant {
  margin: 0 auto;
}

.head{
  position: sticky; /* Bloque le bandeau pour qu'il ne bouge pas quand on défile */
  z-index: 1; /*  contrôle la position d'un élément dans la pile d'affichage */
  top: 0;
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
  background-color: #659ABD;
  color: rgb(255, 255, 255);
}
</style>