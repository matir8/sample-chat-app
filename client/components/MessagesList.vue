<template>
  <b-container>
    <b-row id="chat-box" @scroll="loadMessages">
      <b-container>
        <b-row
          v-for="message in messages"
          :key="message.id"
          :align-h="align(message)"
          no-gutters
        >
          <b-col md="10">
            <b-alert show :variant="variant(message)" class="mb-2">
              <span class="mr-auto">
                {{ message.attributes.content }}
              </span>
            </b-alert>
            <div class="small font-italic mb-2">
              <span>{{ new Date(message.attributes.created_at) }}</span>
            </div>
          </b-col>
        </b-row>
      </b-container>
    </b-row>
    <b-row no-gutters>
      <b-form class="w-100" autocomplete="off" @submit="sendMessage">
        <b-form-input v-model="content" placeholder="Enter a message" />
      </b-form>
    </b-row>
  </b-container>
</template>

<script>
import { mapState, mapActions } from 'vuex'

export default {
  name: 'MessagesList',

  data() {
    return {
      content: '',
    }
  },

  channels: {
    ConversationChannel: {
      async received({ data }) {
        const container = this.$el.querySelector('#chat-box')
        const scrolledToBottom = container.scrollHeight - container.scrollTop - container.clientHeight < 1
        
        await this.appendMessage(data)

        if (this.isAuthorMessage(data) || scrolledToBottom) {
          this.scrollToBottom()
        }
      },
    },
  },

  computed: {
    ...mapState(['messages', 'hasMoreMessages', 'currentPage']),
  },

  async mounted() {
    await this.getMessages()
  },

  updated() {
    const container = this.$el.querySelector('#chat-box')

    if (container.scrollTop === 0 && this.currentPage === 1) {
      this.scrollToBottom()
    }
  },
  methods: {
    ...mapActions(['getMessages', 'appendMessage', 'incrementPage']),

    isAuthorMessage(message) {
      return message.relationships.user.data.id === this.$auth.user.id
    },

    align(message) {
      return this.isAuthorMessage(message) ? 'end' : 'start'
    },

    variant(messsage) {
      return this.isAuthorMessage(messsage) ? 'primary' : 'secondary'
    },

    sendMessage(event) {
      event.preventDefault()

      if (!this.content.trim()) return

      this.$cable.perform({
        channel: 'ConversationChannel',
        action: 'send_message',
        data: {
          message: this.content.trim(),
        },
      })

      this.content = ''
    },

    async loadMessages() {
      const container = this.$el.querySelector('#chat-box')
      const height = container.scrollHeight

      if (container.scrollTop === 0 && this.hasMoreMessages) {
        await this.incrementPage()
        await this.getMessages()

        container.scrollTop = container.scrollHeight - height
      }
    },

    scrollToBottom() {
      const container = this.$el.querySelector('#chat-box')

      container.scrollTop = container.scrollHeight
    },
  },
}
</script>

<style scoped>
#chat-box {
  height: 70vh;
  overflow-x: hidden;
  overflow-y: scroll;
  margin-bottom: 10px;
}
</style>