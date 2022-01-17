import Vue from "vue"
import ActionCableVue from "actioncable-vue"

if (process.client) {
  Vue.use(ActionCableVue, {
    debug: false,
    connectionUrl: `ws://${process.env.backendDomain}/chat`,
    connectImmediately: false,
  })
}
