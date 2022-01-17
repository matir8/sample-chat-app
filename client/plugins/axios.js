export default function({ $axios, $auth }) {
  $axios.onRequest(config => {
    config.headers.client = $auth.$storage.getState("client")
    config.headers["access-token"] = $auth.$storage.getState("access-token")
    config.headers.uid = $auth.$storage.getState("uid")
    config.headers["token-type"] = $auth.$storage.getState("token-type")
  })

  $axios.onResponse(response => {
    if (response.headers.client) {
      $auth.$storage.setState("access-token", response.headers["access-token"])
      $auth.$storage.setState("client", response.headers.client)
      $auth.$storage.setState("uid", response.headers.uid)
      $auth.$storage.setState("token-type", response.headers["token-type"])
    }
  })
}
