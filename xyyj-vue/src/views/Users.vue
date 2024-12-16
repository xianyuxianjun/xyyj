<template>
  <div class="users-container">
    <!-- 搜索和操作栏 -->
    <div class="action-bar">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item>
          <el-input
            v-model="searchForm.keyword"
            placeholder="搜索学号/姓名"
            clearable
            @keyup.enter="handleSearch"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-select 
            v-model="searchForm.college" 
            placeholder="选择学院" 
            clearable
            style="width: 160px;"
          >
            <el-option label="计算机学院" value="计算机学院" />
            <el-option label="机械工程学院" value="机械工程学院" />
            <el-option label="经济管理学院" value="经济管理学院" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>搜索
          </el-button>
        </el-form-item>
      </el-form>
      
      <div class="action-buttons">
        <el-button type="success" @click="handleAdd">
          <el-icon><Plus /></el-icon>添加用户
        </el-button>
        <el-button type="primary" @click="handleImport">
          <el-icon><Upload /></el-icon>批量导入
        </el-button>
        <el-button type="warning" @click="handleExport">
          <el-icon><Download /></el-icon>导出数据
        </el-button>
      </div>
    </div>

    <!-- 用户列表 -->
    <el-table
      v-loading="loading"
      :data="userList"
      style="width: 100%"
      border
      stripe
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" />
      <el-table-column prop="studentId" label="学号" width="120" />
      <el-table-column prop="name" label="姓名" width="100" />
      <el-table-column prop="gender" label="性别" width="80">
        <template #default="{ row }">
          <el-tag :type="row.gender === 'M' ? 'primary' : 'success'" size="small">
            {{ row.gender === 'M' ? '男' : '女' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="college" label="学院" />
      <el-table-column prop="major" label="专业" />
      <el-table-column prop="className" label="班级" width="100" />
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="getStatusType(row.status)" size="small">
            {{ getStatusLabel(row.status) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row }">
          <el-button-group>
            <el-button type="primary" size="small" @click="handleEdit(row)">
              <el-icon><Edit /></el-icon>编辑
            </el-button>
            <el-button type="danger" size="small" @click="handleDelete(row)">
              <el-icon><Delete /></el-icon>删除
            </el-button>
          </el-button-group>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
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

    <!-- 用户表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '添加用户' : '编辑用户'"
      width="500px"
    >
      <el-form
        ref="userFormRef"
        :model="userForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="学号" prop="studentId">
          <el-input v-model="userForm.studentId" />
        </el-form-item>
        <el-form-item label="姓名" prop="name">
          <el-input v-model="userForm.name" />
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="userForm.gender">
            <el-radio label="M">男</el-radio>
            <el-radio label="F">女</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="学院" prop="college">
          <el-select v-model="userForm.college" placeholder="请选择学院">
            <el-option label="计算机学院" value="计算机学院" />
            <el-option label="机械工程学院" value="机械工程学院" />
            <el-option label="经济管理学院" value="经济管理学院" />
          </el-select>
        </el-form-item>
        <el-form-item label="专业" prop="major">
          <el-input v-model="userForm.major" />
        </el-form-item>
        <el-form-item label="班级" prop="className">
          <el-input v-model="userForm.className" />
        </el-form-item>
        <el-form-item label="入学年份" prop="admissionYear">
          <el-input-number v-model="userForm.admissionYear" :min="2000" :max="2100" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmit">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { Search, Plus, Upload, Download, Edit, Delete } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { userApi } from '../api'

// 搜索表单
const searchForm = reactive({
  keyword: '',
  college: ''
})

// 表格数据
const loading = ref(false)
const userList = ref([
  {
    id: 1,
    studentId: '2021001',
    name: '张三',
    gender: 'M',
    college: '计算机学院',
    major: '软件工程',
    className: '软工2101',
    status: 'NORMAL'
  },
  {
    id: 2,
    studentId: '2021002',
    name: '李四',
    gender: 'F',
    college: '计算机学院',
    major: '软件工程',
    className: '软工2101',
    status: 'NORMAL'
  }
])

// 分页
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(100)

// 对话框
const dialogVisible = ref(false)
const dialogType = ref('add')
const userFormRef = ref(null)
const userForm = reactive({
  studentId: '',
  name: '',
  gender: 'M',
  college: '',
  major: '',
  className: '',
  admissionYear: new Date().getFullYear(),
  status: 'NORMAL'
})

// 表单验证规则
const rules = {
  studentId: [
    { required: true, message: '请输入学号', trigger: 'blur' },
    { pattern: /^\d{7}$/, message: '学号必须为7位数字', trigger: 'blur' }
  ],
  name: [
    { required: true, message: '请输入姓名', trigger: 'blur' }
  ],
  college: [
    { required: true, message: '请选择学院', trigger: 'change' }
  ]
}

// 方法
const handleSearch = () => {
  currentPage.value = 1
  getUserList()
}

const resetSearch = () => {
  searchForm.keyword = ''
  searchForm.college = ''
  getUserList()
}

const handleAdd = () => {
  dialogType.value = 'add'
  dialogVisible.value = true
  Object.assign(userForm, {
    studentId: '',
    name: '',
    gender: 'M',
    college: '',
    major: '',
    className: '',
    admissionYear: new Date().getFullYear(),
    status: 'NORMAL'
  })
}

const handleEdit = (row) => {
  dialogType.value = 'edit'
  dialogVisible.value = true
  Object.assign(userForm, row)
}

const handleDelete = (row) => {
  ElMessageBox.confirm(
    `确定要删除学生 ${row.name} 的信息吗？`,
    '警告',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    try {
      await userApi.delete(row.id)
      ElMessage.success('删除成功')
      getUserList()
    } catch (error) {
      console.error('删除用户失败:', error)
    }
  })
}

const handleSubmit = async () => {
  if (!userFormRef.value) return
  await userFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        const userData = {
          ...userForm,
          status: userForm.status || 'NORMAL'
        }
        
        if (dialogType.value === 'add') {
          await userApi.create(userData)
        } else {
          await userApi.update(userData)
        }
        ElMessage.success(dialogType.value === 'add' ? '添加成功' : '修改成功')
        dialogVisible.value = false
        getUserList()
      } catch (error) {
        console.error('保存用户失败:', error)
        ElMessage.error('保存用户失败')
      }
    }
  })
}

