<template>
  <el-aside
    :width="asideWidth + 'px'"
    style="background-color: #343a40;overflow-x: hidden"
  >
    <el-menu
      class="el-menu-vertical-demo"
      :collapse="isCollapse"
      :collapse-transition="false"
      background-color="#343a40"
      text-color="#fff"
      active-text-color="#ffd04b"
      :default-openeds="['1']"
    >
      <template v-for="(item, index) in menuList">
        <el-submenu v-if="item.children" :index="`${index + 1}`" :key="item.id">
          <template slot="title">
            <i :class="item.icon"></i>
            <span slot="title">{{ item.title }}</span>
          </template>
          <el-menu-item
            v-for="(child_item, child_index) in item.children"
            :index="`${index + 1}-${child_index + 1}`"
            :key="child_index"
            @click="to(index, child_index)"
          >
            <i :class="child_item.icon"></i>
            <span slot="title">{{ child_item.title }}</span>
          </el-menu-item>
        </el-submenu>
        <el-menu-item
          v-else
          :index="`${index + 1}`"
          @click="to(index)"
          :key="item.sid"
        >
          <i :class="item.icon"></i>
          <span slot="title">{{ item.title }}</span>
        </el-menu-item>
      </template>
    </el-menu>
  </el-aside>
</template>

<script>
export default {
  props: {
    asideWidth: {
      type: Number,
      default: 200,
    },
    isCollapse: {
      type: Boolean,
      default: false,
    },
    menuList: {
      type: Array,
      default: () => [],
      require: true,
    },
  },
  methods: {
    to(index, child_index) {
      if (child_index != undefined) {
        this.$router.push(this.menuList[index].children[child_index].path)
      } else {
        this.$router.push(this.menuList[index].path)
      }
    },
  },
}
</script>
