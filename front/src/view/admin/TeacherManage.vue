<template>
  <div>
    <el-row>
      <el-col :span="24">
        <el-card>
          <TableOperations
            :selectOptions="selectOptions"
            @search="select"
            @reset="getPage"
          >
            <template>
              <el-button type="primary" plain @click="showAdd = true">
                添加
              </el-button>
              <transition>
                <el-dialog
                  title="新增教师信息"
                  :visible.sync="showAdd"
                  center
                  :show-close="false"
                  :close-on-click-modal="false"
                  width="500px"
                >
                  <el-form
                    label-position="left"
                    label-width="60px"
                    :model="addTeacherForm"
                  >
                    <el-form-item label="姓名">
                      <el-input
                        v-model="addTeacherForm.username"
                        placeholder="请输入姓名"
                      ></el-input>
                    </el-form-item>
                    <el-form-item label="性别">
                      <el-radio-group v-model="addTeacherForm.sex">
                        <el-radio label="男">
                          男
                        </el-radio>
                        <el-radio label="女">
                          女
                        </el-radio>
                      </el-radio-group>
                    </el-form-item>
                    <el-form-item label="籍贯">
                      <el-input
                        type="text"
                        v-model="addTeacherForm.address"
                        placeholder="请输入籍贯"
                      />
                    </el-form-item>
                    <el-form-item label="班级">
                      <el-select
                        v-model="addTeacherForm.classes"
                        style="width: 100%"
                        placeholder="请选择班级"
                        multiple
                      >
                        <el-option
                          v-for="item in classes"
                          :key="item.c_id"
                          :label="item.classes"
                          :value="item.classes"
                        ></el-option>
                      </el-select>
                    </el-form-item>
                    <el-form-item label="职位">
                      <el-input
                        type="text"
                        v-model="addTeacherForm.position"
                        placeholder="请输入职位"
                      ></el-input>
                    </el-form-item>
                  </el-form>
                  <template slot="footer">
                    <el-button type="primary" @click="addTeacher">
                      添加
                    </el-button>
                    <el-button type="primary" @click="showAdd = false">
                      取消
                    </el-button>
                  </template>
                </el-dialog>
              </transition>
            </template>
          </TableOperations>
        </el-card>
        <el-card style="margin-top:20px;margin-bottom: 5rem" v-show="!showEdit">
          <el-table :data="tableData" border style="width: 100%">
            <el-table-column prop="id" sortable label="工号"></el-table-column>
            <el-table-column prop="username" label="姓名"></el-table-column>
            <el-table-column prop="sex" label="性别"></el-table-column>
            <el-table-column prop="address" label="籍贯"></el-table-column>
            <el-table-column prop="position" label="职位"></el-table-column>
            <el-table-column label="入职时间" width="160px">
              <template slot-scope="scope">
                {{ scope.row.createtime | dateformat }}
              </template>
            </el-table-column>
            <el-table-column label="操作">
              <template slot-scope="scope">
                <el-button
                  style="padding: 3px 0"
                  type="text"
                  @click="edit(scope.$index, scope.row)"
                >
                  修改
                </el-button>
                <el-button
                  style="padding: 3px 0"
                  type="text"
                  @click="deleteUser(scope.$index, scope.row)"
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
          <el-form
            ref="form"
            v-model="form"
            label-width="80px"
            style="width:50%"
          >
            <el-form-item label="姓名">
              <el-input v-model="form.username" style="width:40%"></el-input>
            </el-form-item>
            <el-form-item label="性别">
              <el-radio-group v-model="form.sex">
                <el-radio label="男"></el-radio>
                <el-radio label="女"></el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="籍贯">
              <el-input v-model="form.address" style="width:40%"></el-input>
            </el-form-item>
            <el-form-item label="班级">
              <el-select
                v-model="form.classes"
                style="width: 100%"
                placeholder="请选择班级"
                multiple
              >
                <el-option
                  v-for="item in classes"
                  :key="item.c_id"
                  :label="item.classes"
                  :value="item.classes"
                ></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="职位">
              <el-input v-model="form.position" style="width:40%"></el-input>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="update">提交修改</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
    </el-row>
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
      form: {
        username: '',
        sex: '',
        address: '',
        position: '',
      },
      addTeacherForm: {
        name: '',
        sex: '',
        address: '',
        classes: '',
        position: '',
      },
      selectOptions: [
        {
          label: '工号',
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
      ],
      classes: [],
      show: false,
      showAdd: false,
      showEdit: false,
      input: '',
      UserSize: 0,
      tableData: [],
      pageNo: 1,
      currentPage: 1,
      pageSize: 10,
      user: null,
    }
  },
  created() {
    //分页
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
    addTeacher() {
      this.addTeacherForm.type = 3
      this.addTeacherForm.classes = this.addTeacherForm.classes.join(';')
      console.log(this.addTeacherForm)
      this.$axiosjwt({
        url: '/admin/addTeacher',
        method: 'post',
        data: this.addTeacherForm,
        success: result => {
          this.$message({
            type: 'success',
            message: '添加成功',
          })
          this.showAdd = false
          this.getPage(this.pageSize, this.pageNo)
          this.resetAddForm()
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
    // 显示修改页面
    edit(index, row) {
      this.showEdit = true
      this.user = row
      this.form.sex = row.sex
      this.form.username = row.username
      this.form.address = row.address
      this.form.classes = row.classes.split(';')
      this.form.position = row.position
      if (row.type == 2) {
        this.form.type = '学生'
      }
      if (row.type == 3) {
        this.form.type = '教师'
      }
    },
    update() {
      if (this.form.username && this.form.sex && this.form.address) {
        this.$confirm('确定修改吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        })
          .then(() => {
            this.form.classes = this.form.classes.join(';')
            this.$axiosjwt({
              url: '/users/upUserdata',
              method: 'post',
              data: {
                u_id: this.user.id,
                username: this.form.username,
                sex: this.form.sex,
                address: this.form.address,
                classes: this.form.classes,
                position: this.form.position,
                type: 3,
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
    select({ type, keyword }) {
      this.$axiosjwt({
        url: '/admin/getUsersByTypeAndChar',
        method: 'get',
        data: {
          type: 3,
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
    getPage(pageNum = this.pageSize, currPage = this.pageNo) {
      this.$axiosjwt({
        url: '/users/getUsersByTypePage',
        method: 'get',
        data: {
          type: 3,
          pageNum: pageNum,
          currPage: currPage - 1,
        },
        success: result => {
          this.tableData = result.data
          this.UserSize = result.total
        },
      })
    },

    deleteUser(index, row) {
      this.$confirm('确定删除吗？此操作不可撤回！', '提示', {
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
    resetAddForm() {
      this.addTeacherForm = {
        name: '',
        sex: '',
        address: '',
        classes: '',
        position: '',
      }
    },
  },
}
</script>

<style></style>
