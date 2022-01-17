const USERS_ENDPOINT = '/users'
const CONVERSATIONS_ENDPOINT = '/conversations'
const PAGE_SIZE = 20

export const state = () => ({
  users: [],
  conversations: [],
  messages: [],
  selectedConversation: null,
  hasMoreMessages: false,
  currentPage: 1
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
  },
  SET_HAS_MORE_MESSAGES(state, hasMoreMessages) {
    state.hasMoreMessages = hasMoreMessages
  },
  SET_PAGE(state, page) {
    state.currentPage = page
  }
}

export const actions = {
  async getUsers({ commit }, search = null) {
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

  async selectConversation({ commit, state, getters, dispatch }, recipientId) {
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

    commit('SET_PAGE', 1)
    commit('SET_MESSAGES', [])
    await dispatch('getMessages')
  },

  async getMessages({ commit, state }) {
    if (!state.selectedConversation) return

    const url = `${CONVERSATIONS_ENDPOINT}/${state.selectedConversation.id}/messages`
    const params = {
      page_number: state.currentPage,
      page_size: PAGE_SIZE,
    }

    const response = await this.$axios.get(url, { params })
    const newMessages = response.data.data
    
    commit('SET_MESSAGES', [...newMessages.reverse(), ...state.messages])
    commit('SET_HAS_MORE_MESSAGES', newMessages.length > 0)
  },

  appendMessage({ commit, state }, message) {
    commit('SET_MESSAGES', [...state.messages, message])
  },

  incrementPage({ commit, state }) {
    commit('SET_PAGE', state.currentPage + 1)
  }
}

export const getters = {
  isSelectedConversation: (state) => (conversation) => {
    return state.selectedConversation?.id === conversation.id
  },

  isSelectedUser: (state) => (userId) => {
    if (!state.selectedConversation || !state.selectedConversation.users) return false;
    if (state.selectedConversation.users.length === 1) {
      return userId === state.auth.user.id
    }

    return state.selectedConversation.users.some(u => u.id === userId && userId !== state.auth.user.id)
  },

  accessToken: (state) => {
    return state.auth['access-token']
  },

  uid: (state) => {
    return state.auth.uid
  },

  client: (state) => {
    return state.auth.client
  },
}