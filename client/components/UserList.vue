<template>
  <div>
    <b-form-input class ="mb-2" placeholder="Search for a user" @input="onSearch" />
    <b-list-group>
      <b-list-group-item
        v-for="user in users"
        :key="user.id"
        class="d-flex align-items-center"
        :class="{ 'bg-info': isSelectedUser(user.id) }"
        @click="selectUser(user.id)"
      >
        <b-avatar class="mr-3" :src="user.attributes.image"></b-avatar>
        <span class="mr-auto">
          {{ user.attributes.name }} {{ user.attributes.nickname }}
        </span>
      </b-list-group-item>
    </b-list-group>
  </div>
</template>

<script>
import { mapState, mapActions, mapGetters } from 'vuex'

export default {
  name: 'UserList',
  
  data() {
    return {
      query: '',
      debounce: null,
    }
  },
  
  computed: {
    ...mapState(['users', 'selectedConversation']),
    ...mapGetters(['isSelectedUser']),
  },
  
  async mounted() {
    await this.search()
  },
  
  methods: {
    ...mapActions(['getUsers', 'selectConversation']),
    
    onSearch(query) {
      clearTimeout(this.debounce)

      this.debounce = setTimeout(async () => {
        await this.search(query)
      }, 600)
    },
    
    async search(query = null) {
      await this.getUsers(query)
    },

    async selectUser(userId) {
      await this.selectConversation(userId)

      if (this.selectedConversation) {
        this.$cable.unsubscribe('ConversationChannel')
      }

      this.$cable.subscribe({
        channel: 'ConversationChannel',
        conversation_id: this.selectedConversation.id,
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