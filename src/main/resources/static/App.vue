<script setup>
import Bandeau from "./Bandeau.vue";
import Intervenant from "../../../exemple_spring_security/src/main/resources/templates/Intervenant.vue";
</script>

<template>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My App</title>
    <base href="/" />
    <!-- ... autres balises d'en-tête ... -->
  </head>

  <body>
  <div>
    <Bandeau />
    <router-view></router-view>
  </div>
  </body>
</template>

<style scoped>
</style>