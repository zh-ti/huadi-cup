import * as echarts from 'echarts'

export default (express, option, callback) => {
  const chart = echarts.init(document.querySelector(express))
  chart.setOption(option)
  window.addEventListener('resize', () => chart.resize())
  callback && callback(chart, option)
}
