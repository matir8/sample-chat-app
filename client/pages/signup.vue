<template>
  <b-container>
    <b-col offset-md="1" md="10" class="mt-3">
      <h3 class="text-center">Sign up</h3>

      <Notification v-if="errors" :messages="errors" class="mb-4 pb-3" />

      <b-form @submit.prevent="signup">
        <b-form-group label="Name">
          <b-form-input
            v-model="name"
            placeholder="Enter your name"
            required
            type="text"
          ></b-form-input>
        </b-form-group>
        <b-form-group label="Username">
          <b-form-input
            v-model="nickname"
            placeholder="Enter your username"
            required
            type="text"
          ></b-form-input>
        </b-form-group>
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
        <b-form-group label="Confirm password:">
          <b-form-input
            v-model="password_confirmation"
            placeholder="Password confirmation"
            required
            type="password"
          ></b-form-input>
        </b-form-group>
        <b-form-group label="Link to profile image (optional)">
          <b-form-input
            v-model="image"
            placeholder="Profile picture URL"
            type="text"
          ></b-form-input>
        </b-form-group>
        <b-button block type="submit" variant="primary">Submit</b-button>
      </b-form>
    </b-col>
  </b-container>
</template>

<script>
import Notification from '~/components/Notification'

export default {
  name: 'SignUpPage',
  components: {
    Notification
  },
  data() {
    return {
      name: '',
      nickname: '',
      image: '',
      email: '',
      password: '',
      password_confirmation: '',
      errors: null,
    }
  },
  methods: {
    async signup() {
      try {
        await this.$axios.post('/auth', {
          name: this.name,
          nickname: this.nickname,
          image: this.image,
          email: this.email,
          password: this.password,
          password_confirmation: this.password_confirmation,
        })
        await this.$auth.loginWith('local', {
          data: {
            password: this.password,
            email: this.email,
          },
        })
      } catch (e) {
        this.errors = e.response.data.errors.full_messages
      }
    },
  },
}
</script>

<style></style>