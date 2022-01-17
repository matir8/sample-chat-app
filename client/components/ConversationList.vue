<template>
  <div>
    <b-list-group>
      <b-list-group-item
        v-for="conversation in conversations"
        :key="conversation.id"
        class="d-flex align-items-center"
        :class="{ 'bg-info': isSelectedConversation(conversation) }"
        @click="select(conversation)"
      >
        <span class="mr-auto">
          {{ getName(conversation) }} {{ getNickname(conversation) }}
        </span>
      </b-list-group-item>
    </b-list-group>
  </div>
</template>

<script>
import { mapState, mapActions, mapGetters } from 'vuex'

export default {
  name: 'ConversationsList',
  data() {
    return {
      query: '',
      debounce: null,
    }
  },
  computed: {
    ...mapState(['conversations', 'selectedConversation']),
    ...mapGetters(['isSelectedConversation']),
  },
  async mounted() {
    await this.getConversations()
  },
  methods: {
    ...mapActions(['getConversations', 'selectConversation']),
    getUser(conversation) {
      return (
        conversation.users.find((u) => u.id !== this.$auth.user.id) ||
        this.$auth.user
      )
    },
    getName(conversation) {
      return this.getUser(conversation).attributes.name
    },
    getNickname(conversation) {
      return this.getUser(conversation).attributes.nickname
    },
    async select(conversation) {
      await this.selectConversation(this.getUser(conversation).id)

      if (this.selectedConversation) {
        this.$cable.unsubscribe("ConversationChannel");
      }
      
      this.$cable.subscribe({
        channel: "ConversationChannel",
        conversation_id: conversation.id,
      })
    },
  },
}
</script>

<style scoped>
  .list-group-item:hover {
    cursor: pointer;
    background-color: #D4D4D4;
  }
</style>