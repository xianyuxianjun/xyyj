<template>
  <div class="logo-container">
    <div class="icon-wrapper">
      <svg class="book-icon" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
        <path d="M928 832l-64 32-352 160-352-160-64-32a96 96 0 0 1-96-96V96a96 96 0 0 1 96-96l64 32 352 160 352-160 64-32a96 96 0 0 1 96 96v640a96 96 0 0 1-96 96z m-480 0V288L128 192v544l320 128v-32zM896 192L576 288v576l320-128V192z" fill="currentColor"/>
      </svg>
      <svg class="warning-icon" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
        <path d="M991.7 878.9l-448-832C537.4 35.3 525.2 28 512 28s-25.4 7.3-31.7 18.9l-448 832c-6 11.2-5.7 24.6 0.8 35.5C39.6 925.3 51.3 932 64 932h896c12.7 0 24.4-6.7 30.9-17.5 6.5-10.9 6.8-24.4 0.8-35.6zM124.3 860L512 139.9 899.7 860H124.3z" fill="currentColor"/>
        <path d="M476 420v160c0 19.9 16.1 36 36 36s36-16.1 36-36V420c0-19.9-16.1-36-36-36s-36 16.1-36 36z" fill="currentColor"/>
        <path d="M512 724m-36 0a36 36 0 1 0 72 0 36 36 0 1 0-72 0Z" fill="currentColor"/>
      </svg>
    </div>
    <span class="logo-text">学生预警系统</span>
  </div>
</template>

<script setup>
// 无需额外的脚本
</script>

<style scoped>
.logo-container {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px;
  cursor: pointer;
  transition: all 0.3s;
}

.logo-container:hover {
  opacity: 0.8;
}

.icon-wrapper {
  position: relative;
  width: 32px;
  height: 32px;
}

.book-icon {
  position: absolute;
  width: 32px;
  height: 32px;
  color: #409EFF;
  transition: transform 0.3s;
}

.logo-container:hover .book-icon {
  transform: scale(1.1);
}

.warning-icon {
  position: absolute;
  top: -8px;
  right: -8px;
  width: 16px;
  height: 16px;
  color: #F56C6C;
  animation: pulse 2s infinite;
}

.logo-text {
  font-size: 18px;
  font-weight: bold;
  color: #409EFF;
  font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", 
    "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
  white-space: nowrap;
}

@keyframes pulse {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
  100% {
    transform: scale(1);
  }
}

:deep(.dark) {
  .book-icon {
    color: #79bbff;
  }
  
  .warning-icon {
    color: #f89898;
  }
  
  .logo-text {
    color: #79bbff;
  }
}
</style> 