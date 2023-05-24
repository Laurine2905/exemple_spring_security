<template>
  <div>
    <nav>
      <ul id="bandeau">
        <li>
          <div id="menu" class="menu">
            <router-link to="/" class="nav-link">Agent</router-link>
          </div>
        </li>
        <li>
          <div id="menu" class="menu">
            <router-link to="/arret" class="nav-link">Arrêt maladie</router-link>
          </div>
        </li>
        <li>
          <div id="menu" class="menu">
            <router-link to="/statistiqueage" class="nav-link">Statistique âge</router-link>
          </div>
        </li>
        <li>
          <div id="menu" class="menu">
            <router-link to="/statistiquemetier" class="nav-link">Statistique métier</router-link>
          </div>
        </li>
      </ul>
    </nav>

    <div class="container-fluid">
      <router-view />
    </div><!-- /.container -->
  </div>
</template>

<style scoped>
/*bandeau de navigation*/

#bandeau{
  height: 47px;
  display: flex;  /*répartit les titres sur toute la ligne du bandeau*/
  padding: 0px;
  background-color: rgba(255, 140, 0, 0);
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
  text-transform: uppercase;
  color: #659ABD;
  text-decoration: none;
  display: block;
  border-bottom: 2px solid #659ABD;
  border-top: 2px solid #659ABD;
  padding: 15px 0px;
}

#bandeau .menu:hover{
  color: #222A73;
  border-bottom: 2px solid #222A73;
  border-top: 2px solid #222A73;
}

nav #bandeau::after{
  display: table;
}

</style>
