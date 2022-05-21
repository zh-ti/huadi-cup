<template>
  <div>
    <el-card class="box-card">
      <TableOptions
        :selectOptions="selectOptions"
        @import="importxlsx"
        @search="select"
        @reset="getPage"
      >
        <template>
          <el-button type="primary" plain @click="showAdd = true">
            添加
          </el-button>
          <transition>
            <el-dialog
              title="新增学生信息"
              :visible.sync="showAdd"
              center
              :show-close="false"
              :close-on-click-modal="false"
              width="500px"
            >
              <el-form
                label-position="left"
                label-width="60px"
                :model="addStudentForm"
              >
                <el-form-item label="姓名">
                  <el-input
                    v-model="addStudentForm.username"
                    placeholder="请输入姓名"
                  ></el-input>
                </el-form-item>
                <el-form-item label="性别">
                  <el-radio-group v-model="addStudentForm.sex">
                    <el-radio label="男" value="男"></el-radio>
                    <el-radio label="女" value="男"></el-radio>
                  </el-radio-group>
                </el-form-item>
                <el-form-item label="班级">
                  <el-select
                    v-model="addStudentForm.classes"
                    style="width: 100%"
                    placeholder="请选择班级"
                  >
                    <el-option
                      v-for="item in classes"
                      :key="item.c_id"
                      :label="item.classes"
                      :value="item.classes"
                    ></el-option>
                  </el-select>
                </el-form-item>
                <el-form-item label="籍贯">
                  <el-input
                    type="text"
                    v-model="addStudentForm.address"
                    placeholder="请输入籍贯"
                  />
                </el-form-item>
              </el-form>
              <template slot="footer">
                <el-button type="primary" @click="addStudent">
                  添加
                </el-button>
                <el-button type="primary" @click="showAdd = false">
                  取消
                </el-button>
              </template>
            </el-dialog>
          </transition>
        </template>
      </TableOptions>
    </el-card>
    <el-card style="margin-top:20px;margin-bottom: 5rem" v-show="!showEdit">
      <el-table :data="tableData" border style="width: 100%">
        <el-table-column prop="id" sortable label="学号"></el-table-column>
        <el-table-column prop="username" label="姓名"></el-table-column>
        <el-table-column prop="sex" label="性别"></el-table-column>
        <el-table-column prop="address" label="籍贯"></el-table-column>
        <el-table-column prop="classes" label="班级"></el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button
              style="padding: 3px 0"
              type="text"
              @click="edit(scope.$index, scope.row)"
            >
              编辑
            </el-button>
            <el-button
              style="padding: 3px 0"
              type="text"
              @click="deleteStudent(scope.row)"
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
    <el-card style="margin-top:20px" v-show="showEdit">
      <el-page-header
        @back="showEdit = false"
        content="修改信息"
      ></el-page-header>
      <br />
      <el-form ref="form" v-model="form" label-width="80px" style="width:50%">
        <el-form-item label="姓名">
          <el-input v-model="form.username" style="width:40%"></el-input>
        </el-form-item>
        <el-form-item label="性别">
          <el-radio-group v-model="form.sex">
            <el-radio label="男"></el-radio>
            <el-radio label="女"></el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="班级">
          <el-select
            v-model="form.classes"
            style="width: 100%"
            placeholder="通知的班级（多选）"
          >
            <el-option
              v-for="item in classes"
              :key="item.c_id"
              :label="item.classes"
              :value="item.classes"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="籍贯">
          <el-input v-model="form.address" style="width:40%"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="update">提交修改</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import TableOptions from '@/components/table/TableOperations.vue'
