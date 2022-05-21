<template>
  <div class="notice-header">
    <el-input
      placeholder="请输入搜索的通知主题"
      v-model="searchKey"
      style="width:50%"
      class="input-with-select"
    >
      <el-button
        slot="append"
        icon="el-icon-search"
        @click="search"
      ></el-button>
    </el-input>
    <el-button type="primary" @click="reset">重置</el-button>
    <el-button type="primary" plain @click="show = !show">发布通知</el-button>
    <transition>
      <el-dialog
        :visible.sync="show"
        title="通知发布"
        center
        :close-on-click-modal="false"
        :show-close="false"
      >
        <el-form label-position="right" label-width="80px" :model="form">
          <el-form-item label="主题">
            <el-input v-model="form.title" placeholder="主题名称"></el-input>
          </el-form-item>
          <el-form-item label="班级">
            <el-select
              v-model="form.classes"
              multiple
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
          <el-form-item label="内容">
            <el-input
              type="textarea"
              :rows="3"
              :autosize="{ minRows: 3, maxRows: 8 }"
              placeholder="请输入内容"
              v-model="form.content"
            ></el-input>
          </el-form-item>
        </el-form>
        <template slot="footer" class="dialog-footer">
          <el-button type="primary" @click="publish">发布</el-button>
          <el-button @click="show = false">取消</el-button>
        </template>
      </el-dialog>
    </transition>
  </div>
</template>

<script>
export default {
  data() {
    return {
      searchKey: '',
      show: false,
      value: [],
      form: {
        title: '',
        content: '',
        classes: [],
      },
    }
  },
  props: {
    options: {
      type: Array,
      default: () => [],
    },
    classes: {
      type: Array,
      default: () => [],
    },
  },
  methods: {
    search() {
      if (this.searchKey.length > 0) {
        this.$emit('search', this.searchKey)
      }
    },
    publish() {
      if (
        this.form.content.trim().length > 0 &&
        this.form.title.trim().length > 0 &&
        this.form.classes.length > 0
      ) {
        this.$emit('publishNotice', this.form)
        this.form = {
          title: '',
          content: '',
          classes: [],
        }
        this.show = false
      } else {
        this.$message({
          type: 'warning',
          message: '请先将信息填写完整',
        })
      }
    },
    reset() {
      if (this.searchKey.trim().length > 0) {
        this.$emit('reset')
        this.searchKey = ''
      }
    },
  },
}
</script>

<style>
.notice-header {
  display: flex;
  justify-content: space-between;
}
</style>
