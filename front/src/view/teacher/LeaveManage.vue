<template>
  <div>
    <el-card>
      <div slot="header" class="clearfix" style="text-align:center">
        <span>请假管理</span>
      </div>
      <el-table :data="tableData" border style="width: 100%">
        <el-table-column label="申请时间" width="160px">
          <template slot-scope="scope">
            {{ scope.row.createtime | dateformat }}
          </template>
        </el-table-column>
        <el-table-column prop="id" label="申请人">
          <template slot-scope="scope">
            {{ username(scope.row) }}
          </template>
        </el-table-column>
        <el-table-column prop="leavetype" label="类型"></el-table-column>
        <el-table-column
          prop="reason"
          label="详细信息"
          show-overflow-tooltip
        ></el-table-column>
        <el-table-column prop="state" label="审核结果">
          <template slot-scope="scope">
            {{ scope.row.state | state }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180px">
          <template slot-scope="scope">
            <el-button
              style="padding: 3px 0"
              type="text"
              @click="view(scope.row, 2)"
              :disabled="scope.row.state != 0"
            >
              同意
            </el-button>
            <el-button
              style="padding: 3px 0"
              type="text"
              @click="view(scope.row, 1)"
              :disabled="scope.row.state != 0"
            >
              拒绝
            </el-button>
            <el-button type="text" @click="exportPDF(scope.row)">
              导出为PDF
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
  </div>
</template>

<script>
import { jsPDF } from 'jspdf'
import 'jspdf-autotable'
import '@/lib/font/STXIHEI-normal'
export default {
  data() {
    return {
      UserSize: 0,
      currentPage: 1,
      tableData: [],
      pageSize: 5,
      pageNo: 1,
      students: [],
    }
  },
  created() {
    this.getapplication(this.pageNo, this.pageSize)
  },
  filters: {
    state(int) {
      if (int == 0) {
        return '未审批'
      }
      if (int == 1) {
        return '未通过'
      }
      if (int == 2) {
        return '通过'
      }
    },
  },
  methods: {
    username({ u_id }) {
      return this.students.find(item => item.id == u_id)?.username
    },
    view(row, upState) {
      let state
      upState == 1 && (state = '拒绝')
      upState == 2 && (state = '同意')
      this.$confirm(`确定${state}该请假申请吗？`, '提示', {
        type: 'warning',
        confirmButtonText: '确定',
        cancelButtonText: '取消',
      })
        .then(() => {
          this.$axiosjwt({
            url: '/admin/upLeaveState',
            method: 'get',
            data: {
              l_id: row.l_id,
              upState,
            },
            success: result => {
              this.getapplication(this.pageNo, this.pageSize)
              this.$message({
                type: 'success',
                message: '操作成功',
              })
            },
          })
        })
        .catch(() => {})
    },
    getapplication(no, size) {
      no = Number(no) - 1
      this.$axiosjwt({
        url: '/admin/getLeave',
        method: 'get',
        data: {
          currPage: no,
          pageNum: size,
        },
        success: result => {
          this.students = result.students
          this.tableData = result.data
          this.UserSize = result.total
        },
      })
    },

    //分页
    handleSizeChange(val) {
      this.pageSize = val
      this.getapplication(this.pageNo, this.pageSize)
    },
    handleCurrentChange(val) {
      this.pageNo = val
      this.getapplication(this.pageNo, this.pageSize)
    },
    exportPDF(row) {
      const pdf = new jsPDF('l', 'pt', 'a5')
      pdf.setFont('STXIHEI')
      pdf.setFontSize(20)
      pdf.text('请假条', this.setTextCenter(pdf, 3), 60)

      let starttime = this.$options.filters.dateformat(row.starttime)
      let endtime = this.$options.filters.dateformat(row.endtime)
      let username = this.username(row)
      let rows = [
        ['请假人', username],
        ['学号', row.u_id],
        ['请假类型', row.leavetype],
        ['请假时间', `${starttime} 至 ${endtime}`],
        ['请假理由', row.reason],
        ['审批结果', `${this.$options.filters.state(row.state)}`],
      ]

      let option = {
        theme: 'grid',
        body: rows,
        startY: 90,
        margin: 50,
        showHeader: 'never',
        tableLineWidth: 2,
        styles: {
          font: 'STXIHEI',
        },
      }
      pdf.autoTable(option)
      pdf.setFont('STXIHEI')
      pdf.setFontSize(10)
      pdf.setTextColor(255, 0, 0)
      pdf.text('*请假期间一切安全由自己负责', 50, 230)
      pdf.save(username + '的请假条.pdf')
    },
    setTextCenter(pdf, txtLength) {
      var fontSize = pdf.getFontSize()
      var pageWidth = pdf.internal.pageSize.width
      const txtWidth = (txtLength * fontSize) / pdf.internal.scaleFactor
      return (pageWidth - txtWidth) / 2
    },
  },
}
</script>

<style></style>
