<template>
  <div class="reports-container">
    <el-row :gutter="20">
      <!-- 趋势图 -->
      <el-col :span="24">
        <el-card class="chart-card">
          <template #header>
            <div class="card-header">
              <span>预警趋势统计</span>
              <el-radio-group v-model="timeRange" size="small" @change="handleTimeRangeChange">
                <el-radio-button label="week">最近一周</el-radio-button>
                <el-radio-button label="month">最近一月</el-radio-button>
                <el-radio-button label="year">最近一年</el-radio-button>
              </el-radio-group>
            </div>
          </template>
          <div ref="trendChart" style="height: 400px"></div>
        </el-card>
      </el-col>

      <!-- 学院分布图 -->
      <el-col :span="12">
        <el-card class="chart-card">
          <template #header>
            <div class="card-header">
              <span>学院预警分布</span>
            </div>
          </template>
          <div ref="collegeChart" style="height: 400px"></div>
        </el-card>
      </el-col>

      <!-- 类型分布图 -->
      <el-col :span="12">
        <el-card class="chart-card">
          <template #header>
            <div class="card-header">
              <span>预警类型分布</span>
            </div>
          </template>
          <div ref="typeChart" style="height: 400px"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import * as echarts from 'echarts'
import { reportApi } from '../api'

const timeRange = ref('month')
const trendChart = ref(null)
const collegeChart = ref(null)
const typeChart = ref(null)

// 初始化趋势图
const initTrendChart = async () => {
  const chart = echarts.init(trendChart.value)
  try {
    const data = await reportApi.getTrendStats({ period: timeRange.value })
    chart.setOption({
      tooltip: {
        trigger: 'axis'
      },
      xAxis: {
        type: 'category',
        data: data.dates
      },
      yAxis: {
        type: 'value'
      },
      series: [{
        data: data.values,
        type: 'line',
        smooth: true,
        areaStyle: {
          opacity: 0.3
        }
      }]
    })
  } catch (error) {
    console.error('获取趋势数据失败:', error)
  }
  return chart
}

// 初始化学院分布图
const initCollegeChart = async () => {
  const chart = echarts.init(collegeChart.value)
  try {
    const data = await reportApi.getCollegeStats()
    chart.setOption({
      tooltip: {
        trigger: 'item',
        formatter: '{b}: {c} ({d}%)'
      },
      legend: {
        orient: 'vertical',
        right: 10,
        top: 'center',
        itemWidth: 10,
        itemHeight: 10,
        textStyle: {
          fontSize: 12
        }
      },
      series: [{
        name: '学院分布',
        type: 'pie',
        radius: ['40%', '70%'],
        center: ['40%', '50%'],
        avoidLabelOverlap: true,
        itemStyle: {
          borderRadius: 10,
          borderColor: '#fff',
          borderWidth: 2
        },
        label: {
          show: false
        },
        labelLine: {
          show: false
        },
        emphasis: {
          label: {
            show: false
          }
        },
        data: data.colleges.map((college, index) => ({
          name: college,
          value: data.values[index]
        }))
      }]
    })
  } catch (error) {
    console.error('获取学院分布数据失败:', error)
    ElMessage.error('获取学院分布数据失败')
  }
  return chart
}

// 初始化类型分布图
const initTypeChart = async () => {
  const chart = echarts.init(typeChart.value)
  try {
    const data = await reportApi.getTypeStats()
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
        data: data.types.map((type, index) => ({
          name: type,
          value: data.values[index]
        }))
      }]
    })
  } catch (error) {
    console.error('获取类型分布数据失败:', error)
  }
  return chart
}

// 处理时间范围变化
const handleTimeRangeChange = () => {
  initTrendChart()
}

// 在组件挂载时初始化
onMounted(async () => {
  const trend = await initTrendChart()
  const college = await initCollegeChart()
  const type = await initTypeChart()

  // 监听窗口大小变化
  window.addEventListener('resize', () => {
    trend.resize()
    college.resize()
    type.resize()
  })
})
</script>

<style scoped>
.reports-container {
  padding: 20px;
}

.chart-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

:deep(.el-card) {
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,0.05);
}
</style> 