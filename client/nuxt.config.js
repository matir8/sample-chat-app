export default {
  // Disable server-side rendering: https://go.nuxtjs.dev/ssr-mode
  ssr: false,

  // Target: https://go.nuxtjs.dev/config-target
  target: 'static',

  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    title: 'Sample Chat App',
    htmlAttrs: {
      lang: 'en',
    },
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
      { name: 'format-detection', content: 'telephone=no' },
    ],
    link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }],
  },

  env: {
    backendDomain: process.env.BACKEND_DOMAIN || 'localhost:3000',
    backednScheme: process.env.BACKEND_SCHEME || 'http',
    chatUrl: `${process.env.WEBSOCKET_SCHEME}://${process.env.BACKEND_DOMAIN}/chat`
  },

  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [
    '~/plugins/actioncable-vue.js'
  ],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    // https://go.nuxtjs.dev/eslint
    '@nuxtjs/eslint-module',
  ],

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    // https://go.nuxtjs.dev/bootstrap
    'bootstrap-vue/nuxt',
    // https://go.nuxtjs.dev/axios
    '@nuxtjs/axios',
    '@nuxtjs/auth-next'
  ],

  // Axios module configuration: https://go.nuxtjs.dev/config-axios
  axios: {
    baseURL: `${process.env.BACKEND_SCHEME}://${process.env.BACKEND_DOMAIN}/api`,
  },

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {},

  auth: {
    plugins: [
      '~/plugins/axios.js'
    ],
    redirect: {
      login: '/login',
      logout: '/',
      callback: false,
      home: '/'
     },
    strategies: {
      local: {
        token: {
          required: false
        },
        user: {
          property: 'data',
          autoFetch: true
        },
        endpoints: {
          login: { url: '/auth/sign_in', method: 'post'},
          logout: { url: '/auth/sign_out', method: 'delete' },
          user: { url: '/users/me', method: 'get' },
         },
       }
     },
   },

   server: {
     port: 8000,
   },
}
