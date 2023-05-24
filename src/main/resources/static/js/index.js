import { createRouter, createWebHistory } from 'vue-router';

import Intervenant from 'C:/Users/lauri/IdeaProjects/exemple_spring_security/src/main/resources/static/Intervenant.vue';
import IntervenantAdd from 'C:/Users/lauri/IdeaProjects/exemple_spring_security/src/main/resources/static/IntervenantAdd.vue';
import IntervenantFiche from 'C:/Users/lauri/IdeaProjects/exemple_spring_security/src/main/resources/static/IntervenantFiche.vue';
import IntervenantContrat from 'C:/Users/lauri/IdeaProjects/exemple_spring_security/src/main/resources/static/IntervenantContrat.vue';
import Arret from 'C:/Users/lauri/IdeaProjects/exemple_spring_security/src/main/resources/static/Arret.vue';
import Rechercher from 'C:/Users/lauri/IdeaProjects/exemple_spring_security/src/main/resources/static/Rechercher.vue';
import ArretAdd from 'C:/Users/lauri/IdeaProjects/exemple_spring_security/src/main/resources/static/ArretAdd.vue';
import Arret2Add from 'C:/Users/lauri/IdeaProjects/exemple_spring_security/src/main/resources/static/Arret2Add.vue';
import StatistiqueMetier  from "C:/Users/lauri/IdeaProjects/exemple_spring_security/src/main/resources/static/StatistiqueMetier.vue";
import StatistiqueAge  from "C:/Users/lauri/IdeaProjects/exemple_spring_security/src/main/resources/static/StatistiqueAge.vue";
import ContratAdd  from "C:/Users/lauri/IdeaProjects/exemple_spring_security/src/main/resources/static/ContratAdd.vue";
import IntervenantArret from "C:/Users/lauri/IdeaProjects/exemple_spring_security/src/main/resources/templates/IntervenantArret.vue";


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
    // Associe des chemins d'accès au composant vue à afficher
  routes: [
    {
      path: '/',
      name: 'intervenant',
      component: Intervenant,
    },
    {
      path: '/fiche/:num_SS',
      name: 'intervenantfiche',
      component: IntervenantFiche,
      props: true
    },
    {
      path: '/ajouterIntervenant',
      name: 'addintervenant',
      component: IntervenantAdd
    },
    {
      path: '/arret',
      name: 'arret',
      component: Arret
    },
    {
      path: '/intervenant/rechercher',
      name: 'rechercher',
      component: Rechercher
    },
    {
      path: '/intervenant/ajouterarret/:num_SS',
      name: 'arretadd',
      component: ArretAdd,
      props: true
    },
    {
      path: '/intervenant/ajouterarret/special/:num_SS',
      name: 'arretadd2',
      component: Arret2Add,
      props: true
    },
    {
      path: '/intervenant/arret/:num_SS',
      name: 'arretintervenant',
      component: IntervenantArret,
      props: true
    },
    {
      path: '/intervenant/contrat/:num_SS',
      name: 'contratintervenant',
      component: IntervenantContrat,
      props: true
    },
    {
      path: '/statistiquemetier',
      name: 'statistiquemetier',
      component: StatistiqueMetier
    },
    {
      path: '/intervenant/ajoutercontrat/:num_SS',
      name: 'contratadd',
      component: ContratAdd,
      props: true
    },
    {
      path: '/statistiqueage',
      name: 'statistiqueage',
      component: StatistiqueAge
    }
  ]
})

export default router