<template>
  <div>
    <el-card>
      <TableOperations>
        <el-button type="primary" @click="show = true">请假</el-button>
      </TableOperations>
    </el-card>
    <el-dialog :visible.sync="show" title="请假申请" center>
      <el-form v-model="form">
        <el-form-item label="请假类型">
          <el-select v-model="form.type" placeholder="请选择请假类型">
            <el-option label="事假" value="事假"></el-option>
            <el-option label="病假" value="病假"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="请假时间">
          <el-date-picker
            v-model="form.date"
            type="daterange"
            align="right"
            unlink-panels
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          ></el-date-picker>
        </el-form-item>
        <el-form-item label="请假原因">
          <el-input
            type="textarea"
            placeholder="请输入请假原因"
            v-model="form.content"
            maxlength="100"
            :rows="3"
            show-word-limit
          ></el-input>
        </el-form-item>
      </el-form>
      <template slot="footer">
        <el-button type="primary" @click="submit">提交</el-button>
        <el-button type="primary" @click="show = false">取消</el-button>
      </template>
    </el-dialog>

    <el-card style="margin-top:20px ;margin-bottom: 5rem">
      <el-table
        :data="tableData"
        border
        :default-sort="{ prop: 'createtime', order: 'descending' }"
        style="width: 100%"
      >
        <el-table-column label="申请时间" sortable>
          <template slot-scope="scope">
            {{ scope.row.createtime | dateformat }}
          </template>
        </el-table-column>
        <el-table-column prop="leavetype" label="类型"></el-table-column>
        <el-table-column
          prop="reason"
          label="详细信息"
          show-overflow-tooltip
        ></el-table-column>
        <el-table-column label="审核结果">
          <template slot-scope="scope">
            {{ scope.row.state | state }}
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
import TableOperations from '@/components/table/TableOperations.vue'

export default {
  components: {
    TableOperations,
  },
  data() {
    return {
      UserSize: 0,
      currentPage: 0,
      tableData: [],
      pageSize: 5,
      pageNo: 1,
      currentPage1: 1,
      text: '',
      show: false,
      form: {
        type: '',
        date: '',
        content: '',
      },
      value1: '',
      value2: '',
    }
  },
  created() {
    this.getLeave(this.pageNo, this.pageSize)
  },
  filters: {
    state(type) {
      if (type == 0) {
        return '未审批'
      }
      if (type == 1) {
        return '审批不通过'
      }
      if (type == 2) {
        return '审批通过'
      }
    },
  },
  methods: {
    /**获取我的请假单
     *
     currPage:no-1,
      pageNum:size
      this.tableData=result.data;
      this.UserSize = result.total
      * */
    getLeave(no, size) {
      this.$axiosjwt({
        url: '/admin/getuserLeave',
        method: 'get',
        data: {
          currPage: no - 1,
          pageNum: size,
        },
        success: result => {
          this.tableData = result.data
          this.UserSize = result.total
        },
      })
    },
    /**
     * 请假
     *
     reason:this.textarea,
      leavetype:this.value,
      starttime:starttime,
      endtime:endtime
      this.value2[0]请假起始时间
      this.value2[1]请假结束时间
      */
    submit() {
      if (!this.form.type || !this.form.date || !this.form.content) {
        console.log(this.form)
        this.$message({
          type: 'warning',
          message: '请假信息不可以留空',
        })
      } else {
        let dtstart = new Date(this.form.date[0])
        let dtend = new Date(this.form.date[1])
        let starttime = ''
        let endtime = ''
        if (dtstart.getMonth() + 1 < 10)
          starttime =
            dtstart.getFullYear() +
            '-0' +
            (dtstart.getMonth() + 1) +
            '-' +
            dtstart.getDate()
        else
          starttime =
            dtstart.getFullYear() +
            '-' +
            (dtstart.getMonth() + 1) +
            '-' +
            dtstart.getDate()
        if (dtend.getMonth() + 1 < 10)
          endtime =
            dtend.getFullYear() +
            '-0' +
            (dtend.getMonth() + 1) +
            '-' +
            dtend.getDate()
        else
          endtime =
            dtend.getFullYear() +
            '-' +
            (dtend.getMonth() + 1) +
            '-' +
            dtend.getDate()

        this.$axiosjwt({
          url: '/students/setLeave',
          method: 'post',
          data: {
            reason: this.form.content,
            leavetype: this.form.type,
            starttime: starttime,
            endtime: endtime,
          },
          success: result => {
            this.getLeave(this.pageNo, this.pageSize)
            this.$message({
              type: 'success',
              message: result,
            })
            this.show = false
            this.form = {
              type: '',
              date: '',
              content: '',
            }
          },
        })
      }
    },
    handleSizeChange(val) {
      // console.log(`每页 ${val} 条`);
      this.pageSize = val
      this.getLeave(this.pageNo, this.pageSize)
    },
    handleCurrentChange(val) {
      // console.log(`当前页${val} `);
      this.pageNo = val
      this.getLeave(this.pageNo, this.pageSize)
    },
  },
}
</script>
