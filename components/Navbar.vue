<template>
  <div>
    <b-navbar type="dark" variant="dark">
      <b-navbar-brand to="/">Sample Chat App</b-navbar-brand>

      <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

      <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav class="ml-auto">
          <b-nav-item v-if="!$auth.loggedIn" to="/signup">Sign up</b-nav-item>
          <b-nav-item v-if="!$auth.loggedIn" to="/login">Sign in</b-nav-item>

          <b-nav-item-dropdown v-if="$auth.loggedIn" right>
            <template #button-content>
              <span class="text-white">{{$auth.user.attributes.name}}</span>
            </template>
            <b-dropdown-item to="/">Profile</b-dropdown-item>
            <b-dropdown-item @click="logout">Sign Out</b-dropdown-item>
          </b-nav-item-dropdown>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>
  </div>
</template>

<script>
export default {
  name: 'NuxtNavbar',
  methods: {
    logout() {
      this.$auth.logout().then(() => {
        this.$auth.$storage.removeState('access-token')
        this.$auth.$storage.removeState('client')
        this.$auth.$storage.removeState('uid')
        this.$auth.$storage.removeState('token-type')
      })
    },
  },
}
</script>