export default {
  components: {
    TableOptions,
  },
  data() {
    return {
      form: {
        username: '',
        sex: '',
        address: '',
        classes: '',
      },
      classes: [],
      show: false,
      showAdd: false,
      addStudentForm: {},
      showEdit: false,
      UserSize: 0,
      currentPage: 1,
      tableData: [],
      pageSize: 10,
      pageNo: 1,
      user: null,
      selectOptions: [
        {
          label: '学号',
          value: 'id',
        },
        {
          label: '姓名',
          value: 'username',
        },
        {
          label: '籍贯',
          value: 'address',
        },
        {
          label: '班级',
          value: 'classes',
        },
      ],
    }
  },

  created() {
    /**
     * 生命周期创建时先获取
     */
    this.getPage(this.pageSize, this.pageNo)
    this.getClasses()
  },
  methods: {
    getClasses() {
      this.$axiosjwt({
        url: '/admin/getClasses',
        method: 'get',
        success: res => {
          this.classes = res
        },
      })
    },
    importFile() {
      this.$confirm('确定将文件导入并上传?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.$emit('import')
        })
        .catch(() => {
          this.$message({
            type: 'info',
            message: '文件导入已经取消',
          })
        })
    },
    addStudent() {
      this.addStudentForm.type = 2
      this.$axiosjwt({
        url: '/admin/addStudent',
        method: 'post',
        data: this.addStudentForm,
        success: result => {
          this.$message({
            type: 'success',
            message: '添加成功',
          })
          this.showAdd = false
          this.getPage(this.pageSize, this.pageNo)
          this.resetForm()
        },
      })
    },
    // 显示修改页面
    edit(index, row) {
      this.showEdit = true
      this.user = row
      this.form.sex = row.sex
      this.form.username = row.username
      this.form.address = row.address
      this.form.classes = row.classes
      if (row.type == 2) {
        this.form.type = '学生'
      }
      if (row.type == 3) {
        this.form.type = '教师'
      }
    },
    /**
     * 管理员更改用户信息
     *  u_id:this.user.id,
        username:this.form.name,
        sex:this.form.sex,
        address:this.form.address,
        type:this.type1
      * */
    update() {
      if (this.form.username && this.form.sex && this.form.address) {
        this.$confirm('确定修改吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        })
          .then(() => {
            this.$axiosjwt({
              url: '/users/upUserdata',
              method: 'post',
              data: {
                u_id: this.user.id,
                username: this.form.username,
                sex: this.form.sex,
                address: this.form.address,
                classes: this.form.classes,
                type: 2,
              },
              success: result => {
                this.$message({
                  message: '修改成功',
                  type: 'success',
                })
                this.showEdit = false
                this.getPage(this.pageSize, this.pageNo)
              },
            })
          })
          .catch(() => {})
      } else {
        this.$message({
          type: 'warning',
          message: '请填写正确的信息',
        })
      }
    },
    /**
     * 分页搜索用户信息
     * ,输入内容
     * this.value,搜素类型
     * 页码大小
     * this.pageNo 当前页数
     * this.tableData列表数据
     *   this.UserSize列表数量
     * */
    select({ type, keyword }) {
      this.$axiosjwt({
        url: '/admin/getUsersByTypeAndChar',
        method: 'get',
        data: {
          type: 2,
          inputText: keyword,
          CharType: type,
          pageNum: this.pageSize,
          currPage: this.pageNo - 1,
        },
        success: result => {
          this.tableData = result.data
          this.UserSize = result.total
        },
      })
    },
    /**
     * 分页获取用户信息
     * @param pageNum
     * @param currPage
     *  this.tableData列表数据
     *   this.UserSize列表数量
     */
    getPage(pageNum = this.pageSize, currPage = this.pageNo) {
      this.$axiosjwt({
        url: '/users/getUsersByTypePage',
        method: 'get',
        data: {
          type: 2,
          pageNum: pageNum,
          currPage: currPage - 1,
        },
        success: result => {
          this.tableData = result.data
          this.UserSize = result.total
        },
      })
    },
    /**
     * 导入文件操作
     */
    importxlsx() {
      this.$axiosjwt({
        url: '/users/setXlsxData',
        method: 'post',
        data: {},
        success: result => {
          this.$message({
            type: 'success',
            message: result,
          })
        },
      })
      this.getPage(this.pageSize, this.pageNo)
    },
    /**
     * 弹窗操作(ui框架调用)
     * */
    deleteStudent(row) {
      this.$confirm('此操作不可撤回, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.$axiosjwt({
            url: '/users/delUserdata',
            method: 'get',
            data: {
              u_id: row.id,
            },
            success: result => {
              this.getPage(this.pageSize, this.pageNo)
            },
          })
          this.$message({
            type: 'success',
            message: '删除成功!',
          })
        })
        .catch(() => {})
    },

    /*
     * 当每页数量或者当前页数改变时重新获取数字
     * @param val
     */
    handleSizeChange(val) {
      this.pageSize = val
      //当输入框等不为空搜索,否则全部分页显示
      if (this.input && this.value) {
        this.select()
      } else {
        this.getPage(this.pageSize, this.pageNo)
      }
    },
    handleCurrentChange(val) {
      this.pageNo = val
      //分页
      if (this.input && this.value) {
        this.select()
      } else {
        this.getPage(this.pageSize, this.pageNo)
      }
    },
    resetForm() {
      this.addStudentForm = {
        username: '',
        sex: '',
        address: '',
        classes: '',
      }
    },
  },
}
</script>

<style></style>
