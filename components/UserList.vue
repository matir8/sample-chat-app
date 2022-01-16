<template>
  <div>
    <b-form-input placeholder="Search for a user" @input="onSearch" />
    <b-list-group>
      <b-list-group-item
        v-for="user in users"
        :key="user.id"
        class="d-flex align-items-center"
        :class="{ 'bg-secondary': isSelectedUser(user.id) }"
        @click="selectConversation(user.id)"
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
    ...mapState(['users']),
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
  },
}
</script>