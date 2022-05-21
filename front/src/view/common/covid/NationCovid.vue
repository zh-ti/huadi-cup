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
          <div class="chart china1"></div>
        </el-card>
      </el-col>
      <el-col>
        <el-card
          shadow="hover"
          v-loading="loading"
          element-loading-text="数据加载中..."
          element-loading-spinner="el-icon-loading"
          element-loading-background="rgba(255, 255, 255, 0.8)"
        >
          <div class="chart china2"></div>
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
      randerChart1(res.data)
      randerChart2(res.data)
    })
  },
  data() {
    return {
      loading: true,
    }
  },
}

function randerChart1(res) {
  let { chinaDayList } = res.data
  let date = []
  let confirms = []
  let deads = []
  let heals = []
  for (let i = chinaDayList.length - 30; i < chinaDayList.length; i++) {
    date.push(chinaDayList[i].date.substring(5))
    confirms.push(chinaDayList[i].total.confirm)
    deads.push(chinaDayList[i].total.dead)
    heals.push(chinaDayList[i].total.heal)
  }
  createChart('.china1', {
    color: ['#2e86de', '#10ac84', '#ee5253'],
    title: {
      text: '全国疫情发展',
      left: 'center',
      subtext: '数据来源网易',
    },
    legend: {
      left: 'right',
    },
    xAxis: {
      type: 'category',
      data: date,
      boundaryGap: false,
      scale: true,
    },
    tooltip: {
      show: true,
      trigger: 'axis',
      axisPointer: {
        axisPointer: {
          type: 'line',
        },
      },
    },
    yAxis: {
      type: 'value',
      scale: true,
    },
    series: [
      {
        name: '新增',
        type: 'line',
        data: confirms,
        smooth: true,
      },
      {
        color: '#f00',
        name: '死亡',
        type: 'line',
        data: deads,
      },
      {
        name: '治愈',
        type: 'line',
        data: heals,
      },
    ],
  })
}

import chinaMap from '@/lib/map/china.json'
import * as echarts from 'echarts'

function randerChart2(res) {
  echarts.registerMap('chinaMap', chinaMap)
  const { areaTree } = res.data
  let childrens = areaTree.find(item => item.name == '中国').children
  let showData = []
  for (const item of childrens) {
    showData.push({ name: item.name, value: item.today.confirm })
  }
  const chinaMapChart = echarts.init(document.querySelector('.china2'))
  chinaMapChart.setOption({
    title: {
      text: '全国确诊每日新增',
      left: 'center',
      subtext: '数据来源网易',
    },
    visualMap: {
      pieces: [
        {
          gt: 5000,
          label: '> 5000',
          color: '#341f97',
        },
        {
          gte: 2000,
          lte: 5000,
          label: '2000-5000',
          color: '#7f1100',
        },
        {
          gte: 1000,
          lte: 2000,
          label: '1000-2000',
          color: '#f00',
        },
        {
          gte: 100,
          lte: 1000,
          label: '100-1000',
          color: '#ff5428',
        },
        {
          gte: 10,
          lt: 100,
          label: '10-100',
          color: '#ff8c71',
        },
        {
          gt: 0,
          lt: 10,
          label: '1-10',
          color: '#ffd768',
        },
      ],
    },
    label: {
      fontSize: 16,
    },
    tooltip: {
      formatter: `{b} {c}`,
    },
    geo: {
      map: 'chinaMap',
      label: {
        emphasis: {
          show: true,
          color: '#333',
        },
      },
      itemStyle: {
        normal: {
          areaColor: '#f30',
          borderColor: '#666',
        },
        emphasis: {
          focus: 'self',
          areaColor: '#81ecec',
        },
      },
    },
    series: {
      type: 'map',
      geoIndex: 0,
      data: showData,
    },
  })
}
</script>

<style>
.chart {
  height: 600px;
  background-color: #fff;
}
.el-card {
  margin-bottom: 15px;
}
</style>
