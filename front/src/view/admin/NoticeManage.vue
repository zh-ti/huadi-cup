<template>
  <div>
    <el-card>
      <NoticeHeader
        @publishNotice="publishNotice"
        :classes="classes"
        @search="search"
        @reset="getPage"
      ></NoticeHeader>
    </el-card>

    <el-card style="margin-top: 20px">
      <el-table
        :data="tableData"
        border
        :default-sort="{ prop: 'n_id', order: 'descending' }"
        style="width: 100%"
      >
        <el-table-column prop="n_id" sortable label="序列号"></el-table-column>
        <el-table-column prop="title" label="主题"></el-table-column>
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
              @click="detail(scope.$index, scope.row)"
            >
              查看
            </el-button>
            <el-button
              style="padding: 3px 0"
              type="text"
              @click="deleteNotice(scope.$index, scope.row)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="block" style="text-align:center;margin-top:20px">
        <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="currentPage"
          :page-sizes="[10, 20, 30, 40, 50]"
          :page-size="10"
          layout="total, sizes, prev, pager, next, jumper"
          :total="UserSize"
        ></el-pagination>
      </div>
    </el-card>
    <transition>
      <el-dialog :visible.sync="showDetail" title="通知详情" center>
        <el-form label-position="right" label-width="80px" disabled>
          <el-form-item label="主题">
            <el-input
              v-model="detailNotice.title"
              placeholder="主题名称"
            ></el-input>
          </el-form-item>
          <el-form-item label="班级">
            <el-select
              v-model="detailNotice.classes"
              multiple
              style="width: 100%"
              placeholder="通知的班级（多选）"
            >
              <el-option
                v-for="item in classes"
                :key="item.c_id"
                :label="item.name"
                :value="item.name"
              ></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="内容">
            <el-input
              type="textarea"
              :rows="3"
              :autosize="{ minRows: 3, maxRows: 8 }"
              placeholder="请输入内容"
              v-model="detailNotice.content"
            ></el-input>
          </el-form-item>
        </el-form>
      </el-dialog>
    </transition>
  </div>
</template>

<script>
import NoticeHeader from '@/components/table/NoticeHeader.vue'
export default {
  components: {
    NoticeHeader,
  },
  data() {
    return {
      dialogShow: false,
      show: true,
      showDetail: false,
      detailNotice: {},
      UserSize: 0,
      currentPage: 1,
      tableData: [],
      pageSize: 10,
      pageNo: 1,
      classes: [],
      users: [],
    }
  },
  created() {
    /**
     * 调用获取所有通知
     */
    this.getPage(this.pageSize, this.pageNo)
    /**
     * 获取班级表(增值功能)
     */

    this.getClasses()
  },
  methods: {
    publishNotice(form) {
      form.classes = form.classes.join(';')
      this.$axiosjwt({
        url: '/admin/announce',
        method: 'post',
        data: form,
        success: result => {
          this.$message({
            message: '通知发布成功',
            type: 'success',
          })
          this.getPage(this.pageSize, this.pageNo)
        },
      })
    },
    detail(index, notice) {
      this.detailNotice = notice
      this.showDetail = true
    },
    deleteNotice(index, row) {
      this.$confirm('是否删除该通知，此操作不可撤回?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.$axiosjwt({
            url: '/admin/delNotice',
            method: 'get',
            data: {
              n_id: row.n_id,
            },
            success: result => {
              this.getPage(this.pageSize, this.pageNo)
              this.$message({
                type: 'success',
                message: '删除成功!',
              })
            },
          })
        })
        .catch(() => {})
    },
    getClasses() {
      this.$axiosjwt({
        url: '/admin/getClasses',
        method: 'get',
        success: res => {
          this.classes = res
        },
      })
    },
    /**
     * 分页获取所有通知
     * @param pageNum
     * @param currPage
     *
     pageNum:pageNum,
      currPage:currPage-1
      this.tableData=result.data;
      this.UserSize = result.total
      */
    getPage(pageNum = this.pageSize, currPage = this.pageNo) {
      this.$axiosjwt({
        url: '/admin/getAllNotice',
        method: 'get',
        data: {
          pageNum: pageNum,
          currPage: currPage - 1,
        },
        success: result => {
          this.tableData = result.data
          this.UserSize = result.total
        },
      })
    },
    search(keyword) {
      if (keyword.trim().length > 0) {
        this.$axiosjwt({
          url: '/admin/getNoticeSear',
          method: 'get',
          data: {
            title: keyword,
            currPage: 0,
            pageNum: 10,
          },
          success: result => {
            this.tableData = result.data
            this.total = result.data.length
          },
        })
      } else {
        this.$message({
          type: 'warning',
          message: '请填写要查找的班级',
        })
      }
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
  watch: {
    detailNotice(notice) {
      this.detailNotice.classes = notice.class.split(';')
    },
  },
}
</script>

<style scoped>
::-webkit-scrollbar {
  display: none;
}
/* .ca{
         height:15rem ;
     }*/
.imgcar {
  min-height: 11rem;
  display: flex;
  flex-flow: column;
  align-items: center;
  /*margin-top: 2rem;*/
}
.time {
  font-size: 13px;
  color: #999;
}

.bottom {
  margin-top: 13px;
  line-height: 12px;
}

.button {
  padding: 0;
  float: right;
}

.image {
  width: 40px;
  height: 40px;
  display: block;
}

.clearfix:before,
.clearfix:after {
  display: table;
  content: '';
}

.clearfix:after {
  clear: both;
}
</style>
