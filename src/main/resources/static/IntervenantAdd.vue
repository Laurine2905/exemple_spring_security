<script>
export default {
  name: "IntervenantAdd",

  methods: {
    // Fonction pour ajouter un nouvel intervenant
    handlerAdd(num_SS, nom, prenom, nom_jeune_fille, date_naiss, adresse, entree_collectivité, grade, libelle_temps_travail, titulaire, temps_travail_pourcentage, date_titularisation, metier) {
      // Pour vérifier que les paramètre sont bien pris
      console.log(num_SS, nom, prenom, nom_jeune_fille, date_naiss, adresse, entree_collectivité, grade, libelle_temps_travail, titulaire, temps_travail_pourcentage, date_titularisation, metier);
      let myHeaders = new Headers();
      myHeaders.append("Content-Type", "application/json");

      const fetchOptions = {
        method: "POST",
        headers: myHeaders,
        // on converti tous en string
        body: JSON.stringify({
          num_SS: num_SS,
          nom: nom,
          prenom: prenom,
          nom_jeune_fille: nom_jeune_fille,
          date_naiss: date_naiss,
          adresse: adresse,
          entree_collectivité: entree_collectivité,
          grade: grade,
          libelle_temps_travail: libelle_temps_travail,
          titulaire: titulaire,
          temps_travail_pourcentage: temps_travail_pourcentage,
          date_titularisation: date_titularisation,
          metier: metier
        }),
      };
// lien du back end
      fetch("http://localhost:8989/api/intervenants", fetchOptions)
          .then((response) => {
            return response.json();
          })
          .then((dataJSON) => {
            console.log(dataJSON);
            // Fenetre pop up
            window.alert("Intervenant ajouté");
            // vider les champs
            document.getElementById("num_SS").value = "";
            document.getElementById("nom").value = "";
            document.getElementById("prenom").value = "";
            document.getElementById("nom_jeune_fille").value = "";
            document.getElementById("motif").value = "";
            document.getElementById("date_naiss").value = "";
            document.getElementById("adresse").value = "";
            document.getElementById("entree_collectivité").value = "";
            document.getElementById("grade").value = "";
            document.getElementById("libelle_temps_travail").value = "";
            document.getElementById("titulaire").value = "";
            document.getElementById("temps_travail_pourcentage").value = "";
            document.getElementById("date_titularisation").value = "";
            document.getElementById("metier").value = "";
          })
          .catch((error) => console.log(error));
    }
  }
}

</script>


<template>
  <main>
    <div>
      <nav>
        <ul id="bandeau">
          <li>
            <div class="menu">
              Ajouter un nouvel agent
            </div>
          </li>
        </ul>
      </nav>

    </div>

    <div class="table-container">
      <table class="tableajout">
        <tr>
          <th>Numéro sécurité sociale *</th>
          <th>
            <input id="num_SS" v-model="num_SS" type="number" placeholder="Numéro de sécurité sociale">
          </th>
        </tr>
        <tr>
          <th>Nom *</th>
          <th>
            <input id="nom" v-model="nom" type="text" placeholder="Nom">
          </th>
        </tr>
        <tr>
          <th>Prénom *</th>
          <th>
            <input id="prenom" v-model="prenom" type="text" placeholder="Prénom">
          </th>
        </tr>
        <tr>
          <th>Nom de jeune fille</th>
          <th>
            <input id="nom_jeune_fille" v-model="nom_jeune_fille" type="text" placeholder="Nom de jeune fille">
          </th>
        </tr>
        <tr>
          <th>Date de naissance *</th>
          <th>
            <input id="date_naiss" v-model="date_naiss" type="date" placeholder="Date de naissance">
          </th>
        </tr>
        <tr>
          <th>Adresse *</th>
          <th>
            <input id="adresse" v-model="adresse" type="text" placeholder="Adresse">
          </th>
        </tr>
        <tr>
          <th>Date d'entrée dans la collectivité *</th>
          <th>
            <input id="entree_collectivité" v-model="entree_collectivité" type="date" placeholder="Date de naissance">
          </th>
        </tr>
        <tr>
          <th>Grade *</th>
          <th>
            <input id="grade" v-model="grade" type="text" placeholder="Grade">
          </th>
        </tr>
        <tr>
          <th>Libellé du temps de travail *</th>
          <th>
            <input id="libelle_temps_travail" v-model="libelle_temps_travail" type="text" placeholder="Libellé">
          </th>
        </tr>
        <tr>
          <th>Temps de travail en % *</th>
          <th>
            <input id="temps_travail_pourcentage" v-model="temps_travail_pourcentage" type="number" placeholder="En %">
          </th>
        </tr>
        <tr>
          <th>Titulaire ? *</th>
          <th>
            <input id="titulaire" v-model="titulaire" type="text" placeholder="Oui/Non">
          </th>
        </tr>
        <tr>
          <th>Date titularisation</th>
          <th>
            <input id="date_titularisation" v-model="date_titularisation" type="date" placeholder="Date de naissance">
          </th>
        </tr>
        <tr>
          <th>Métier *</th>
          <th>
            <input id="metier" v-model="metier" type="text" placeholder="Métier">
          </th>
        </tr>
        <tr>
          <th>* Les champs suivants sont obligatoires</th>
          <th>
            <button class="add"
                    @click="handlerAdd(num_SS, nom, prenom, nom_jeune_fille, date_naiss,adresse, entree_collectivité,grade, libelle_temps_travail, titulaire, temps_travail_pourcentage, date_titularisation, metier )">
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


/* objet action */
bouton {
  padding-left: 10px;
}

.add {
  width: 100%;
}
input{
  width: 100%;
}


/*Tableau*/

.table-container {
 /* Hauteur maximale de votre tableau */
  overflow-y: auto; /* Ajoute une barre de défilement verticale */
  padding-top: 30px;
  display: flex;
  justify-content: center;
}

td,
th {
  border: 1px solid #ddd;
  padding: 8px;
}

th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: #659ABD;
  color: rgb(255, 255, 255);
}
</style>