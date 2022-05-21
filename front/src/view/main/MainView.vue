<template>
  <el-container style="height: 100vh;">
    <CommonMenu
      :isCollapse="isCollapse"
      :asideWidth="asideWidth"
      :menuList="sideNav"
    ></CommonMenu>
    <el-container>
      <el-header style="text-align: right; font-size: 12px;">
        <button class="collapse-btn" @click="isCollapse = !isCollapse">
          <span class="iconfont icon-menu"></span>
        </button>
        <h1 style="letter-spacing: 3px;font-family: '宋体';">
          智慧校园疫情防控平台
        </h1>
        <el-dropdown>
          <i class="el-icon-setting" style="margin-right: 15px"></i>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item>
              <el-link type="primary" :underline="false" @click="signOut">
                退出登录
              </el-link>
            </el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </el-header>
      <el-main>
        <transition name="main-router-view">
          <router-view></router-view>
        </transition>
      </el-main>
    </el-container>
  </el-container>
</template>

<script>
import CommonMenu from '@/view/menu/CommonMenu.vue'
import { studentMenu, teacherMenu, adminMenu } from '@/config/SideNav.js'
export default {
  components: {
    CommonMenu,
  },
  data() {
    const item = {
      date: '2016-05-02',
      name: '王小虎',
      address: '上海市普陀区金沙江路 1518 弄',
    }
    return {
      tableData: Array(10).fill(item),
      isCollapse: true,
      asideWidth: 170,
      openSize: 170,
      closeSize: 64,
      sideNav: null,
    }
  },
  created() {
    this.sideNav = this.getMenu(parseInt(window.localStorage.currentUserType))
  },
  methods: {
    getMenu(type) {
      switch (type) {
        case 1:
          return adminMenu
        case 2:
          return studentMenu
        case 3:
          return teacherMenu
      }
    },
    signOut() {
      localStorage.removeItem('currentUserType')
      this.$router.replace('/login')
      this.$message({
        type: 'success',
        message: '退出登录成功',
      })
    },
  },
  watch: {
    isCollapse: {
      immediate: true,
      handler(val) {
        if (val) {
          this.asideWidth = this.closeSize
        } else {
          this.asideWidth = this.openSize
        }
      },
    },
  },
}
</script>

<style>
.el-header {
  position: relative;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #fff;
  color: #333;
  line-height: 60px;
  padding: 0 10px 0 70px;
  border-bottom: 1px solid #ddd;
}

.el-aside {
  color: #333;
  overflow-x: hidden;
  background-color: #343a40;
}

.el-menu {
  border: none;
}

.el-main {
  background-color: #eee;
}

.collapse-btn {
  left: 10px;
  width: 35px;
  height: 35px;
  padding: 5px;
  border: none;
  outline: none;
  background-color: transparent;
  cursor: pointer;
  transition: color 0.3s;
}
.collapse-btn:hover {
  color: #409eff;
}

.main-router-view-enter-active,
.main-router-view-leave-active {
  transition: opacity 0.7s;
}

.main-router-view-enter,
.main-router-view-leave {
  opacity: 0;
}
</style>
