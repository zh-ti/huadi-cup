<template>
  <div>
    <el-row>
      <el-card>
        <div slot="header" class="clearfix" style="text-align:center">
          <span>我的通知</span>
        </div>
        <el-table
          :data="tableData"
          border
          :default-sort="{ prop: 'date', order: 'descending' }"
          style="width: 100%"
        >
          <el-table-column
            prop="n_id"
            sortable
            label="序列号"
          ></el-table-column>
          <el-table-column prop="title" label="主题"></el-table-column>
          <el-table-column
            prop="read"
            label="状态"
            :filters="[
              { text: '已读', value: true },
              { text: '未读', value: false },
            ]"
            :filter-method="filterRead"
          >
            <template slot-scope="scope">
              <span :class="scope.row.read == '未读' && 'font-red'">
                {{ scope.row.read }}
              </span>
            </template>
          </el-table-column>
          <el-table-column label="创建时间">
            <template slot-scope="scope">
              {{ scope.row.createtime | dateformat }}
            </template>
          </el-table-column>
          <el-table-column label="操作">
            <template slot-scope="scope">
              <el-button
                style="padding: 3px 0"
                type="text"
                @click="detail(scope.row)"
              >
                查看
              </el-button>
            </template>
          </el-table-column>
        </el-table>
        <div class="block" style="text-align:center;margin-top:20px">
          <el-pagination
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            :current-page="currentPage"
            :page-sizes="[5, 10, 15, 20, 25]"
            :page-size="5"
            layout="total, sizes, prev, pager, next, jumper"
            :total="UserSize"
          ></el-pagination>
        </div>
      </el-card>
    </el-row>
    <el-dialog
      :title="showNotice.title"
      :visible.sync="show"
      width="30%"
      center
    >
      <span>{{ showNotice.content }}</span>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="receive">
          收 到
        </el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  data() {
    return {
      UserSize: 0,
      currentPage: 1,
      tableData: [],
      pageSize: 5,
      pageNo: 1,
      show: false,
      showNotice: {},
    }
  },
  created() {
    this.getPage(this.pageSize, this.pageNo)
  },
  methods: {
    /**
     * 查看通知详情
     * @param row
     */
    filterRead(isRead) {
      return isRead
    },
    detail(row) {
      this.show = true
      this.showNotice = row
    },

    receive() {
      this.show = false
      if (this.showNotice.read == '未读') {
        this.$axiosjwt({
          url: '/students/received',
          method: 'get',
          data: {
            n_id: this.showNotice.n_id,
          },
          success: result => {
            this.getPage(this.pageSize, this.pageNo)
          },
        })
      }
    },

    /**
     * 我的通知分页获取数据与数量
     * */
    getPage(pageNum = this.pageSize, currPage = this.pageNo) {
      this.$axiosjwt({
        url: '/students/getNotice',
        method: 'get',
        data: {
          pageNum: pageNum,
          currPage: currPage - 1,
        },
        success: result => {
          console.log(result)
          result.data.forEach(item => (item.read = '未读'))
          this.UserSize = result.total
          this.tableData = result.data
          this.getRead()
        },
      })
    },
    /**
     * 获取的我通知已读列表(供已读未读状态渲染)
     */
    getRead() {
      //等同于绑定
      this.$axiosjwt({
        url: '/students/getNoticeRead',
        method: 'get',
        data: {},
        success: result => {
          //判断是否已读未读
          result.forEach(item => {
            this.tableData.forEach(
              notice => item.n_id == notice.n_id && (notice.read = '已读')
            )
          })
        },
      })
    },
    //分页
    handleSizeChange(val) {
      this.pageSize = val
      this.getPage(this.pageSize, this.pageNo)
    },
    handleCurrentChange(val) {
      this.pageNo = val
      this.getPage(this.pageSize, this.pageNo)
    },
  },
}
</script>

<style scoped>
.font-red {
  color: #f56c6c;
}
</style>
