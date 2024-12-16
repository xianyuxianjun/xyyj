<template>
  <el-config-provider :locale="zhCn" :size="size" :button-config="buttonConfig">
    <router-view />
  </el-config-provider>
</template>

<script setup>
import { ref } from 'vue'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'

const size = ref('default')
const buttonConfig = { autoInsertSpace: true }
</script>

<style>
html, body {
  margin: 0;
  padding: 0;
  height: 100%;
}
</style>
