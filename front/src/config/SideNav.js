import getId from '@/utils/RandomId'

const common = [
  {
    title: '疫情动态',
    icon: 'iconfont icon-virus',
    children: [
      {
        path: '/common/covid19/campus',
        title: '校园疫情',
        icon: 'iconfont icon-school1',
      },
      {
        path: '/common/covid19/nation',
        title: '全国疫情',
        icon: 'iconfont icon-guoneiyou',
      },
      {
        path: '/common/covid19/global',
        title: '全球疫情',
        icon: 'iconfont icon-quanqiu',
      },
    ],
  },
  {
    path: '/common/health',
    title: '健康填报',
    icon: 'iconfont icon-tubiaozhizuomoban-',
  },
]

const studentMenu = createMenu([
  {
    path: '/student/notice',
    title: '我的通知',
    icon: 'iconfont icon-fuhao-tongzhi',
  },
  {
    path: '/student/leave',
    title: '请假申请',
    icon: 'iconfont icon-qingjia',
  },
])

const teacherMenu = createMenu([
  {
    path: '/teacher/notice',
    title: '通知管理',
    icon: 'iconfont icon-fuhao-tongzhi',
  },
  {
    path: '/teacher/student',
    title: '学生管理',
    icon: 'iconfont icon-_xuesheng',
  },
  {
    path: '/teacher/leave',
    title: '请假管理',
    icon: 'iconfont icon-qingjia',
  },
])

const adminMenu = createMenu([
  {
    path: '/admin/class',
    title: '班级管理',
    icon: 'iconfont icon-banjiguanli',
  },
  {
    path: '/admin/teacher',
    title: '教师管理',
    icon: 'iconfont icon-jiaoshi',
  },
  {
    path: '/admin/student',
    title: '学生管理',
    icon: 'iconfont icon-_xuesheng',
  },
  {
    path: '/admin/notice',
    title: '通知管理',
    icon: 'iconfont icon-fuhao-tongzhi',
  },
])

function createMenu(menu) {
  menu.unshift(...common)
  menu.forEach(item => (item.id = getId()))
  return menu
}

export { studentMenu, teacherMenu, adminMenu }
