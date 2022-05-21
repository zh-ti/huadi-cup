<template>
  <div class="table-header">
    <el-input
      placeholder="请输入搜索的内容"
      v-model="input"
      style="width:50%"
      class="input-with-select"
    >
      <el-select
        v-if="selectOptions.length > 0"
        v-model="selectType"
        slot="prepend"
        style="width:100px"
        placeholder="请选择"
      >
        <el-option
          v-for="(item, index) in selectOptions"
          :key="index"
          :label="item.label"
          :value="item.value"
        ></el-option>
      </el-select>
      <el-button
        slot="append"
        icon="el-icon-search"
        @click="search"
      ></el-button>
    </el-input>
    <el-button type="primary" @click="reset">重置</el-button>
    <slot></slot>
  </div>
</template>

<script>
export default {
  data() {
    return {
      selectType: null,
      input: '',
    }
  },
  props: {
    selectOptions: {
      type: Array,
      default: () => [],
    },
    uploadPath: {
      type: String,
      default: '',
    },
  },
  methods: {
    search() {
      const selectOption = { type: this.selectType, keyword: this.input.trim() }
      if (selectOption.selectType || selectOption.keyword.length > 0) {
        this.$emit('search', selectOption)
      } else {
        this.$message({
          message: '请正确的选择和输入搜索内容',
          type: 'warning',
        })
      }
    },

    reset() {
      this.$emit('reset')
      this.input = ''
      this.selectType = null
    },
  },
}
</script>

<style>
.table-header {
  display: flex;
  justify-content: space-between;
}
</style>
