module.exports = {
  devServer: {
    port: 3000,
    proxy: {
      '/covid19': {
        target: 'https://c.m.163.com',
        changeOrigin: true,
        pathRewrite: {
          '^/covid19': '/ug/api/wuhan/app/data/list-total',
        },
      },
    },
  },
  productionSourceMap: process.env.NODE_ENV === 'production' ? false : true,
}
