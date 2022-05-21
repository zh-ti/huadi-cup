<template>
  <div>
    <el-row :gutter="15">
      <el-col :span="6">
        <el-card shadow="hover" style="color: #fff; background-color: #54a0ff">
          <h2>{{ detecation }}</h2>
          <p>总检测人数</p>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" style="color: #fff; background-color: #1dd1a1">
          <h2>{{ fillNum }}</h2>
          <p>今日填报人数</p>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" style="color: #fff; background-color: #ff9f43">
          <h2>{{ hotTmp }}</h2>
          <p>今日发热人数</p>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" style="color: #fff; background-color: #ff7675">
          <h2>{{ goDanger }}</h2>
          <p>今日高危人数</p>
        </el-card>
      </el-col>
    </el-row>
    <el-row :gutter="15">
      <el-col :span="12">
        <el-card shadow="hover">
          <div slot="header" class="clearfix">
            <span>本月汇报情况</span>
          </div>
          <div class="chart curMonth"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card shadow="hover">
          <template slot="header">
            <span>今日核酸检测</span>
          </template>
          <div class="chart detecation"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import createChart from '@/utils/CreateCharts'

export default {
  data() {
    return {
      UserSize: 0,
      fillNum: 0,
      hotTmp: 0,
      goDanger: 0,
      detecation: 0,
    }
  },
  mounted() {
    /**
     * 获取当天健康表信息
     */
    let vm = this
    this.$Axios({
      url: '/students/gethealthNowDay',
      method: 'get',
      success(result) {
        vm.fillNum = result.length
        result.forEach(item => {
          if (item.temperature <= 35 || item.temperature >= 37.2) vm.hotTmp++
          if (item.gohubei == '是') vm.goDanger++
          if (item.hesuan == '是') vm.detecation++
        })
        randerDetecation(result.length, vm.detecation)
      },
    })
    /**
     * 获取当月所有报表
     */
    this.$Axios({
      url: '/students/gethealthNowMonth',
      method: 'get',
      data: {},
      success(result) {
        randerCurMonth(result)
      },
    })

    this.$Axios({
      url: '/users/getUsersByTypePage',
      method: 'get',
      data: {
        type: 2,
        currPage: 0,
        pageNum: 1,
      },
      success: result => {
        console.log(result)
        this.UserSize = result.total
      },
    })
  },
}

function randerDetecation(fill, detection) {
  createChart('.detecation', {
    color: ['#1dd1a1', '#54a0ff'],
    tooltip: {},
    series: {
      type: 'pie',
      data: [
        { name: '已检测', value: detection },
        { name: '未检测', value: fill - detection },
      ],
    },
  })
}
function randerCurMonth(res) {
  let wholeMonth = new Array(30).fill(0)
  let monthTitle = new Array(30).fill(0).map((item, index) => `${index + 1}`)
  let date = res.map(item => new Date(item.createtime).getDate())
  date.forEach(item => wholeMonth[item - 1]++)
  createChart('.curMonth', {
    color: ['#1dd1a1'],
    xAxis: [
      {
        name: '日',
        type: 'category',
        data: monthTitle,
        boundaryGap: true,
      },
    ],
    tooltip: {
      trigger: 'axis',
      axiosPointer: {
        type: 'line',
      },
    },
    yAxis: [
      {
        name: '填报人数',
        type: 'value',
      },
    ],
    series: [
      {
        type: 'line',
        data: wholeMonth,
        smooth: true,
      },
    ],
  })
}
</script>

<style scoped>
.el-row {
  margin-bottom: 15px;
}
.grid-content {
  border-radius: 4px;
  min-height: 36px;
}
.bg-purple {
  background: #d3dce6;
}

.data-card {
  padding: 10px 15px;
  background-color: #fff;
  border-radius: 4px;
}

.chart {
  height: 20rem;
}
</style>
