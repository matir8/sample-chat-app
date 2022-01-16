const USERS_ENDPOINT = '/users'
const CONVERSATIONS_ENDPOINT = '/conversations'

export const state = () => ({
  users: [],
  conversations: [],
  messages: [],
  selectedConversation: {}
})

export const mutations = {
  SET_USERS(state, users) {
    state.users = users
  },
  SET_CONVERSATIONS(state, conversations) {
    state.conversations = conversations
  },
  SET_SELECTED_CONVERSATION(state, conversation) {
    state.selectedConversation = conversation
  },
  SET_MESSAGES(state, messages) {
    state.messages = messages
  }
}

export const actions = {
  async getUsers({ commit } , search = null) {
    const params = search ? { search } : {}
    const response = await this.$axios.get(USERS_ENDPOINT, { params })

    commit('SET_USERS', response?.data?.data)
  },

  async getConversations({ commit }) {
    const response = await this.$axios.get(CONVERSATIONS_ENDPOINT)
    const conversations = response.data.data.map(x => {
      const includedUserIds = x.relationships.users.data.map(u => u.id) 
      return {
        id: x.id,
        users: response.data.included.filter(u => includedUserIds.includes(u.id))
      }
    })
    
    commit('SET_CONVERSATIONS', conversations)
  },

  async selectConversation({ commit, state, getters }, recipientId) {
    if (getters.isSelectedUser(recipientId)) return

    const params = { recipient_id: recipientId }
    const response = await this.$axios.post(CONVERSATIONS_ENDPOINT, {}, { params })

    const conversation = {
      id: response.data.data.id,
      users: response.data.included
    }

    commit('SET_SELECTED_CONVERSATION', conversation)

    if (!state.conversations.some(c => c.id === conversation.id)) {
      commit('SET_CONVERSATIONS', [...state.conversations, conversation])
    }
  }
}

export const getters = {
  isSelectedConversation: (state) => (conversation) => {
    return state.selectedConversation?.id === conversation.id
  },
  isSelectedUser: (state) => (userId) => {
    if (!state.selectedConversation?.users) return false;

    return state.selectedConversation.users.some(u => u.id === userId)
  }
}