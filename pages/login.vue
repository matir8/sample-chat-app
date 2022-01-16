<template>
  <b-container>
    <b-col offset-md="1" md="10" class="mt-3">
      <h3 class="text-center">Login</h3>

      <Notification v-if="error" :message="error" class="mb-4 pb-3" />

      <b-form @submit.prevent="login">
        <b-form-group label="Email">
          <b-form-input
            v-model="email"
            placeholder="Enter email"
            required
            type="email"
          ></b-form-input>
        </b-form-group>
        <b-form-group label="Password">
          <b-form-input
            v-model="password"
            placeholder="Enter password"
            required
            type="password"
          ></b-form-input>
        </b-form-group>
        <b-button block type="submit" variant="primary">Login</b-button>
      </b-form>
    </b-col>
  </b-container>
</template>

<script>
export default {
  name: 'LoginPage',
  data() {
    return {
      email: '',
      password: '',
      error: null,
    }
  },
  methods: {
    login() {
       this.$auth
        .loginWith('local', {
          data: {
            password: this.password,
            email: this.email,
          },
        })
        .then(() => {
          this.$router.push({ name: 'index' })
        })
        .catch((error) => {
          this.error = error.response.data.errors
        })
    },
  },
}
</script>

<style></style>