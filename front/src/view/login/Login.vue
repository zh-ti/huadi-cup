<template>
  <div class="login-view">
    <el-card class="box-card" style="text-align: center; width: 400px;">
      <div slot="header" style="text-align: center">
        <h2 style="font-size: 1rem;letter-spacing:1px">智慧校园疫情防控平台</h2>
      </div>
      <el-form v-model="form">
        <el-form-item>
          <el-input
            prefix-icon="el-icon-user-solid"
            v-model="form.username"
            placeholder="请输入用户名"
            class="inp"
          ></el-input>
        </el-form-item>
        <el-form-item>
          <el-input
            prefix-icon="el-icon-lock"
            placeholder="请输入密码"
            v-model="form.password"
            show-password
            class="inp"
          ></el-input>
        </el-form-item>
        <el-form-item>
          <el-radio-group
            v-model="form.type"
            size="small"
            style="display: flex;justify-content: space-around;margin-top: 1.3rem;"
          >
            <el-radio label="1" border>管理员</el-radio>
            <el-radio label="2" border>学生</el-radio>
            <el-radio label="3" border>教师</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-button type="primary" class="button" size="medim" @click="login">
          登录
        </el-button>
      </el-form>
    </el-card>
  </div>
</template>
<script>
export default {
  name: 'Login',
  data() {
    return {
      form: {
        username: '',
        password: '',
        type: '',
      },
    }
  },
  methods: {
    /**
     * 登录
     * 用户名：username:this.input_user,
     * 密码：password:this.input_pwd,
     */
    login() {
      if (!this.form.username || !this.form.password) {
        this.$message({
          message: '用户名,密码不能为空',
          type: 'warning',
        })
      } else {
        this.$Axios({
          url: '/users/login',
          method: 'post',
          data: this.form,
          success: result => {
            if (result == '用户名或者账号输入错误') {
              this.$message.error('用户名或者账号输入错误')
              this.form = {
                username: '',
                password: '',
                type: '',
              }
            } else {
              this.$message({
                type: 'success',
                message: '登录成功',
              })
              window.localStorage.setItem('token', result.jwt_token)
              window.localStorage.setItem(
                'currentUserType',
                result.loginData[0].type
              )
              this.$router.replace('/common')
            }
          },
        })
      }
    },
  },
}
</script>
<style scoped>
.login h3 {
  text-align: center;
  height: 60px;
  line-height: 20px;
  border-bottom: 1px solid rgb(170, 170, 170);
  color: rgb(92, 92, 92);
}
.inp {
  margin-top: 10px;
}
.button {
  margin-top: 20px;
}
.login-view {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-image: linear-gradient(to right bottom, #81ecec, #74b9ff);
}
</style>
