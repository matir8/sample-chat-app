<template>
  <div>
    <Navbar style="max-height: 5vh"/>
    <Nuxt style="height: 95vh"/>
  </div>
</template>

<script>
import Navbar from '~/components/Navbar'

export default {
  name: 'DefaultLayout',
  components: {
    Navbar
  }
}
</script>
