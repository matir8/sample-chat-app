<template>
  <b-container id="root" fluid>
    <b-row>
      <b-col class="mt-3">
        <b-jumbotron v-if="!$auth.loggedIn" md="6" offset-md="3" class="pb-5">
          <template #header>Sample chat app</template>
          <div >
            <h2>Log in to start chatting with your friends.</h2>
          </div>
          <hr class="my-4" />
          <b-button v-if="!$auth.loggedIn" variant="primary" to="/signup">
            Sign up
          </b-button>
          <b-button v-if="!$auth.loggedIn" variant="info" to="/login">
            Log in
          </b-button>
        </b-jumbotron>
        <b-row v-else>
          <b-col sm="12" md="3" xl="3">
            <h4>Users</h4>
            <user-list />
          </b-col>
          <b-col md="3" xl="3" class="d-sm-none d-md-block">
            <h4>Conversations</h4>
            <conversation-list />
          </b-col>
          <b-col sm="12" md="6" xl="6" >
            <h4>Messages</h4>
            <messages-list />
          </b-col>
        </b-row>
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
import { mapGetters } from 'vuex'
import ConversationList from '~/components/ConversationList.vue'
import MessagesList from '~/components/MessagesList.vue'
import UserList from '~/components/UserList.vue'

export default {
  name: 'IndexPage',
  components: { UserList, ConversationList, MessagesList },
  computed: {
    ...mapGetters(['accessToken', 'client', 'uid'])
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
