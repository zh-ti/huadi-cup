/**
 * 项目的入口文件它执行的时候都是从你的 main.js 从上到下的执行的
 */
import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import ElementUi from 'element-ui'
import { Message } from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'

Vue.use(ElementUi)

Vue.prototype.basePath = 'http://localhost:8088'

//引包http://192.168.0.22:999
import axios from 'axios'
// axios.defaults.baseURL =
/**
 * 封装axios方法
 * @param options
 */
let futureAxios = options => {
  !options.data && (options.data = {})
  options.data.token = window.localStorage.token
  axios({
    baseURL: 'http://localhost:8088',
    url: options.url,
    method: options.method || 'POST',
    data: options.data,
    params: options.data,
  })
    .then(result => {
      if (options.success) {
        options.success(result.data)
      }
    })
    .catch(err => {
      let msg = err.response ? err.response.data : '请求异常'
      if (options.error) {
        options.error(msg)
        Message.error({ message: msg, offset: 150 })
      } else {
        Message.error({ message: msg, offset: 150 })
      }
    })
}

/**
 * //封装axios方法,为不需要登录操作时使用
 * @param options 配置
 */
let Axios = options => {
  axios({
    baseURL: 'http://localhost:8088',
    url: options.url,
    method: options.method || 'POST',
    data: options.data,
    params: options.data,
    timeout: 5000,
  })
    .then(result => {
      if (options.success) options.success(result.data)
    })
    .catch(err => {
      console.log(err)
      let msg = err.response ? err.response.data : '请求异常'
      if (options.error) {
        options.error(msg)
        Message.error({ message: msg, offset: 150 })
      } else {
        Message.error({ message: msg, offset: 150 })
      }
    })
}

//需要添加拦截器的
Vue.prototype.$axiosjwt = futureAxios
//不拦截的(不带token)往往用在vue创建前的生命周期中
Vue.prototype.$Axios = Axios

Vue.filter('dateformat', time => {
  var dt = new Date(time)
  // yyyy-mm-dd
  var y = dt.getFullYear()
  var m = dt.getMonth() + 1
  var d = dt.getDate()
  var hh = dt.getHours()
  var mm = dt.getMinutes()
  var ss = dt.getSeconds()
  return y + '-' + m + '-' + d + '  ' + hh + ':' + mm + ':' + ss
})

Vue.config.productionTip = false

window.vm = new Vue({
  router,
  store,
  render: h => h(App),
}).$mount('#app')
