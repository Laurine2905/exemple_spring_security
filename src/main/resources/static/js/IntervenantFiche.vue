<script setup>
import {BACKEND, doAjaxRequest} from "@/views/api.js";
import {onMounted, reactive} from "vue";
import { useRoute } from 'vue-router'
import router from "@/../../../../exemple_spring_security/src/main/resources/static/js/router.js";

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
// Change le format des dates pour ne plus afficher l'heure
function formatDate(date) {
  if (!(date instanceof Date)) {
    return "";
  }
  const options = { year: 'numeric', month: 'long', day: 'numeric' };
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
// fonction qui récupere le num_SS de la fonction sur laquelle on a cliquer et la stocke pour pouvoir la réutiliser dans ArretAdd
function ajoutArret(num_SS) {
  router.push({ name: 'arretadd', params: { num_SS } });
}

// fonction qui récupere le num_SS de la fonction sur laquelle on a cliquer et la stocke pour pouvoir la réutiliser dans Arret2Add => arrêt spéciaux aka maternité, accident de travail, congés spéciaux
function ajoutArret2(num_SS) {
  router.push({ name: 'arretadd2', params: { num_SS } });
}
// fonction qui récupere le num_SS de la fonction sur laquelle on a cliquer et la stocke pour pouvoir la réutiliser dans ContratAdd
function ajoutContrat(num_SS) {
  router.push({ name: 'contratadd', params: { num_SS } });
}
// fonction qui récupere le num_SS de la fonction sur laquelle on a cliquer et la stocke pour pouvoir la réutiliser dans IntervenantArret
function Arret(num_SS) {
  router.push({ name: 'arretintervenant', params: { num_SS } });
}
// fonction qui récupere le num_SS de la fonction sur laquelle on a cliquer et la stocke pour pouvoir la réutiliser dans IntervenantContrat
function Contrat(num_SS) {
  router.push({ name: 'contratintervenant', params: { num_SS } });
}

// A l'affichage du composant, on affiche la liste
onMounted(chargeIntervenant);
</script>




<template>
  <main>
    <div>
      <nav>
        <ul id="bandeau">
          <li>
            <div class="menu">
              Fiche intervenant
            </div>
          </li>
        </ul>
      </nav>

      <div class="table-container">
        <table class="tableajout">
          <tr>
            <th class="exter">
              <div class="table-container2">
                <table class="tableajout2">
                  <tr>
                    <th class="colonne">Numéro sécurité sociale</th>
                    <th>{{data.intervenant.num_SS}}</th>
                  </tr>

                  <tr>
                    <th class="colonne">Prénom</th>
                    <th>
                      {{data.intervenant.prenom}}
                    </th>
                  </tr>

                  <tr>
                    <th class="colonne">Date de naissance</th>
                    <th>
                      {{formatDate(parseISODate(data.intervenant.date_naiss))}}
                    </th>
                  </tr>


                  <tr>
                    <th class="colonne">Date d'entrée dans la collectivité</th>
                    <th>
                      {{formatDate(parseISODate(data.intervenant.entree_collectivité))}}
                    </th>
                  </tr>

                  <tr>
                    <th class="colonne">Libellé du temps de travail</th>
                    <th>
                      {{data.intervenant.libelle_temps_travail}}
                    </th>
                  </tr>

                  <tr>
                    <th class="colonne">Titulaire ?</th>
                    <th>
                      {{data.intervenant.titulaire}}
                    </th>
                  </tr>


                  <tr>
                    <th class="colonne">Métier</th>
                    <th>
                      {{data.intervenant.metier}}
                    </th>
                  </tr>


                </table>
              </div>
            </th>
            <th class="exter">
              <div class="table-container2">
                <table class="tableajout2">
                  <tr>
                    <th class="colonne">Nom</th>
                    <th>
                      {{data.intervenant.nom}}
                    </th>
                  </tr>

                  <tr>
                    <th class="colonne">Nom de jeune fille</th>
                    <th>
                      {{data.intervenant.nom_jeune_fille}}
                    </th>
                  </tr>

                  <tr>
                    <th class="colonne">Adresse</th>
                    <th>
                      {{data.intervenant.adresse}}
                    </th>
                  </tr>

                  <tr>
                    <th class="colonne">Grade</th>
                    <th>
                      {{data.intervenant.grade}}
                    </th>
                  </tr>

                  <tr>
                    <th class="colonne">Temps de travail en %</th>
                    <th>
                      {{data.intervenant.temps_travail_pourcentage}}
                    </th>
                  </tr>

                  <tr>

                    <th class="colonne">Date titularisation</th>
                    <th>
                      {{data.intervenant.date_titularisation}}
                    </th>
                  </tr>

                </table>
              </div>

            </th>
            <th class="exter">
              <div class="table-container2">
                <table class="tableajout2">
                  <tr>
                    <th class="colonne">Ajouter un arrêt</th>
                    <th>
                      <button @click="ajoutArret(data.intervenant.num_SS)">
                       <img src="../assets/fleche-droite.png" height="30" width="30" alt="acceder"/>
                      </button>
                    </th>
                  </tr>
                  <tr>
                    <th class="colonne">Ajouter un arrêt spécial</th>
                    <th>
                      <button @click="ajoutArret2(data.intervenant.num_SS)">
                        <img src="../assets/fleche-droite.png" height="30" width="30" alt="acceder"/>
                      </button>
                    </th>
                  </tr>
                  <tr>
                    <th class="colonne">Ajouter un contrat</th>
                    <th>
                      <button @click="ajoutContrat(data.intervenant.num_SS)">
                        <img src="../assets/fleche-droite.png" height="30" width="30" alt="acceder"/>

                      </button>
                    </th>
                  </tr>

                  <tr>
                    <th class="colonne">Voir tous les arrêts</th>
                    <th>
                      <button @click="Arret(data.intervenant.num_SS)">
                        <img src="../assets/fleche-droite.png" height="30" width="30" alt="acceder"/>
                      </button>
                    </th>
                  </tr>
                  <tr>
                    <th class="colonne">Voir tous les contrats</th>
                    <th>
                      <button @click="Contrat(data.intervenant.num_SS)">
                        <img src="../assets/fleche-droite.png" height="30" width="30" alt="acceder"/>
                      </button>
                    </th>
                  </tr>
                </table>
              </div>

            </th>
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

bouton {
  padding-left: 10px;
  float: right;
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

#bandeau .action {
  padding-top: 20px;
}

nav #bandeau::after {
  display: table;
}

/*Tableau*/

.table-container {
  height: 500px; /* Hauteur maximale de votre tableau */
  padding-top: 0px;
  width: 100%;
  display: flex;
  justify-content: center;
}

.table-container2 {
  height: 500px; /* Hauteur maximale de votre tableau */
  padding-top: 30px;
  display: flex;
  justify-content: center;
}

.colonne {
  background-color: #659ABD;
  color: white;
}

td,
.exter {
  border: 1px none #ddd;
  padding: 8px;
  font-weight: bold;
}

.exter {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: white;
  color: black;
  font-weight: bold;
}

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
</style>