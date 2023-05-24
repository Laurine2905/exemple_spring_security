import Vue from 'vue';
import App from '../static/js/App.vue';
import router from '../static/js/router.js';

new Vue({
    router,
    render: h => h(App)
}).$mount('#app');
