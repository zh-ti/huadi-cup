<template>
  <el-card>
    <el-row>
      <h2 align="center" style="letter-spacing:2px">每日健康打卡</h2>
    </el-row>
    <el-row type="flex" justify="center" direction="column" align="center">
      <el-form
        :model="form"
        label-position="left"
        label-width="50%"
        :disabled="disable"
        style="width: 350px"
      >
        <el-form-item label="是否发热、咳嗽">
          <el-radio-group v-model="form.radio1">
            <el-radio label="否"></el-radio>
            <el-radio label="是"></el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="是否去过高危地区">
          <el-radio-group v-model="form.radio3">
            <el-radio label="否"></el-radio>
            <el-radio label="是"></el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="是否接触过高危地区人员">
          <el-radio-group v-model="form.radio7">
            <el-radio label="否"></el-radio>
            <el-radio label="是"></el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="是否离开过学校">
          <el-radio-group v-model="form.radio5">
            <el-radio label="否"></el-radio>
            <el-radio label="是"></el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="是否做过核酸检测">
          <el-radio-group v-model="form.radio6">
            <el-radio label="否"></el-radio>
            <el-radio label="是"></el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="消毒用品是否充足">
          <el-radio-group v-model="form.radio8">
            <el-radio label="否"></el-radio>
            <el-radio label="是"></el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="当前体温">
          <el-input v-model="form.temp" style="width:70%"></el-input>
        </el-form-item>
        <el-form-item label="剩余口罩数量">
          <el-input v-model="form.number" style="width:70%"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submit" v-if="!disable">
            提交
          </el-button>
        </el-form-item>
      </el-form>
    </el-row>
  </el-card>
</template>

<script>
export default {
  data() {
    return {
      disable: true,
      tableData: [],
      tableData1: [],
      form: {
        temp: '',
        number: '',
        radio1: '',
        radio2: '否',
        radio3: '',
        radio4: '',
        radio5: '',
        radio6: '',
        radio7: '',
        radio8: '',
        radio9: '否',
      },
      showMessage: null,
    }
  },
  created() {
    /**根据token获取当前用户信息
     * this.tableData列表数据
     * */
    this.$axiosjwt({
      url: '/users/getUserDataByToken',
      method: 'get',
      data: {},
      success: result => {
        this.tableData.push(result)
      },
    })

    /**
     *
     *调用获取当天某用户报表并且决定是否允许填写
     */
    this.getDataToday()
  },
  beforeRouteLeave(from, to, next) {
    this.showMessage && this.showMessage.close()
    next()
  },
  methods: {
    /**
     *   //获取当天某用户报表并且决定是否允许填写
     */
    getDataToday() {
      this.$axiosjwt({
        url: '/students/getHealthNowDayByid',
        method: 'get',
        data: {},
        success: result => {
          //   console.log(result,"xxxxxxxxxxxxx这是结果!!!!!!!!!!!!!!!!!!!!!---------------------")
          if (result.length == 0) {
            this.disable = false
          } else {
            let data = result[0]
            this.disable = true
            this.form.radio1 = data.fever
            this.form.radio3 = data.gohuibei
            this.form.radio5 = data.leaveout
            this.form.radio6 = data.hesuan
            this.form.radio7 = data.mask
            this.form.radio9 = data.hubeiren
            this.form.radio3 = data.gohubei
            this.form.radio8 = data.kills
            this.form.number = data.masknum
            this.form.radio2 = data.fever
            this.form.temp = data.temperature
            this.showMessage = this.$message({
              type: 'success',
              message: '今日健康填报已完成',
              duration: 5000,
              showClose: true,
            })
          }
        },
      })
    },
    submit() {
      if (
        !this.form.temp ||
        !this.form.radio1 ||
        !this.form.radio3 ||
        !this.form.radio9 ||
        !this.form.radio5 ||
        !this.form.radio6 ||
        !this.form.radio7 ||
        !this.form.number ||
        !this.form.radio8 ||
        !this.form.radio2
      ) {
        this.$message({
          type: 'warning',
          message: '填报表不可留空',
        })
      } else {
        this.$confirm('确定提交健康填报吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        })
          .then(() => {
            let tempReg = /^\d+(\.\d+)?$/
            let maskReg = /^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$/
            let tempBool = tempReg.test(this.form.temp)
            let mskBool = maskReg.test(this.form.number)
            if (!tempBool) {
              this.$message({
                type: 'warning',
                message: '体温请输入数字',
              })
            } else {
              if (!mskBool) {
                this.$message({
                  type: 'warning',
                  message: '口罩数量请输入数字',
                })
              } else {
                this.$axiosjwt({
                  url: '/students/sethealth',
                  method: 'post',
                  data: {
                    temperature: this.form.temp,
                    hot: this.form.radio1,
                    gohubei: this.form.radio3,
                    hubeiren: this.form.radio9,
                    leave: this.form.radio5,
                    hesuan: this.form.radio6,
                    mask: this.form.radio7,
                    masknum: this.form.number,
                    kill: this.form.radio8,
                    fever: this.form.radio2,
                  },
                  success: result => {
                    if (result.length != 0) {
                      this.getDataToday()
                    }
                  },
                })
              }
            }
          })
          .catch(() => {})
      }
    },
  },
}
</script>