const handleSelectionChange = (selection) => {
  console.log('selected:', selection)
}

const handleSizeChange = (val) => {
  pageSize.value = val
  getUserList()
}

const handleCurrentChange = (val) => {
  currentPage.value = val
  getUserList()
}

const handleImport = () => {
  // TODO: 实现导入逻辑
}

const handleExport = () => {
  // TODO: 实现导出逻辑
}

// 获取用户列表
const getUserList = async () => {
  loading.value = true
  try {
    const params = {}
    if (searchForm.keyword) {
      params.keyword = searchForm.keyword
    }
    if (searchForm.college) {
      params.college = searchForm.college
    }
    
    const res = await userApi.getList(params)
    // 前端分页处理
    const start = (currentPage.value - 1) * pageSize.value
    const end = start + pageSize.value
    userList.value = res.slice(start, end)
    total.value = res.length
  } catch (error) {
    console.error('获取用户列表失败:', error)
    ElMessage.error('获取用户列表失败')
  } finally {
    loading.value = false
  }
}

// 在onMounted中调用
onMounted(() => {
  getUserList()
})

// 添加状态标签方法
const getStatusType = (status) => {
  const map = {
    'NORMAL': 'success',
    'WARNING': 'warning',
    'PROBATION': 'danger'
  }
  return map[status] || 'info'
}

const getStatusLabel = (status) => {
  const map = {
    'NORMAL': '正常',
    'WARNING': '预警',
    'PROBATION': '留校察看'
  }
  return map[status] || '未知'
}
</script>

<style scoped>
.users-container {
  padding: 20px;
}

.action-bar {
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 20px;
}

.search-form {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.action-buttons {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

:deep(.el-table) {
  --el-table-border-color: var(--el-border-color-lighter);
  --el-table-header-bg-color: var(--el-fill-color-light);
  border-radius: 8px;
  overflow: hidden;
}

:deep(.el-button-group) {
  display: flex;
  gap: 4px;
}

@media (max-width: 768px) {
  .action-bar {
    flex-direction: column;
  }
  
  .search-form {
    width: 100%;
  }
  
  .action-buttons {
    width: 100%;
    justify-content: flex-end;
  }
}

:deep(.el-input) {
  width: 200px;
}

:deep(.el-select) {
  width: 160px;
}

:deep(.el-select-dropdown__item) {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  padding-right: 20px;
}
</style> 