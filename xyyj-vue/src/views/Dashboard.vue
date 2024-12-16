<template>
  <div class="dashboard-container">
    <!-- 数据概览卡片 -->
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="statistic-item">
            <div class="title">总学生数</div>
            <div class="number">{{ overviewData.totalStudents }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="statistic-item">
            <div class="title">预警学生数</div>
            <div class="number warning">{{ overviewData.warningStudents }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="statistic-item">
            <div class="title">本月新增预警</div>
            <div class="number danger">{{ overviewData.newWarnings }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="statistic-item">
            <div class="title">待处理预警</div>
            <div class="number primary">{{ overviewData.pendingWarnings }}</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 图表部分 -->
    <div class="charts-section">
      <el-row :gutter="20">
        <el-col :xs="24" :lg="16">
          <el-card class="chart-card">
            <template #header>
              <div class="card-header">
                <span>预警趋势分析</span>
                <el-radio-group v-model="timeRange" size="small">
                  <el-radio-button label="week">本周</el-radio-button>
                  <el-radio-button label="month">本月</el-radio-button>
                  <el-radio-button label="year">全年</el-radio-button>
                </el-radio-group>
              </div>
            </template>
            <div class="chart-container">
              <div ref="trendChart" style="height: 300px"></div>
            </div>
          </el-card>
        </el-col>
        <el-col :xs="24" :lg="8">
          <el-card class="chart-card">
            <template #header>
              <div class="card-header">
                <span>预警类型分布</span>
              </div>
            </template>
            <div class="chart-container">
              <div ref="pieChart" style="height: 300px"></div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import * as echarts from 'echarts'
import { statisticsApi } from '../api'

// 数据概览
const overviewData = ref({
  totalStudents: 0,
  warningStudents: 0,
  newWarnings: 0,
  pendingWarnings: 0
})

// 图表相关
const timeRange = ref('month')
const trendChart = ref(null)
const pieChart = ref(null)

// 获取概览数据
const getOverviewData = async () => {
  try {
    const data = await statisticsApi.getOverview()
    overviewData.value = data
  } catch (error) {
    console.error('获取概览数据失败:', error)
  }
}

// 初始化趋势图
const initTrendChart = () => {
  const chart = echarts.init(trendChart.value)
  chart.setOption({
    tooltip: {
      trigger: 'axis'
    },
    xAxis: {
      type: 'category',
      data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
    },
    yAxis: {
      type: 'value'
    },
    series: [{
      data: [12, 15, 8, 23, 18, 10, 14],
      type: 'line',
      smooth: true,
      areaStyle: {
        opacity: 0.3
      }
    }]
  })
  return chart
}

// 初始化饼图
const initPieChart = () => {
  const chart = echarts.init(pieChart.value)
  chart.setOption({
    tooltip: {
      trigger: 'item'
    },
    legend: {
      orient: 'vertical',
      right: 10,
      top: 'center'
    },
    series: [{
      type: 'pie',
      radius: ['40%', '70%'],
      avoidLabelOverlap: false,
      itemStyle: {
        borderRadius: 10,
        borderColor: '#fff',
        borderWidth: 2
      },
      label: {
        show: false
      },
      data: [
        { value: 45, name: '成绩预警' },
        { value: 25, name: '考勤预警' },
        { value: 20, name: '行为预警' },
        { value: 10, name: '其他预警' }
      ]
    }]
  })
  return chart
}

// 在组件挂载时初始化
onMounted(() => {
  getOverviewData()
  
  // 初始化图表
  const trend = initTrendChart()
  const pie = initPieChart()

  // 监听窗口大小变化
  window.addEventListener('resize', () => {
    trend.resize()
    pie.resize()
  })
})
</script>

<style scoped>
.dashboard-container {
  padding: 20px;
}

.statistic-item {
  text-align: center;
}

.title {
  font-size: 14px;
  color: var(--el-text-color-secondary);
  margin-bottom: 8px;
}

.number {
  font-size: 28px;
  font-weight: bold;
}

.warning {
  color: #e6a23c;
}

.danger {
  color: #f56c6c;
}

.primary {
  color: #409eff;
}

/* 图表相关样式 */
.charts-section {
  margin-top: 20px;
}

.chart-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chart-container {
  padding: 10px;
}

:deep(.el-card) {
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,0.05);
}
</style> 