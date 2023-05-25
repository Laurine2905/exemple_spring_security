import Vue from 'vue';
import App from '../static/App.vue';
import router from '../static/router.js';

new Vue({
    router,
    render: h => h(App)
}).$mount('#app');
