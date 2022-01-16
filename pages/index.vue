<template>
  <b-container fluid>
    <b-row>
      <b-col class="mt-3">
        <b-jumbotron v-if="!$auth.loggedIn" md="6" offset-md="3" class="pb-5">
          <template #header>Sample chat app</template>
          <div >
            <h2>Sign in to start chatting with your friends.</h2>
          </div>
          <hr class="my-4" />
          <b-button v-if="!$auth.loggedIn" variant="primary" to="/signup">
            Sign up
          </b-button>
          <b-button v-if="!$auth.loggedIn" variant="info" to="/login">
            Sign in
          </b-button>
        </b-jumbotron>
        <b-row v-else>
          <b-col lg="4" xl="3" class="d-xl-block d-md-none">
            <user-list />
          </b-col>
          <b-col sm="4" md="4" xl="3">
            <conversation-list />
          </b-col>
          <b-col sm="8" md="8" xl="6">
            <!-- <user-list /> -->
          </b-col>
        </b-row>
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
import ConversationList from '~/components/ConversationList.vue'
import UserList from '~/components/UserList.vue'
export default {
  name: 'IndexPage',
  components: { UserList, ConversationList },
  computed: {
    accessToken() {
      return this.$auth.$storage.getState('access-token')
    },
    client() {
      return this.$auth.$storage.getState('client')
    },
    uid() {
      return this.$auth.$storage.getState("uid")
    }
  },
  mounted() {
    if (this.$auth.loggedIn) {
      this.$cable.connection.connect(
        `${process.env.chatUrl}?access-token=${this.accessToken}&client=${this.client}&uid=${this.uid}`
      )
    }
  }
}
</script>

<style></style>