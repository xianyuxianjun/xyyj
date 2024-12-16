import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/login',
      name: 'Login',
      component: () => import('../views/Login.vue'),
      meta: { 
        requiresAuth: false,
        layout: 'blank'
      }
    },
    {
      path: '/',
      component: () => import('../layout/index.vue'),
      redirect: '/dashboard',
      children: [
        {
          path: '/dashboard',
          name: 'Dashboard',
          component: () => import('../views/Dashboard.vue'),
          meta: { 
            requiresAuth: true,
            title: '数据概览'
          }
        },
        {
          path: '/users',
          name: 'Users',
          component: () => import('../views/Users.vue'),
          meta: { 
            requiresAuth: true,
            title: '用户管理'
          }
        },
        {
          path: '/warnings',
          name: 'Warnings',
          component: () => import('../views/Warnings.vue'),
          meta: { 
            requiresAuth: true,
            title: '预警管理'
          }
        },
        {
          path: '/reports',
          name: 'Reports',
          component: () => import('../views/Reports.vue'),
          meta: { 
            requiresAuth: true,
            title: '统计报表'
          }
        }
      ]
    }
  ]
})

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  
  if (to.meta.requiresAuth && !token) {
    next('/login')
  } else if (to.path === '/login' && token) {
    next('/')
  } else {
    next()
  }
})

export default router 