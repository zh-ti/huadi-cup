<template>
  <div>
    <el-card>
      <el-row class="class-header">
        <el-input
          placeholder="请输入查询班级"
          v-model="searchClass"
          style="width:30%"
          class="input-with-select"
        >
          <el-button
            slot="append"
            icon="el-icon-search"
            @click="search"
          ></el-button>
        </el-input>
        <el-button type="primary" @click="loadClasses">重置</el-button>
        <el-input
          placeholder="请输入新增班级"
          style="width:30%; margin-left:10px"
          v-model="newClass"
        ></el-input>
        <el-button
          type="primary"
          plain
          style="margin-left:10px"
          @click="addClass"
        >
          添加班级
        </el-button>
      </el-row>
    </el-card>
    <el-card style="margin-top: 20px">
      <el-table
        :data="tableData"
        border
        :default-sort="{ prop: 'c_id', order: 'descending' }"
        style="width: 100%"
      >
        <el-table-column
          prop="c_id"
          sortable
          label="班级编号"
        ></el-table-column>
        <el-table-column
          prop="classes"
          label="班级名称"
          sortable
        ></el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button
              style="padding: 3px 0"
              type="text"
              @click="updateClass(scope.row)"
            >
              修改
            </el-button>
            <el-button
              style="padding: 3px 0"
              type="text"
              @click="deleteClass(scope.row)"
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
          :total="total"
        ></el-pagination>
      </div>
    </el-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      show: false,
      newClass: '',
      searchClass: '',
      total: 0,
      currentPage: 0,
      tableData: [],
    }
  },
  created() {
    this.loadClasses()
  },
  methods: {
    addClass() {
      if (this.newClass.trim().length > 0) {
        this.$axiosjwt({
          url: '/admin/addClasses',
          method: 'get',
          data: {
            classes: this.newClass,
          },
          success: result => {
            this.$message({
              type: 'success',
              message: '添加班级成功',
            })
            this.newClass = ''
            this.loadClasses()
          },
        })
      } else {
        this.$message({
          type: 'warning',
          message: '班级不可为空',
        })
      }
    },
    deleteClass(row) {
      this.$confirm(`确定删除 “${row.classes}” 吗？此操作不可撤回！`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.$axiosjwt({
            url: '/admin/deleteClass',
            method: 'post',
            data: {
              c_id: row.c_id,
            },
            success: () => {
              this.$message({
                type: 'success',
                message: '删除成功',
              })
              this.loadClasses()
            },
          })
        })
        .catch(err => err)
    },
    updateClass(row) {
      this.$prompt('请输入修改后的班级名称', '提示', {
        confirmButtonText: '修改',
        cancelButtonText: '取消',
      })
        .then(({ value }) => {
          this.$axiosjwt({
            url: '/admin/updateClass',
            method: 'post',
            data: {
              c_id: row.c_id,
              classes: value,
            },
            success: () => {
              this.$message({
                type: 'success',
                message: '修改成功',
              })
              this.loadClasses()
            },
          })
        })
        .catch(err => err)
    },
    search() {
      if (this.searchClass.trim().length > 0) {
        this.$axiosjwt({
          url: '/admin/getClassesSear',
          method: 'get',
          data: {
            inputText: this.searchClass,
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
    handleSizeChange(val) {
      // console.log(`每页 ${val} 条`);
      this.pageSize = val
      //自行添加分页
    },
    handleCurrentChange(val) {
      // console.log(`当前页${val} `);
      this.pageNo = val
    },
    loadClasses() {
      this.searchClass = ''
      this.$axiosjwt({
        url: '/admin/getClasses',
        method: 'get',
        data: {},
        success: result => {
          this.tableData = result
          this.total = result.length
        },
      })
    },
  },
}
</script>

<style>
.class-header {
  display: flex;
  justify-content: space-between;
}
</style>
