<template>
  <div class="warnings-container">
    <!-- 搜索和筛选区 -->
    <el-card class="filter-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="预警时间">
          <el-date-picker
            v-model="searchForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            :shortcuts="dateShortcuts"
            style="width: 240px"
          />
        </el-form-item>
        <el-form-item label="预警类型">
          <el-select 
            v-model="searchForm.warningType" 
            placeholder="选择预警类型" 
            clearable
            style="width: 160px"
          >
            <el-option label="成绩预警" value="GRADE" />
            <el-option label="考勤预警" value="ATTENDANCE" />
            <el-option label="行为预警" value="BEHAVIOR" />
          </el-select>
        </el-form-item>
        <el-form-item label="预警等级">
          <el-select 
            v-model="searchForm.level" 
            placeholder="选择预警等级" 
            clearable
            style="width: 160px"
          >
            <el-option label="一级预警" value="1" />
            <el-option label="二级预警" value="2" />
            <el-option label="三级预警" value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="处理状态">
          <el-select 
            v-model="searchForm.status" 
            placeholder="选择状态" 
            clearable
            style="width: 160px"
          >
            <el-option label="待处理" value="PENDING" />
            <el-option label="处理中" value="PROCESSING" />
            <el-option label="已处理" value="PROCESSED" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>查询
          </el-button>
          <el-button @click="resetSearch">
            <el-icon><Refresh /></el-icon>重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 预警列表 -->
    <el-card class="warning-list">
      <template #header>
        <div class="card-header">
          <span class="title">预警列表</span>
          <div class="actions">
            <el-button type="success" @click="handleCreateWarning">
              <el-icon><Plus /></el-icon>新建预警
            </el-button>
          </div>
        </div>
      </template>

      <el-table
        v-loading="loading"
        :data="warningList"
        style="width: 100%"
      >
        <el-table-column prop="warningId" label="预警编号" width="120" />
        <el-table-column prop="studentName" label="学生姓名" width="100" />
        <el-table-column prop="warningType" label="预警类型" width="100">
          <template #default="{ row }">
            <el-tag :type="getWarningTypeTag(row.warningType)">
              {{ getWarningTypeLabel(row.warningType) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="level" label="预警等级" width="100">
          <template #default="{ row }">
            <el-tag :type="getWarningLevelTag(row.warningLevel)" effect="dark">
              {{ `${row.warningLevel}级预警` }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="预警时间" width="160" />
        <el-table-column prop="description" label="预警描述" show-overflow-tooltip />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusTag(row.status)">
              {{ getStatusLabel(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button-group>
              <el-button 
                type="primary" 
                size="small"
                @click="handleProcess(row)"
                :disabled="row.status === 'processed'"
              >
                处理
              </el-button>
              <el-button type="info" size="small" @click="handleDetail(row)">
                详情
              </el-button>
            </el-button-group>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-container">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 预警处理对话框 -->
    <el-dialog
      v-model="processDialogVisible"
      title="预警处理"
      width="600px"
    >
      <el-form
        ref="processFormRef"
        :model="processForm"
        :rules="processRules"
        label-width="100px"
      >
        <el-form-item label="处理方式" prop="processType">
          <el-radio-group v-model="processForm.processType">
            <el-radio label="counsel">辅导帮扶</el-radio>
            <el-radio label="notice">通知家长</el-radio>
            <el-radio label="other">其他方式</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="处理说明" prop="description">
          <el-input
            v-model="processForm.description"
            type="textarea"
            rows="4"
            placeholder="请输入处理说明"
          />
        </el-form-item>
        <el-form-item label="附件">
          <el-upload
            action="#"
            :auto-upload="false"
            :on-change="handleFileChange"
            :before-upload="() => false"
          >
            <el-button type="primary">
              <el-icon><Upload /></el-icon>上传附件
            </el-button>
            <template #tip>
              <div class="el-upload__tip">
                支持 jpg/png/pdf 文件，单个文件不超过 10MB
              </div>
            </template>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="processDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitProcess">确定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 新建预警对话框 -->
    <el-dialog
      v-model="createDialogVisible"
      title="新建预警"
      width="600px"
    >
      <el-form
        ref="warningFormRef"
        :model="warningForm"
        :rules="warningRules"
        label-width="100px"
      >
        <el-form-item label="学生" prop="studentId">
          <el-select
            v-model="warningForm.studentId"
            filterable
            remote
            placeholder="请输入学号或姓名搜索"
            :remote-method="handleStudentSearch"
            :loading="studentSearchLoading"
            @change="handleStudentChange"
          >
            <el-option
              v-for="item in studentOptions"
              :key="item.studentId"
              :label="item.label"
              :value="item.studentId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="预警类型" prop="warningType">
          <el-select v-model="warningForm.warningType" placeholder="请选择预警类型">
            <el-option label="成绩预警" value="GRADE" />
            <el-option label="考勤预警" value="ATTENDANCE" />
            <el-option label="行为预警" value="BEHAVIOR" />
          </el-select>
        </el-form-item>
        <el-form-item label="预警等级" prop="warningLevel">
          <el-radio-group v-model="warningForm.warningLevel">
            <el-radio label="1">一级预警</el-radio>
            <el-radio label="2">二级预警</el-radio>
            <el-radio label="3">三级预警</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="预警描述" prop="description">
          <el-input
            v-model="warningForm.description"
            type="textarea"
            rows="4"
            placeholder="请详细描述预警原因"
          />
        </el-form-item>
        <el-form-item label="相关附件">
          <el-upload
            action="#"
            :auto-upload="false"
            :on-change="handleWarningFileChange"
            :before-upload="() => false"
            multiple
          >
            <el-button type="primary">
              <el-icon><Upload /></el-icon>上传附件
            </el-button>
            <template #tip>
              <div class="el-upload__tip">
                支持 jpg/png/pdf 文件，单个文件不超过 10MB
              </div>
            </template>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="createDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitWarning">确定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog
      v-model="detailDialogVisible"
      title="预警详情"
      width="800px"
    >
      <el-descriptions :column="2" border>
        <el-descriptions-item label="预警编号">{{ detailData.warningId }}</el-descriptions-item>
        <el-descriptions-item label="学生姓名">{{ detailData.studentName }}</el-descriptions-item>
        <el-descriptions-item label="预警类型">
          <el-tag :type="getWarningTypeTag(detailData.warningType)">
            {{ getWarningTypeLabel(detailData.warningType) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="预警等级">
          <el-tag :type="getWarningLevelTag(detailData.warningLevel)" effect="dark">
            {{ `${detailData.warningLevel}级预警` }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="预警时间">{{ detailData.createTime }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="getStatusTag(detailData.status)">
            {{ getStatusLabel(detailData.status) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="预警描述" :span="2">{{ detailData.description }}</el-descriptions-item>
      </el-descriptions>

      <!-- 处理记录列表 -->
      <div class="process-records" v-if="processRecords.length">
        <h3>处理记录</h3>
        <el-timeline>
          <el-timeline-item
            v-for="record in processRecords"
            :key="record.id"
            :timestamp="record.processTime"
          >
            <h4>{{ getProcessTypeLabel(record.processType) }}</h4>
            <p>{{ record.description }}</p>
          </el-timeline-item>
        </el-timeline>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { 
  Search, 
  Refresh, 
  Plus, 
  SetUp, 
  Upload 
} from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { warningApi, attachmentApi, userApi } from '../api'

// 日期快捷选项
const dateShortcuts = [
  {
    text: '最近一周',
    value: () => {
      const end = new Date()
      const start = new Date()
      start.setTime(start.getTime() - 3600 * 1000 * 24 * 7)
      return [start, end]
    },
  },
  {
    text: '最近一月',
    value: () => {
      const end = new Date()
      const start = new Date()
      start.setTime(start.getTime() - 3600 * 1000 * 24 * 30)
      return [start, end]
    },
  }
]

// 搜索表单
const searchForm = reactive({
  dateRange: [],
  warningType: '',
  level: '',
  status: ''
})

// 表格数据
const loading = ref(false)
const warningList = ref([
  {
    warningId: 'W202401001',
    studentName: '张三',
    warningType: 'GRADE',
    warningLevel: '1',
    createTime: '2024-01-15 10:30:00',
    description: '期末考试总评成绩不及格科目超过2门',
    status: 'PENDING'
  },
  {
    warningId: 'W202401002',
    studentName: '李四',
    warningType: 'ATTENDANCE',
    warningLevel: '2',
    createTime: '2024-01-16 09:15:00',
    description: '本月旷课3次',
    status: 'PROCESSING'
  },
  {
    warningId: 'W202401003',
    studentName: '王五',
    warningType: 'BEHAVIOR',
    warningLevel: '3',
    createTime: '2024-01-17 14:20:00',
    description: '多次违反课堂纪律',
    status: 'PROCESSED'
  }
])

// 分页
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(100)

// 处理对话框
const processDialogVisible = ref(false)
const processFormRef = ref(null)
const processForm = reactive({
  warningId: '',
  processType: 'counsel',
  description: '',
  attachments: []
})

// 处理验证规则
const processRules = {
  processType: [
    { required: true, message: '请选择处理方式', trigger: 'change' }
  ],
  description: [
    { required: true, message: '请输入处理说明', trigger: 'blur' },
    { min: 10, message: '处理说明不能少于10个字符', trigger: 'blur' }
  ]
}

// 新建预警相关的状态
const createDialogVisible = ref(false)
const warningFormRef = ref(null)
const warningForm = reactive({
  studentId: '',
  studentName: '',
  warningType: '',
  warningLevel: '1',
  description: '',
  attachments: []
})

// 学生搜索相关
const studentSearchLoading = ref(false)
const studentOptions = ref([
  // 模拟数据
  { id: 1, name: '张三', studentId: '2021001' },
  { id: 2, name: '李四', studentId: '2021002' },
  { id: 3, name: '王五', studentId: '2021003' }
])

// 表单验证规则
const warningRules = {
  studentId: [
    { required: true, message: '请选择学生', trigger: 'change' }
  ],
  warningType: [
    { required: true, message: '请选择预警类型', trigger: 'change' }
  ],
  warningLevel: [
    { required: true, message: '请选择预警等级', trigger: 'change' }
  ],
  description: [
    { required: true, message: '请输入预警描述', trigger: 'blur' },
    { min: 10, message: '预警描述不能少于10个字符', trigger: 'blur' }
  ]
}

// 工具方法
const getWarningTypeTag = (type) => {
  const map = {
    'GRADE': 'danger',
    'ATTENDANCE': 'warning',
    'BEHAVIOR': 'info'
  }
  return map[type] || 'info'
}

const getWarningTypeLabel = (type) => {
  const map = {
    'GRADE': '成绩预警',
    'ATTENDANCE': '考勤预警',
    'BEHAVIOR': '行为预警'
  }
  return map[type] || '其他预警'
}

const getWarningLevelTag = (level) => {
  const map = {
    '1': 'danger',
    '2': 'warning',
    '3': 'info'
  }
  return map[level] || 'info'
}

const getStatusTag = (status) => {
  const map = {
    'PENDING': 'danger',
    'PROCESSING': 'warning',
    'PROCESSED': 'success'
  }
  return map[status] || 'info'
}

const getStatusLabel = (status) => {
  const map = {
    'PENDING': '待处理',
    'PROCESSING': '处理中',
    'PROCESSED': '已处理'
  }
  return map[status] || '未知'
}

// 方法
const handleSearch = () => {
  currentPage.value = 1  // 搜索时重置页码
  getWarningList()
}

const resetSearch = () => {
  searchForm.dateRange = []
  searchForm.warningType = ''
  searchForm.level = ''
  searchForm.status = ''
  getWarningList()
}

const handleCreateWarning = () => {
  createDialogVisible.value = true
  // 重置表单
  if (warningFormRef.value) {
    warningFormRef.value.resetFields()
  }
  warningForm.files = []
}

const handleProcess = (row) => {
  processDialogVisible.value = true
  // 设置当前处理的预警ID
  processForm.warningId = row.warningId
  // 重置表单
  processForm.processType = 'counsel'
  processForm.description = ''
  processForm.attachments = []
}

const handleDetail = async (row) => {
  try {
    // 获取处理记录
    const records = await warningApi.getProcessList(row.warningId)
    processRecords.value = records
    // 设置详情数据
    detailData.value = row
    // 显示对话框
    detailDialogVisible.value = true
  } catch (error) {
    console.error('获取预警详情失败:', error)
    ElMessage.error('获取预警详情失败')
  }
}

const handleSizeChange = (val) => {
  pageSize.value = val
  getWarningList()
}

const handleCurrentChange = (val) => {
  currentPage.value = val
  getWarningList()
}

const handleFileChange = async (file) => {
  try {
    const res = await attachmentApi.upload(file.raw)
    processForm.attachments = processForm.attachments || []
    processForm.attachments.push(res)
    ElMessage.success('文件上传成功')
  } catch (error) {
    ElMessage.error('文件上传失败')
    console.error('文件上传失败:', error)
  }
}

const handleWarningFileChange = async (file) => {
  try {
    const res = await attachmentApi.upload(file.raw)
    warningForm.attachments = warningForm.attachments || []
    warningForm.attachments.push(res)
    ElMessage.success('文件上传成功')
  } catch (error) {
    ElMessage.error('文件上传失败')
    console.error('文件上传失败:', error)
  }
}

const submitProcess = async () => {
  if (!processFormRef.value) return
  await processFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        const processData = {
          warningId: processForm.warningId,
          processType: processForm.processType,
          description: processForm.description,
          attachments: processForm.attachments
        }
        await warningApi.process(processData)
        ElMessage.success('处理成功')
        processDialogVisible.value = false
        getWarningList()
      } catch (error) {
        console.error('处理预警失败:', error)
        ElMessage.error(error.message || '处理预警失败')
      }
    }
  })
}

const handleStudentSearch = async (query) => {
  if (query) {
    studentSearchLoading.value = true
    try {
      // 调用后端API获取学生列表
      const res = await userApi.getList({ keyword: query })
      studentOptions.value = res.map(student => ({
        studentId: student.studentId,
        name: student.name,
        label: `${student.name} (${student.studentId})`
      }))
    } catch (error) {
      console.error('搜索学生失败:', error)
      ElMessage.error('搜索学生失败')
    } finally {
      studentSearchLoading.value = false
    }
  }
}

const handleStudentChange = (value) => {
  const selectedStudent = studentOptions.value.find(item => item.studentId === value)
  if (selectedStudent) {
    warningForm.studentId = selectedStudent.studentId
    warningForm.studentName = selectedStudent.name
  }
}

const submitWarning = async () => {
  if (!warningFormRef.value) return
  await warningFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        const warningData = {
          studentId: warningForm.studentId,
          studentName: warningForm.studentName,
          warningType: warningForm.warningType,
          warningLevel: parseInt(warningForm.warningLevel),
          description: warningForm.description,
          attachments: warningForm.attachments
        }
        await warningApi.create(warningData)
        ElMessage.success('创建成功')
        createDialogVisible.value = false
        getWarningList()
      } catch (error) {
        console.error('创建预警失败:', error)
        ElMessage.error(error.message || '创建预警失败')
      }
    }
  })
}

// 获取预警列表
const getWarningList = async () => {
  loading.value = true
  try {
    const params = {}
    // 只有当有值时才添加到参数中
    if (searchForm.warningType) {
      params.warningType = searchForm.warningType
    }
    if (searchForm.level) {
      params.level = searchForm.level
    }
    if (searchForm.status) {
      params.status = searchForm.status
    }
    if (searchForm.dateRange && searchForm.dateRange.length === 2) {
      params.startTime = searchForm.dateRange[0]
      params.endTime = searchForm.dateRange[1]
    }
    
    const res = await warningApi.getList(params)
    // 前端分页处理
    const start = (currentPage.value - 1) * pageSize.value
    const end = start + pageSize.value
    warningList.value = res.slice(start, end)
    total.value = res.length
  } catch (error) {
    console.error('获取预警列表失败:', error)
    ElMessage.error('获取预警列表失败')
  } finally {
    loading.value = false
  }
}

// 在onMounted中调用
onMounted(() => {
  getWarningList()
})

// 详情对话框相关
const detailDialogVisible = ref(false)
const detailData = ref({})
const processRecords = ref([])

// 处理方式标签
const getProcessTypeLabel = (type) => {
  const map = {
    'counsel': '辅导帮扶',
    'notice': '通知家长',
    'other': '其他方式'
  }
  return map[type] || '未知方式'
}
</script>

<style scoped>
.warnings-container {
  padding: 20px;
}

.filter-card {
  margin-bottom: 20px;
}

.warning-list {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.title {
  font-size: 16px;
  font-weight: bold;
}

.actions {
  display: flex;
  gap: 10px;
}

.search-form {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

:deep(.el-card) {
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,0.05);
}

:deep(.el-table) {
  border-radius: 8px;
  overflow: hidden;
}

@media (max-width: 768px) {
  .search-form {
    flex-direction: column;
  }
  
  .search-form .el-form-item {
    margin-right: 0;
    width: 100%;
  }
  
  .actions {
    flex-direction: column;
    width: 100%;
  }
  
  .actions .el-button {
    width: 100%;
  }
}

.el-upload__tip {
  font-size: 12px;
  color: var(--el-text-color-secondary);
  margin-top: 4px;
}

:deep(.el-select) {
  width: 100%;
}

/* 深色模式样式调整 */
:deep(.dark-mode) {
  /* 卡片样式 */
  .el-card {
    background-color: var(--el-bg-color);
    border-color: var(--el-border-color-light);
    
    .el-card__header {
      border-bottom-color: var(--el-border-color-light);
    }
  }

  /* 表格样式 */
  .el-table {
    --el-table-border-color: var(--el-border-color-light);
    --el-table-header-bg-color: var(--el-bg-color);
    --el-table-row-hover-bg-color: var(--el-bg-color-darker);
    --el-table-tr-bg-color: var(--el-bg-color);
    
    /* 斑马纹样式 */
    tr.el-table__row--striped td {
      background-color: var(--el-bg-color-darker);
    }
    
    /* 表头样式 */
    th.el-table__cell {
      background-color: var(--el-bg-color-darker);
      border-bottom-color: var(--el-border-color-light);
    }
    
    /* 单元格样式 */
    td.el-table__cell {
      border-bottom-color: var(--el-border-color-light);
    }
  }

  /* 表单样式 */
  .el-form-item__label {
    color: var(--el-text-color-primary);
  }

  /* 输入框样式 */
  .el-input__inner {
    background-color: var(--el-bg-color-darker);
    border-color: var(--el-border-color-light);
  }

  /* 选择器样式 */
  .el-select .el-input__wrapper {
    background-color: var(--el-bg-color-darker);
  }

  /* 日期选择器样式 */
  .el-date-editor {
    background-color: var(--el-bg-color-darker);
  }
}

/* 修改变量定义 */
:root {
  --el-bg-color-darker: #141414;
}

.process-records {
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid var(--el-border-color-light);
}

.process-records h3 {
  margin-bottom: 16px;
  font-size: 16px;
  font-weight: bold;
}

:deep(.el-timeline) {
  padding-left: 16px;
}

:deep(.el-timeline-item__content) {
  h4 {
    font-size: 14px;
    margin-bottom: 8px;
  }
  p {
    color: var(--el-text-color-regular);
    margin: 0;
  }
}
</style> 