import request from './request'

// 预警相关接口
export const warningApi = {
  getList: (params) => request.get('/warningRecord/list', { params }),
  create: (data) => request.post('/warningRecord/create', data),
  update: (data) => request.put('/warningRecord/update', data),
  delete: (id) => request.delete(`/warningRecord/${id}`),
  process: (data) => request.post('/warningProcess/create', data),
  getProcessList: (warningId) => request.get(`/warningProcess/list/${warningId}`)
}

// 用户相关接口
export const userApi = {
  getList: (params) => request.get('/studentInfo/list', { params }),
  create: (data) => request.post('/studentInfo/create', data),
  update: (data) => request.put('/studentInfo/update', data),
  delete: (id) => request.delete(`/studentInfo/${id}`)
}

// 附件相关接口
export const attachmentApi = {
  upload: (file) => {
    const formData = new FormData()
    formData.append('file', file)
    return request.post('/attachment/upload', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
  },
  batchUpload: (files) => {
    const formData = new FormData()
    files.forEach(file => {
      formData.append('files', file)
    })
    return request.post('/attachment/batch-upload', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
  },
  delete: (id) => request.delete(`/attachment/${id}`)
}

// 添加统计相关接口
export const statisticsApi = {
  getOverview: () => request.get('/statistics/overview'),
  getTrend: (params) => request.get('/statistics/trend', { params }),
  getDistribution: () => request.get('/statistics/distribution')
}

// 添加报表相关接口
export const reportApi = {
  getCollegeStats: () => request.get('/report/college'),
  getTypeStats: () => request.get('/report/type'),
  getTrendStats: (params) => request.get('/report/trend', { params })
}

// 添加认证相关接口
export const authApi = {
  login: (data) => request.post('/auth/login', data),
  getUserInfo: () => request.get('/auth/info'),
  logout: () => request.post('/auth/logout')
} 