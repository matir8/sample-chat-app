<template>
  <b-alert show variant="danger">
    <div v-for="m in messages" :key="m.id">
      <span>{{ m }}</span>
    </div>
  </b-alert>
</template>

<script>
export default {
  name: 'NuxtNotification',
  props: {
    messages: {
      type: Array,
      required: true,
    },
  }
}
</script>