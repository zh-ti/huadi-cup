<template>
  <div>
    <el-row :gutter="15">
      <el-col>
        <el-card
          shadow="hover"
          v-loading="loading"
          element-loading-text="数据加载中..."
          element-loading-spinner="el-icon-loading"
          element-loading-background="rgba(255, 255, 255, 0.8)"
        >
          <div class="chart global"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import axios from 'axios'
import createChart from '@/utils/CreateCharts.js'
export default {
  mounted() {
    axios({
      method: 'get',
      url: '/covid19',
    }).then(res => {
      this.loading = false
      rander(res.data)
    })
  },
  data() {
    return {
      loading: true,
    }
  },
}

function rander(res) {
  let { areaTree } = res.data
  areaTree.sort((a, b) => -(a.total.confirm - b.total.confirm))
  let countries = areaTree.filter((item, index) => index < 10)
  let showData = []
  for (const index in countries) {
    showData.push({
      value: countries[index].total.confirm,
      name: countries[index].name,
    })
  }
  createChart('.global', {
    title: {
      text: '全球确诊Top10',
      left: 'center',
      subtext: `数据来源网易`,
    },
    tooltip: {
      show: true,
    },
    legend: {
      left: 'right',
      orient: 'vertical',
    },
    series: [
      {
        type: 'pie',
        radius: ['45%', '70%'],
        center: ['50%', '55%'],
        data: showData,
        label: {
          fontSize: 18,
        },
        itemStyle: {
          borderRadius: 10,
          borderColor: '#fff',
          borderWidth: 2,
        },
      },
    ],
  })
}
</script>

<style>
.chart {
  height: 600px;
  background-color: #fff;
}
</style>
