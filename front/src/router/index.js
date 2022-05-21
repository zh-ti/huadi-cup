import Vue from 'vue'
import VueRouter from 'vue-router'
import { Message } from 'element-ui'

Vue.use(VueRouter)

import MainView from '@/view/main/MainView.vue'

const routes = [
  { path: '*', redirect: '/' },
  {
    path: '/',
    redirect: 'login',
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('@/view/login/Login.vue'),
  },
  {
    path: '/common',
    component: MainView,
    children: [
      {
        path: '',
        redirect: 'covid19',
      },
      {
        path: 'covid19',
        component: () => import('@/view/common/covid/Covid.vue'),
        children: [
          {
            path: '',
            redirect: 'campus',
          },
          {
            path: 'campus',
            component: () => import('@/view/common/covid/CampusCovid.vue'),
          },
          {
            path: 'nation',
            component: () => import('@/view/common/covid/NationCovid.vue'),
          },
          {
            path: 'global',
            component: () => import('@/view/common/covid/GlobalCovid.vue'),
          },
        ],
      },
      {
        path: 'health',
        component: () => import('@/view/common/HealthRecord.vue'),
      },
    ],
  },
  {
    path: '/admin',
    component: MainView,
    children: [
      {
        path: 'student',
        component: () => import('@/view/admin/StudentManage.vue'),
      },
      {
        path: 'teacher',
        component: () => import('@/view/admin/TeacherManage.vue'),
      },
      {
        path: 'notice',
        component: () => import('@/view/admin/NoticeManage.vue'),
      },
      {
        path: 'class',
        component: () => import('@/view/admin/ClassManage.vue'),
      },
    ],
  },
  {
    path: '/student',
    component: MainView,

    children: [
      {
        path: 'notice',
        component: () => import('@/view/student/Notice.vue'),
      },
      {
        path: 'leave',
        component: () => import('@/view/student/Leave.vue'),
      },
    ],
  },
  {
    path: '/teacher',
    component: MainView,
    children: [
      {
        path: 'student',
        component: () => import('@/view/admin/StudentManage.vue'),
      },
      {
        path: 'notice',
        component: () => import('@/view/admin/NoticeManage.vue'),
      },
      {
        path: 'leave',
        component: () => import('@/view/teacher/LeaveManage.vue'),
      },
    ],
  },
]

// 解决ElementUI导航栏中的vue-router在3.0版本以上重复点菜单报错问题
const originalPush = VueRouter.prototype.push

VueRouter.prototype.push = function push(location) {
  return originalPush.call(this, location).catch(err => err)
}

const router = new VueRouter({
  routes,
})

router.beforeEach((to, from, next) => {
  const dest = to.fullPath.split('/')[1]
  let userType = localStorage.getItem('currentUserType')
  if (dest == 'login') {
    next()
  } else if (!userType) {
    Message({
      type: 'warning',
      message: '请先登录',
    })
    next('/login')
  } else {
    if (dest == 'common') {
      next()
    } else if (userType == 1 && dest == 'admin') {
      next()
    } else if (userType == 2 && dest == 'student') {
      next()
    } else if (userType == 3 && dest == 'teacher') {
      next()
    } else {
      Message({
        type: 'warning',
        message: '请先登录正确的账号哦',
      })
      next(from.fullPath)
    }
  }
})

export default router
