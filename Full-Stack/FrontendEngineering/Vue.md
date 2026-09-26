# [Vue 从入门到精通：从第一个组件到大型项目架构](https://mp.weixin.qq.com/s/BB1WfybqKM1p0J1cACFNgg)

> 这是一个关于“云帆实验室”的故事——一个五人创业小团队，和他们的全栈新人苏晴从“三百行 DOM 手工同步”到“能独立设计大型项目架构”的 Vue 修行。你会跟着苏晴一起，把 SFC、响应式、组件通信、Composables、Vue Router、Pinia、表单、测试与工程化一条条打通，最后亲手做出那个完整的任务管理系统。读完之后你会发现：Vue 的 API 并不难，真正困难的是建立正确的前端思维——状态放在哪里、组件如何拆分、数据怎样流动、异步请求如何管理，以及项目变大后怎样保持代码可维护。

---

## 故事的起点：一个刷新就丢的待办页面

“云帆实验室”是五个人的创业小团队，做一款面向小团队的协作工具。苏晴是刚入职的全栈新人，第一个任务是给产品做一个任务管理页面：新增任务、勾选完成、删除、按状态筛选、多页面切换、登录后从服务器同步数据。

她用原生 JavaScript 写了出来——三百多行，`document.querySelector` 和 `addEventListener` 交织。演示当天，产品体验了三分钟就发现了四个问题：

- 换个筛选条件再切回来，输入过的内容全没了；
- 快速连续勾选两个任务，界面有一个没反应；
- 请求失败时页面白着，没有任何提示；
- 代码一个文件九百行，她自己也已经不敢改了。

技术负责人陈屿看完代码，没有让她修 bug，而是在白板上写了一个公式：

> **UI = render(state)**

“你现在的代码是‘状态变了，然后手工找出哪些 DOM 要改’。Vue 把这个方向反了过来：**界面是状态的映射**。当 `state` 改变，Vue 会重新计算受影响的界面，而你通常不需要直接操作 DOM。”

他给苏晴定了个目标：**用 Vue 3 + Vite + Composition API + `<script setup>` + TypeScript 重写整个任务模块，六周，从第一个组件做到能撑住大型项目架构。**

这个故事，就是这六周走完的完整路线图。

---

## 第 1 站：为什么是 Vue——把“手工同步”交给编程模型

第一周第一课，陈屿没有直接讲语法，先带苏晴复盘她那三百多行代码的问题。“原生 JavaScript 当然也能完成任务管理页面，但随着功能增加，你会不断处理：”

1. 数据变化后，哪些 DOM 需要更新；
2. 多个模块怎样共享状态；
3. 页面切换时怎样保留或销毁状态；
4. 事件监听何时绑定、何时移除；
5. 请求失败、加载中、空数据如何展示；
6. 代码怎样拆分，才能让多人协作。

“Vue 的价值，就是把这些问题抽象成一套稳定的编程模型。它可以概括为三个关键词：**声明式**——描述‘界面应该是什么样’，而不是手动一步步操作 DOM；**响应式**——状态变化时，相关界面自动更新；**组件化**——把复杂页面拆成职责明确、可以复用的组件。”

学前基础清单也一并给了：HTML 需要知道常见标签、表单、语义化结构——

```html
<form>
  <label for="title">任务名称</label>
  <input id="title" type="text" />
  <button type="submit">添加</button>
</form>
```

CSS 需要掌握选择器、盒模型、Flexbox、Grid、响应式布局和 CSS 变量；JavaScript 重点包括 `let`/`const`、数组和对象、解构与展开运算符、模块化 `import/export`、箭头函数、Promise 与 `async/await`、数组方法 `map`/`filter`/`find`/`reduce`、基本的 DOM 和事件概念。“如果这些内容还不熟，不必等到全部学完再开始 Vue。更高效的方式是：**一边做 Vue 项目，一边补 JavaScript 基础。**”

## 第 2 站：搭好项目——create-vue 与任务系统的骨架

现代 Vue 项目通常使用官方脚手架 `create-vue` 创建，并由 Vite 提供开发服务器和生产构建能力。建议安装当前受支持的 Node.js LTS 版本，然后：

```bash
npm create vue@latest
```

脚手架会询问要启用哪些能力，苏晴按团队约定全选了核心项：

```text
Project name: vue-task-flow
Add TypeScript? Yes
Add JSX Support? No
Add Vue Router? Yes
Add Pinia? Yes
Add Vitest? Yes
Add an End-to-End Testing Solution? No
Add ESLint? Yes
Add Prettier? Yes
```

```bash
cd vue-task-flow
npm install
npm run dev    # 开发
npm run build  # 构建，结果默认输出到 dist
```

一个经过整理的中型项目，可以采用这样的结构：

```text
src/
├── api/            # 请求函数与接口类型
├── assets/         # 图片、字体、全局样式
├── components/     # 通用组件
├── composables/    # 可复用组合式函数
├── layouts/        # 页面布局
├── router/         # 路由配置
├── stores/         # Pinia 状态仓库
├── types/          # 公共 TypeScript 类型
├── utils/          # 无状态工具函数
├── views/          # 路由页面
├── App.vue         # 根组件
└── main.ts         # 应用入口
```

“目录不是越多越专业。小项目可以保持简单，等职责真正出现后再拆分。”

应用入口 `src/main.ts` 完成了四件事——创建 Vue 应用、安装 Pinia、安装路由、挂载到 `index.html` 的 `#app` 节点：

```ts
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import './assets/main.css'

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.mount('#app')
```

## 第 3 站：SFC 与模板语法——Vue 项目的“长相”

Vue 项目最常见的文件是 `.vue` 单文件组件（Single-File Component，简称 SFC）：

```vue
<script setup lang="ts">
import { ref } from 'vue'

const count = ref(0)
</script>

<template>
  <button type="button" @click="count++">
    点击次数：{{ count }}
  </button>
</template>

<style scoped>
button {
  padding: 10px 16px;
  border: 0;
  border-radius: 8px;
  cursor: pointer;
}
</style>
```

一个 SFC 由三部分组成：`<script setup>` 放状态、函数、生命周期和业务逻辑；`<template>` 放界面结构；`<style>` 放组件样式。`<script setup>` 是 Composition API 在 SFC 中常用的简洁写法——顶层变量、函数和导入的组件，可以直接在模板中使用。

“`scoped` 会让样式主要作用于当前组件，降低组件之间的样式污染，”陈屿提醒，“但它并不意味着可以完全忽视 CSS 结构。全局设计变量、重置样式和排版规则，仍然应该放在全局样式文件中。”

模板语法的核心是几组指令。**文本插值**用双花括号——“模板表达式适合简单计算，不要把复杂业务逻辑塞进模板”：

```vue
<p>{{ username }} 的成绩是 {{ score }}</p>
<p>{{ score >= 60 ? '及格' : '不及格' }}</p>
```

错误示范是把整条流水线写进插值：

```vue
<p>
  {{ orders.filter(order => order.paid).map(order => order.amount).reduce((a, b) => a + b, 0) }}
</p>
```

更好的方式是使用 `computed`：

```ts
const paidTotal = computed(() =>
  orders.value
    .filter(order => order.paid)
    .reduce((sum, order) => sum + order.amount, 0),
)
```

**属性绑定** `:src` 是 `v-bind:src` 的缩写，**事件绑定** `@click` 是 `v-on:click` 的缩写：

```vue
<img :src="avatarUrl" :alt="`${username}的头像`" />
<button :disabled="isSubmitting">提交</button>
<button @click="handleClick">保存</button>
```

常用事件修饰符：`.prevent` 调用 `preventDefault()`、`.stop` 阻止事件冒泡、`.once` 事件只触发一次、`.enter` 按下回车时触发：

```vue
<form @submit.prevent="submitForm">
  <button type="submit">提交</button>
</form>

<button @click.stop="removeTask">删除</button>
<input @keyup.enter="addTask" />
```

**条件渲染**：`v-if` 条件为假时不渲染或销毁节点，适合切换频率低、初始化成本高的场景；`v-show` 始终渲染只切换 `display`，适合切换频率高的场景：

```vue
<p v-if="loading">正在加载……</p>
<p v-else-if="error">{{ error }}</p>
<TaskList v-else :tasks="tasks" />
```

**列表渲染**的 `key` 应稳定且唯一，通常用数据库 ID，不要在列表可能排序、插入或删除时盲目使用数组下标——“因为 `key` 帮助 Vue 判断：哪个节点只是位置改变、哪个是新建的、哪个应该被销毁、哪个组件实例需要保留内部状态”：

```vue
<ul>
  <li v-for="task in tasks" :key="task.id">
    {{ task.title }}
  </li>
</ul>
```

**双向绑定** `v-model` 带三个常用修饰符：`.trim` 去除首尾空格、`.number` 尽量转换为数字、`.lazy` 在 `change` 而不是 `input` 时同步：

```vue
<input v-model.trim="title" placeholder="请输入任务名称" />
<p>当前输入：{{ title }}</p>
```

---

## 第 4 站：响应式系统——学会 Vue 的关键不是背指令

“学会 Vue 的关键，不是背指令，而是理解响应式。”第四周的响应式专题，是苏晴印象最深的一课。

**`ref`** 可以包装基本类型，也可以包装对象。在脚本中需要通过 `.value` 读写，在模板中 Vue 会自动解包：

```ts
import { ref } from 'vue'

const count = ref(0)
const title = ref('学习 Vue')
const user = ref({
  name: '小明',
  age: 18,
})
```

```ts
count.value++
title.value = '学习 Composition API'
user.value.age++
```

```vue
<p>{{ count }}</p>
```

**`reactive`** 用于创建响应式对象，直接修改属性即可：

```ts
import { reactive } from 'vue'

const form = reactive({
  title: '',
  priority: 'normal' as 'low' | 'normal' | 'high',
  completed: false,
})
```

```ts
form.title = '完成 Vue 项目'
form.completed = true
```

“ref 还是 reactive？”苏晴问。陈屿给了一条实用的团队约定：独立值优先使用 `ref`；强关联的表单对象可以使用 `reactive`；需要整体替换对象时优先使用 `ref`；不要为了“少写 `.value`”而把所有东西塞进一个巨大对象：

```ts
const user = ref<User | null>(null)

// 可以整体替换
user.value = await fetchCurrentUser()
```

**`computed`** 用于声明派生状态——派生状态不要手动重复保存：

```ts
import { computed, ref } from 'vue'

const tasks = ref([
  { id: 1, title: '学习 ref', completed: true },
  { id: 2, title: '学习 computed', completed: false },
])

const completedCount = computed(
  () => tasks.value.filter(task => task.completed).length,
)

const remainingCount = computed(
  () => tasks.value.length - completedCount.value,
)
```

错误思路是另存一个 `ref` 再在每个修改入口手工同步——“能计算出来的状态，尽量不要重复存储。”

**`watch`** 用来监听指定数据源并执行副作用，常见用途包括参数变化后重新请求数据、将设置保存到本地存储、与非 Vue 库同步、执行需要清理的异步副作用。带清理逻辑的搜索请求是必会形态：

```ts
import { ref, watch } from 'vue'

const keyword = ref('')

watch(keyword, (newKeyword, oldKeyword) => {
  console.log('关键词变化：', oldKeyword, '->', newKeyword)
})
```

```ts
watch(keyword, async (value, _oldValue, onCleanup) => {
  const controller = new AbortController()
  onCleanup(() => controller.abort())

  if (!value.trim()) {
    results.value = []
    return
  }

  const response = await fetch(
    `/api/search?q=${encodeURIComponent(value)}`,
    { signal: controller.signal },
  )

  results.value = await response.json()
})
```

**`watchEffect`** 会自动收集回调内部读取的响应式依赖：

```ts
watchEffect(() => {
  document.title = `${remainingCount.value} 个任务未完成`
})
```

选择方法三句话：明确知道监听谁并需要新旧值，用 `watch`；依赖较多希望自动收集，用 `watchEffect`；只是计算值不产生副作用，用 `computed`。

**`nextTick`**：修改响应式状态后，DOM 更新通常会被批量调度，需要等待 DOM 更新完成时用它：

```ts
import { nextTick, ref } from 'vue'

const editing = ref(false)
const inputRef = ref<HTMLInputElement | null>(null)

async function startEditing() {
  editing.value = true
  await nextTick()
  inputRef.value?.focus()
}
```

## 第 5 站：第一个任务列表——Props Down, Events Up

理论落地的时刻到了。先定义任务类型：

```ts
export interface Task {
  id: string
  title: string
  completed: boolean
  createdAt: string
}
```

创建 `TaskList.vue`——子组件用 `defineProps` 接收数据、用 `defineEmits` 声明事件：

```vue
<script setup lang="ts">
import type { Task } from '@/types/task'

const props = defineProps<{
  tasks: Task[]
}>()

const emit = defineEmits<{
  toggle: [id: string]
  remove: [id: string]
}>()
</script>

<template>
  <ul v-if="props.tasks.length" class="task-list">
    <li v-for="task in props.tasks" :key="task.id" class="task-item">
      <label>
        <input
          type="checkbox"
          :checked="task.completed"
          @change="emit('toggle', task.id)"
        />
        <span :class="{ completed: task.completed }">
          {{ task.title }}
        </span>
      </label>

      <button type="button" @click="emit('remove', task.id)">
        删除
      </button>
    </li>
  </ul>

  <p v-else>暂时没有任务。</p>
</template>
```

父组件持有状态，监听事件：

```vue
<script setup lang="ts">
import { ref } from 'vue'
import TaskList from '@/components/TaskList.vue'
import type { Task } from '@/types/task'

const tasks = ref<Task[]>([])

function toggleTask(id: string) {
  const task = tasks.value.find(item => item.id === id)
  if (task) task.completed = !task.completed
}

function removeTask(id: string) {
  tasks.value = tasks.value.filter(item => item.id !== id)
}
</script>

<template>
  <TaskList
    :tasks="tasks"
    @toggle="toggleTask"
    @remove="removeTask"
  />
</template>
```

“这段代码体现了 Vue 最重要的数据流：**父组件通过 props 向下传数据，子组件通过 emits 向上报告事件。也就是 Props Down, Events Up。**”陈屿说，“记住这句话，组件通信的一半问题就有了答案。”

---

## 第 6 站：组件通信全家桶——从两个组件到组件树

任务系统开始长出更多组件，通信手段也跟着升级。

**Props** 用 `withDefaults` 给可选参数设默认值，且应当视为只读数据——子组件不要直接修改父组件传入的值：

```ts
const props = withDefaults(
  defineProps<{
    title: string
    maxItems?: number
  }>(),
  {
    maxItems: 20,
  },
)
```

**Emits** 用类型化声明，触发时带完整载荷：

```ts
const emit = defineEmits<{
  save: [payload: { title: string; priority: string }]
  cancel: []
}>()
```

```ts
emit('save', {
  title: '学习 Vue',
  priority: 'high',
})
```

**组件上的 v-model** 用 `defineModel`——“它本质上仍然是‘属性 + 更新事件’的语法封装”：

```vue
<script setup lang="ts">
const model = defineModel<string>({ default: '' })
</script>

<template>
  <input v-model.trim="model" placeholder="输入任务名称" />
</template>
```

```vue
<TaskTitleInput v-model="draftTitle" />
```

**插槽 Slots** 让父组件决定一部分内容，特别适合布局型、容器型和基础 UI 组件。`BaseCard.vue` 定义三个插槽：

```vue
<!-- BaseCard.vue -->
<template>
  <section class="card">
    <header class="card__header">
      <slot name="header" />
    </header>

    <div class="card__body">
      <slot />
    </div>

    <footer class="card__footer">
      <slot name="footer" />
    </footer>
  </section>
</template>
```

使用时按名填充：

```vue
<BaseCard>
  <template #header>
    <h2>今日任务</h2>
  </template>

  <TaskList :tasks="tasks" />

  <template #footer>
    <small>共 {{ tasks.length }} 项</small>
  </template>
</BaseCard>
```

**provide 与 inject** 处理深层依赖注入。用 `InjectionKey` 保证类型安全：

```ts
// task-context.ts
import type { InjectionKey, Ref } from 'vue'

export interface TaskContext {
  selectedId: Ref<string | null>
  selectTask: (id: string) => void
}

export const taskContextKey: InjectionKey<TaskContext> = Symbol('task-context')
```

祖先组件提供，后代组件注入：

```ts
provide(taskContextKey, {
  selectedId,
  selectTask,
})
```

```ts
const taskContext = inject(taskContextKey)

if (!taskContext) {
  throw new Error('TaskContext 未提供')
}
```

使用原则三句话：只跨一两层，优先 Props 与 Emits；深层组件树共享上下文，考虑 `provide/inject`；跨页面共享业务状态，考虑 Pinia。

## 第 7 站：生命周期与 Composables——副作用的边界

“组件从创建到销毁会经历不同阶段。”陈屿先讲生命周期四件套：

```ts
import {
  onMounted,
  onUpdated,
  onBeforeUnmount,
  onUnmounted,
} from 'vue'

onMounted(() => {
  console.log('组件已挂载')
})

onUpdated(() => {
  console.log('组件 DOM 已更新')
})

onBeforeUnmount(() => {
  console.log('组件即将卸载')
})

onUnmounted(() => {
  console.log('组件已卸载')
})
```

重点是**正确清理事件监听**——苏晴当初那三百行代码的监听器泄露，答案在这里：

```ts
function handleKeydown(event: KeyboardEvent) {
  if (event.key === 'Escape') {
    closeDialog()
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown)
})
```

```ts
onBeforeUnmount(() => {
  window.removeEventListener('keydown', handleKeydown)
})
```

“一个组件创建了什么长期资源，就应该负责销毁什么资源。”需要清理的还有：定时器、`IntersectionObserver`/`ResizeObserver`、第三方图表实例、手动注册的全局事件。

**Composables** 是 Composition API 的重要能力——把相关状态和逻辑抽取为组合式函数。“复用的不是代码片段，而是状态逻辑。”创建 `useLocalStorage.ts`：

```ts
import { ref, watch, type Ref } from 'vue'

export function useLocalStorage<T>(
  key: string,
  initialValue: T,
): Ref<T> {
  const storedValue = localStorage.getItem(key)

  const state = ref<T>(
    storedValue === null
      ? initialValue
      : JSON.parse(storedValue),
  ) as Ref<T>

  watch(
    state,
    value => {
      localStorage.setItem(key, JSON.stringify(value))
    },
    { deep: true },
  )

  return state
}
```

使用一行搞定：

```ts
const theme = useLocalStorage<'light' | 'dark'>('theme', 'light')
```

再看一个异步请求组合式函数 `useAsyncData`——把加载、错误、执行统一封装：

```ts
import { ref, type Ref } from 'vue'

interface UseAsyncState<T> {
  data: Ref<T | null>
  loading: Ref<boolean>
  error: Ref<string | null>
  execute: () => Promise<void>
}

export function useAsyncData<T>(
  loader: () => Promise<T>,
): UseAsyncState<T> {
  const data = ref<T | null>(null) as Ref<T | null>
  const loading = ref(false)
  const error = ref<string | null>(null)

  async function execute() {
    loading.value = true
    error.value = null

    try {
      data.value = await loader()
    } catch (reason) {
      error.value = reason instanceof Error
        ? reason.message
        : '未知错误'
    } finally {
      loading.value = false
    }
  }

  return {
    data,
    loading,
    error,
    execute,
  }
}
```

一个优秀的 Composable 通常具备六个特点：名称以 `use` 开头；只暴露调用者真正需要的数据和方法；副作用有明确的创建与清理边界；不依赖具体页面 DOM 结构；输入、输出和错误行为清晰；容易单独测试。

“反过来的提醒也要记住：**不要把所有逻辑都抽成 Composable。只有当逻辑需要复用、测试或隔离时，抽取才真正有价值。**”

---

## 第 8 站：Vue Router——让 URL 成为应用状态的一部分

任务系统要多页面了。“单页应用并不是‘只有一个页面’，而是浏览器不必在每次导航时完整刷新文档。”陈屿带苏晴创建 `src/router/index.ts`：

```ts
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('@/views/HomeView.vue'),
    },
    {
      path: '/tasks',
      name: 'tasks',
      component: () => import('@/views/TaskView.vue'),
      meta: {
        requiresAuth: true,
      },
    },
    {
      path: '/tasks/:id',
      name: 'task-detail',
      component: () => import('@/views/TaskDetailView.vue'),
      props: true,
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('@/views/LoginView.vue'),
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'not-found',
      component: () => import('@/views/NotFoundView.vue'),
    },
  ],
})

export default router
```

页面布局用 `RouterLink` 导航、`RouterView` 作路由出口：

```vue
<template>
  <nav>
    <RouterLink to="/">首页</RouterLink>
    <RouterLink to="/tasks">任务</RouterLink>
  </nav>

  <RouterView />
</template>
```

读取参数用 `useRoute`，编程式导航用 `useRouter`——“优先使用命名路由，可以减少路径字符串散落在项目各处”：

```ts
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const taskId = computed(() => String(route.params.id))
```

```ts
import { useRouter } from 'vue-router'

const router = useRouter()

async function openTask(id: string) {
  await router.push({
    name: 'task-detail',
    params: { id },
  })
}
```

**导航守卫**做登录拦截：

```ts
router.beforeEach(to => {
  const token = localStorage.getItem('access_token')

  if (to.meta.requiresAuth && !token) {
    return {
      name: 'login',
      query: {
        redirect: to.fullPath,
      },
    }
  }
})
```

“注意：**前端路由守卫只能改善交互体验，不能代替服务器权限校验。真正的权限必须由后端验证。**”

路由设计五原则收尾：可分享的筛选条件尽量放进 URL 查询参数；页面级数据通常由路由页面负责加载；详情页使用稳定业务 ID，不要依赖数组下标；页面组件使用动态导入，形成按路由拆包；404 页面必须有明确的返回入口。

## 第 9 站：Pinia——管理跨组件和跨页面状态

“并不是所有状态都应该放进 Pinia。”陈屿先划清边界。适合 Pinia 的状态：当前登录用户、权限信息、购物车、跨页面筛选条件、多个页面都依赖的业务实体、需要统一调试和持久化的状态。不适合的：单个输入框的值、某个弹窗是否打开、单个组件内部的 hover 状态、只在一个页面使用的临时数据。

任务模块的业务状态跨页面共享，进 Store。定义 Setup Store `src/stores/task.ts`——ref 当状态、computed 当 getter、函数当 action：

```ts
import { computed, ref } from 'vue'
import { defineStore } from 'pinia'
import type { Task } from '@/types/task'
import { taskApi } from '@/api/task'

export const useTaskStore = defineStore('task', () => {
  const tasks = ref<Task[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const completedCount = computed(
    () => tasks.value.filter(task => task.completed).length,
  )

  const remainingCount = computed(
    () => tasks.value.length - completedCount.value,
  )

  async function fetchTasks() {
    loading.value = true
    error.value = null

    try {
      tasks.value = await taskApi.list()
    } catch (reason) {
      error.value = reason instanceof Error
        ? reason.message
        : '任务加载失败'
      throw reason
    } finally {
      loading.value = false
    }
  }

  async function addTask(title: string) {
    const task = await taskApi.create({ title })
    tasks.value.unshift(task)
  }

  async function toggleTask(id: string) {
    const task = tasks.value.find(item => item.id === id)
    if (!task) return

    const previousValue = task.completed
    task.completed = !task.completed

    try {
      await taskApi.update(id, {
        completed: task.completed,
      })
    } catch (reason) {
      task.completed = previousValue
      throw reason
    }
  }

  async function removeTask(id: string) {
    await taskApi.remove(id)
    tasks.value = tasks.value.filter(task => task.id !== id)
  }

  return {
    tasks,
    loading,
    error,
    completedCount,
    remainingCount,
    fetchTasks,
    addTask,
    toggleTask,
    removeTask,
  }
})
```

注意 `toggleTask` 里的失败回滚——先保存 `previousValue`，接口失败时恢复。在组件中使用时，解构状态必须用 `storeToRefs`：

```vue
<script setup lang="ts">
import { onMounted } from 'vue'
import { storeToRefs } from 'pinia'
import { useTaskStore } from '@/stores/task'

const taskStore = useTaskStore()
const {
  tasks,
  loading,
  error,
  remainingCount,
} = storeToRefs(taskStore)

onMounted(() => {
  taskStore.fetchTasks()
})
</script>
```

“为什么？因为直接解构响应式 Store，可能破坏属性与 Store 之间的响应式连接；`storeToRefs` 会把状态和 getter 转换为 ref。Action 则可以直接从 Store 调用。”

“Pinia 的 API 很简单，难的是确定边界——**服务器状态 ≠ 全局状态 ≠ 页面状态 ≠ 组件状态**。服务器状态来自接口，可能过期、失败、需要重试；全局状态多个页面共享；页面状态只在当前路由页面有效；组件状态只服务于一个组件实例。**把所有状态都塞进 Store，会让 Store 变成新的‘全局变量仓库’。**”

---

## 第 10 站：API 封装与 TypeScript——把不可信挡在边界外

Store 里的 `taskApi` 从哪来？“不要在每个组件中重复写 `fetch`、状态码判断和错误解析。”陈屿带苏晴创建 `src/api/http.ts`，统一处理鉴权、错误与序列化：

```ts
export class ApiError extends Error {
  constructor(
    message: string,
    public readonly status: number,
    public readonly details?: unknown,
  ) {
    super(message)
    this.name = 'ApiError'
  }
}

interface RequestOptions extends RequestInit {
  token?: string
}

export async function request<T>(
  path: string,
  options: RequestOptions = {},
): Promise<T> {
  const { token, headers, ...requestOptions } = options

  const response = await fetch(
    `${import.meta.env.VITE_API_BASE_URL}${path}`,
    {
      ...requestOptions,
      headers: {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
        ...headers,
      },
    },
  )

  const contentType = response.headers.get('content-type') ?? ''
  const body = contentType.includes('application/json')
    ? await response.json()
    : await response.text()

  if (!response.ok) {
    const message =
      typeof body === 'object' &&
      body !== null &&
      'message' in body
        ? String(body.message)
        : `请求失败：${response.status}`

    throw new ApiError(message, response.status, body)
  }

  return body as T
}
```

任务接口按资源组织：

```ts
import { request } from './http'
import type { Task } from '@/types/task'

interface CreateTaskInput {
  title: string
}

interface UpdateTaskInput {
  title?: string
  completed?: boolean
}

export const taskApi = {
  list() {
    return request<Task[]>('/tasks')
  },

  create(input: CreateTaskInput) {
    return request<Task>('/tasks', {
      method: 'POST',
      body: JSON.stringify(input),
    })
  },

  update(id: string, input: UpdateTaskInput) {
    return request<Task>(`/tasks/${id}`, {
      method: 'PATCH',
      body: JSON.stringify(input),
    })
  },

  remove(id: string) {
    return request<void>(`/tasks/${id}`, {
      method: 'DELETE',
    })
  },
}
```

API 地址来自环境变量。`.env.development` 写 `VITE_API_BASE_URL=http://localhost:3000/api`，`.env.production` 写 `VITE_API_BASE_URL=https://api.example.com`。“重要提醒：**会被打包到浏览器中的环境变量不是秘密**。不要把数据库密码、私钥、第三方服务主密钥等放进前端环境变量，真正的秘密必须保存在服务器端。”

TypeScript 的价值不是“代码看起来更高级”，而是把大量错误提前到编辑器和构建阶段。四个必会用法：为 Props 添加类型、为 Emits 添加类型、为模板引用添加类型、用联合类型代替魔法字符串：

```ts
interface UserProfile {
  id: string
  name: string
  avatarUrl?: string
}

const props = defineProps<{
  user: UserProfile
  editable?: boolean
}>()

const emit = defineEmits<{
  update: [profile: UserProfile]
  remove: [id: string]
}>()

const inputRef = ref<HTMLInputElement | null>(null)
```

```html
<input ref="inputRef" />
```

```ts
type TaskFilter = 'all' | 'active' | 'completed'

const filter = ref<TaskFilter>('all')

filter.value = 'complete' // 类型检查可以发现拼写错误
```

**用判别联合描述异步状态**——它比几个互相独立的布尔值更不容易产生矛盾状态：

```ts
type AsyncState<T> =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; message: string }
```

“错误设计可能出现 `loading = true`、`success = true`、`error = true` 同时成立；判别联合则强制状态在同一时刻只能处于一个分支。”最后一条纪律：不要滥用 `any`——

```ts
// 不推荐
const result: any = await fetchData()
```

```ts
// 更好的方式
const result: unknown = await fetchData()

if (isTaskList(result)) {
  tasks.value = result
}
```

“来自网络、存储和用户输入的数据，在运行时并不会因为你写了 TypeScript 类型就自动可信。关键边界仍然需要校验。”

## 第 11 站：表单——不只是 v-model

“一个真实表单至少要处理：初始值、输入同步、字段校验、错误提示、提交中状态、防止重复提交、成功后的重置或跳转、服务端错误。”陈屿给了苏晴一个完整范本——`touched` 记录是否碰过字段、`computed` 派生校验错误、提交时防重复、失败留痕：

```vue
<script setup lang="ts">
import { computed, reactive, ref } from 'vue'

const form = reactive({
  title: '',
  priority: 'normal' as 'low' | 'normal' | 'high',
})

const touched = reactive({
  title: false,
})

const submitting = ref(false)
const submitError = ref<string | null>(null)

const titleError = computed(() => {
  if (!touched.title) return ''
  if (!form.title.trim()) return '任务名称不能为空'
  if (form.title.trim().length > 50) return '任务名称不能超过 50 个字符'
  return ''
})

const isValid = computed(
  () => !titleError.value && Boolean(form.title.trim()),
)

async function submit() {
  touched.title = true
  if (!isValid.value || submitting.value) return

  submitting.value = true
  submitError.value = null

  try {
    await createTask({
      title: form.title.trim(),
      priority: form.priority,
    })

    form.title = ''
    form.priority = 'normal'
    touched.title = false
  } catch (reason) {
    submitError.value = reason instanceof Error
      ? reason.message
      : '提交失败'
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <form @submit.prevent="submit" novalidate>
    <label for="task-title">任务名称</label>
    <input
      id="task-title"
      v-model="form.title"
      :aria-invalid="Boolean(titleError)"
      :aria-describedby="titleError ? 'task-title-error' : undefined"
      @blur="touched.title = true"
    />

    <p v-if="titleError" id="task-title-error" role="alert">
      {{ titleError }}
    </p>

    <select v-model="form.priority">
      <option value="low">低</option>
      <option value="normal">普通</option>
      <option value="high">高</option>
    </select>

    <p v-if="submitError" role="alert">{{ submitError }}</p>

    <button type="submit" :disabled="!isValid || submitting">
      {{ submitting ? '正在提交……' : '添加任务' }}
    </button>
  </form>
</template>
```

“表单优化的关键不是‘少写几行’，而是让用户始终知道：我填错了什么、现在能不能提交、系统是否正在处理、失败后应该怎样继续。”

## 第 12 站：组件设计——从“能运行”到“可维护”

第五周进入设计篇。四条原则依次展开。

**单一职责**：一个组件最好只有一个主要变化原因。反例是一个 `TaskPage.vue` 同时负责请求任务、筛选任务、编辑任务、弹窗、分页、权限、全部样式和全部子项渲染；应该拆成：

```text
TaskPage.vue
├── TaskToolbar.vue
├── TaskFilter.vue
├── TaskList.vue
│   └── TaskItem.vue
├── TaskEditorDialog.vue
└── TaskPagination.vue
```

**容器组件与展示组件**：容器组件负责请求、状态、路由和业务流程；展示组件接收 Props、发出事件，专注渲染。“这不是必须严格执行的教条，但有助于隔离复杂度。”

**API 要稳定**：组件公开 API 包括 Props、Emits、Slots、`v-model` 和暴露的方法。“一个组件内部可以频繁重构，但公开 API 应尽量稳定。”

**不要过早抽象**：看到两段相似代码，不代表必须立刻抽成一个“万能组件”。抽象前先问四问：它们的变化方向是否一致？抽象后调用方式是否更清楚？是否出现了大量布尔参数？新组件是在表达业务概念，还是只为了消灭几行重复？“**重复代码的成本有时低于错误抽象的成本。**”

Vue 还有几个进阶内置能力要认识。**动态组件**切换视图：

```vue
<script setup lang="ts">
import { computed, ref } from 'vue'
import ListView from './ListView.vue'
import BoardView from './BoardView.vue'

const mode = ref<'list' | 'board'>('list')

const currentView = computed(() =>
  mode.value === 'list' ? ListView : BoardView,
)
</script>

<template>
  <component :is="currentView" />
</template>
```

**KeepAlive** 缓存组件实例——适用于希望切换后保留状态的场景，例如标签页、编辑草稿和列表滚动位置：

```vue
<KeepAlive :max="5">
  <component :is="currentView" />
</KeepAlive>
```

**Teleport** 把弹窗渲染到 `body` 下——弹窗逻辑仍属于当前组件，但可以减少层叠上下文和 `overflow` 裁剪问题：

```vue
<Teleport to="body">
  <div v-if="open" class="modal-backdrop">
    <div class="modal">弹窗内容</div>
  </div>
</Teleport>
```

**异步组件与 Suspense** 处理重组件：

```ts
import { defineAsyncComponent } from 'vue'

const HeavyChart = defineAsyncComponent(
  () => import('./HeavyChart.vue'),
)
```

```vue
<Suspense>
  <AsyncDashboard />

  <template #fallback>
    <DashboardSkeleton />
  </template>
</Suspense>
```

---

## 第 13 站：性能、测试与可访问性——上线前的三重门

任务系统要上线了，陈屿立了三重门。

**第一重：性能。**“先测量。流程永远是：发现问题 → 建立指标 → 定位瓶颈 → 修改 → 再次测量。”具体手段按优先级：

1. **路由懒加载**——避免首屏加载所有页面代码：

```ts
{
  path: '/reports',
  component: () => import('@/views/ReportView.vue'),
}
```

2. **使用 computed 缓存派生状态**——不要在模板中重复执行昂贵计算：

```ts
const visibleTasks = computed(() => {
  return tasks.value.filter(task => {
    if (filter.value === 'active') return !task.completed
    if (filter.value === 'completed') return task.completed
    return true
  })
})
```

3. **控制响应式范围**——大型第三方实例、不可变大对象或巨量数据，不一定需要深度响应式：

```ts
import { markRaw, shallowRef } from 'vue'

const chartInstance = shallowRef<Chart | null>(null)
const chartOptions = markRaw(createLargeChartOptions())
```

4. **长列表虚拟化**——一次渲染几万条 DOM 节点会造成明显卡顿，虚拟列表只渲染视口附近的数据，通常比微调单个组件更有效；
5. **减少不必要的组件更新**——保持 Props 引用稳定、不在模板中频繁创建新对象、使用稳定的 `key`、将高频变化区域拆成更小组件、对真正静态内容使用 `v-once`、在明确受益时使用 `v-memo`；
6. **优化资源**——图片用合适尺寸与现代格式、非首屏图片懒加载、字体只加载需要的字重、避免引入整个大型工具库、检查构建产物与重复依赖、对第三方脚本设置合理加载策略。

“不要只盯着 JavaScript 包体积，还要观察用户体验指标：首屏何时可见、点击后多久有反馈、页面切换是否稳定、加载时是否出现布局跳动、弱网和低性能设备是否可用。”

**第二重：测试。**“测试不是为了追求一个漂亮的覆盖率数字，而是为了降低修改代码时的不确定性。”三个层级各有分工：

| 层级 | 测试对象 | 特点 |
| --- | --- | --- |
| 单元测试 | 工具函数、Composable、Store | 快、定位准确 |
| 组件测试 | 组件渲染与交互 | 验证 Props、Events、Slots |
| 端到端测试 | 完整用户流程 | 真实，但执行成本较高 |

工具函数测试：

```ts
import { describe, expect, it } from 'vitest'
import { normalizeTaskTitle } from './normalizeTaskTitle'

describe('normalizeTaskTitle', () => {
  it('去除首尾空格并合并连续空白', () => {
    expect(normalizeTaskTitle('  学习   Vue  '))
      .toBe('学习 Vue')
  })
})
```

组件测试用 `@vue/test-utils`，验证的是事件契约：

```ts
import { mount } from '@vue/test-utils'
import { describe, expect, it } from 'vitest'
import TaskItem from './TaskItem.vue'

describe('TaskItem', () => {
  it('点击复选框时发出 toggle 事件', async () => {
    const wrapper = mount(TaskItem, {
      props: {
        task: {
          id: 'task-1',
          title: '学习 Vue 测试',
          completed: false,
          createdAt: '2026-01-01T00:00:00.000Z',
        },
      },
    })

    await wrapper.get('input[type="checkbox"]').trigger('change')

    expect(wrapper.emitted('toggle')).toEqual([['task-1']])
  })
})
```

“测试什么？优先测用户可观察的行为、关键业务规则、容易出错的边界条件、失败与重试流程、权限和金额等高风险逻辑。尽量避免：过度测试框架实现细节、只断言组件内部变量、为每一行代码编写脆弱测试、大量依赖快照却不理解快照内容。”

**第三重：可访问性与安全。**优先使用原生语义标签——原生 `button` 自动拥有键盘交互、焦点管理和语义信息：

```vue
<!-- 推荐 -->
<button type="button" @click="save">保存</button>

<!-- 不推荐 -->
<div role="button" tabindex="0" @click="save">保存</div>
```

表单必须有标签——“Placeholder 不能完全替代 Label”：

```vue
<label for="email">邮箱</label>
<input id="email" v-model="email" type="email" />
```

谨慎使用 `v-html`——如果内容来自用户或不可信来源，直接渲染 HTML 可能产生跨站脚本攻击，必须在可信边界进行严格清洗，并尽量使用结构化数据渲染：

```vue
<div v-html="articleHtml" />
```

安全的心法是两句话：“**前端不能保存真正的秘密**——浏览器中的代码、请求和存储都可能被用户查看，不要依赖‘隐藏按钮’实现权限，也不要在前端硬编码敏感密钥。**权限是后端规则，前端是展示层**——前端可以隐藏无权限按钮、阻止无效导航、给出友好提示；后端必须验证身份、验证资源归属、验证每次操作权限、拒绝越权请求。”

## 第 14 站：工程化与分层——团队项目的秩序

任务系统开始多人协作，工程化提上日程。

**代码规范与流水线。**ESLint 负责发现代码质量问题，Prettier 负责统一格式，提交前自动检查，减少无意义的代码风格争论。常用命令：`npm run lint`、`npm run format`、`npm run type-check`、`npm run test:unit`、`npm run build`。一个基础 CI 流程依次运行：

```text
安装依赖
→ 类型检查
→ ESLint
→ 单元测试
→ 生产构建
```

“任何一步失败，都不应该发布。”

**路径别名与统一错误模型。**`import TaskList from '@/components/TaskList.vue'` 比四层相对路径清晰。业务代码不应该到处判断不同格式的错误（`error.response?.data?.msg`、`error.data?.message`、`error.result?.errorText`）——应在 API 层统一转换为项目自己的错误类型。生产环境至少关注：JavaScript 运行错误、接口失败率、页面性能、关键操作成功率、版本号与部署时间、错误对应的用户操作路径。“只有用户说‘页面坏了’时才开始排查，成本通常很高。”

**分层思路**是大型项目的骨架。一个 Vue 应用可以理解为五层：

```text
页面层 Views
    ↓
业务组件 Components / Features
    ↓
状态与流程 Stores / Composables
    ↓
接口层 API
    ↓
服务器
```

每一层解决不同问题：页面层接收路由参数、组织页面布局、调度页面级数据、连接多个业务组件；业务组件层表达具体业务概念、处理局部交互、通过清晰 API 与外部通信；Store 与 Composable 层组织跨组件状态、封装可复用状态逻辑、管理复杂流程与副作用；API 层封装传输协议、统一鉴权/错误/序列化、将后端数据转换为前端模型；Utils 层只放无状态、无副作用的通用函数（`formatDate()`、`normalizeWhitespace()`、`calculateProgress()`）——“不要把所有无处安放的代码都扔进 `utils`。”

**部署**收尾。`npm run build` 后部署 `dist` 目录；History 路由模式必须把未知路径回退到 `index.html`，否则用户直接访问 `/tasks/123` 会 404。Nginx 示例：

```nginx
server {
    listen 80;
    server_name example.com;

    root /var/www/vue-task-flow/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:3000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

部署前检查八项：环境变量是否正确、API 地址是否指向生产环境、路由回退是否配置、静态资源路径是否正确、HTTPS 是否启用、缓存策略是否合理、Source Map 是否按安全策略处理、错误监控是否能够区分版本。

---

## 第 15 站：十大误区——苏晴踩过的坑与排错清单

第六周的复盘课上，陈屿把苏晴六周里踩过和差点踩的坑整理成了十大误区。

**误区 1：修改了普通变量，界面不更新。**`let count = 0; count++` 不是响应式状态，应使用 `const count = ref(0); count.value++`。

**误区 2：直接解构响应式对象。**`const { count } = state` 里的 `count` 只是当前值，需要保持响应式连接时用 `const { count } = toRefs(state)`。

**误区 3：用 watch 计算派生值。**能用 `computed` 表达的值，不要用 `watch` 手动同步：

```ts
// 应优先使用
const completedCount = computed(
  () => tasks.value.filter(task => task.completed).length,
)
```

**误区 4：子组件直接修改 Props。**Props 代表父组件拥有的数据，子组件应发出事件，让父组件决定如何修改。

**误区 5：把所有数据放进 Pinia。**“状态管理不是垃圾桶。局部状态留在局部，能显著降低系统复杂度。”

**误区 6：滥用深度监听。**`watch(form, saveDraft, { deep: true })` 可能在复杂对象上频繁触发——应先明确真正需要监听的字段，必要时增加防抖。

**误区 7：异步请求产生竞态。**用户快速切换筛选条件时，较早发出的请求可能较晚返回，覆盖最新结果。可使用 `AbortController`、请求序号，或数据请求库的取消与缓存能力。

**误区 8：只处理成功状态。**一个数据页面通常至少需要六种状态：初始状态、加载中、成功且有数据、成功但为空、失败、重试中。

**误区 9：在模板中调用有副作用的方法。**模板渲染应尽量保持纯净——不要在模板表达式中修改状态、发请求或写存储。

**误区 10：看到卡顿就加 memo。**先用浏览器性能工具和 Vue Devtools 定位问题。很多卡顿来自超大图片、一次渲染过多 DOM、重复网络请求、第三方脚本、复杂 CSS、不合理的数据结构。

## 第 16 站：路线图、30 天计划与面试速览

结业前，陈屿给了苏晴三份“毕业后继续走的地图”。

**学习路线五阶段。**第一阶段基础入门——目标能独立做一个本地任务清单，掌握创建项目、SFC、模板语法、`ref`/`reactive`/`computed`、`v-if`/`v-for`/`v-model`、Props 与 Emits、基础 CSS，练计数器、待办清单、记账页面、天气卡片、简单笔记应用。第二阶段项目开发——目标能完成带路由、接口和状态管理的应用，掌握 Vue Router、Pinia、API 封装、加载与错误状态、表单验证、TypeScript、Composables、组件拆分，练博客后台、图书管理系统、电商商品与购物车、个人知识库、多页面任务管理系统。第三阶段工程化——目标项目可以多人维护并稳定发布，掌握 ESLint/Prettier、单元测试和组件测试、权限与路由设计、性能分析、CI/CD、错误监控、目录与模块边界、可访问性与安全。第四阶段高级能力——目标能解决复杂架构和性能问题，掌握 Vue 响应式原理、渲染机制与虚拟 DOM、调度与批量更新、自定义指令、插件开发、SSR 与水合、大型状态建模、前端性能指标、设计系统与组件库。第五阶段真正的“精通”——不是记住全部 API，而是能够：识别状态属于哪一层；设计清晰的组件 API；处理并发、失败、取消和重试；在可维护性与抽象程度之间做权衡；用测量结果而不是感觉做性能优化；让代码对团队成员和未来的自己都容易理解；在业务变化时，以较低成本持续迭代。

**30 天实战计划**，一张表走完：

| 时间 | 学习重点 | 实战产出 |
| --- | --- | --- |
| 第 1～3 天 | Vue 项目、SFC、模板语法 | 计数器与个人信息卡 |
| 第 4～6 天 | ref、reactive、computed、watch | 本地待办清单 |
| 第 7～9 天 | Props、Emits、Slots、v-model | 可复用表单组件 |
| 第 10～12 天 | 生命周期、Composable | 本地存储与搜索功能 |
| 第 13～16 天 | Vue Router | 多页面任务系统 |
| 第 17～20 天 | Pinia、API 请求 | 登录和服务器数据同步 |
| 第 21～23 天 | TypeScript、错误处理 | 完善接口类型和异常页面 |
| 第 24～26 天 | 测试、Lint、格式化 | 单元测试与组件测试 |
| 第 27～28 天 | 性能、可访问性、安全 | 优化长列表和表单体验 |
| 第 29～30 天 | 构建、部署、复盘 | 发布可访问的正式项目 |

每天遵循一个闭环：学习一个概念 → 写一个最小示例 → 放进真实项目 → 故意制造错误 → 使用 Devtools 排查 → 总结成自己的笔记。

**高频面试题速览**，十问十答：`ref` 可包装任意值、脚本中通过 `.value` 访问，`reactive` 主要用于对象、通过代理追踪属性访问，项目中通常按状态形态组合使用；`computed` 返回派生值、强调纯计算和缓存，`watch` 响应数据变化并执行副作用，能用 `computed` 表达的值不要用 `watch` 手动同步；`v-for` 需要 `key` 是为了在更新列表时识别节点身份，正确复用、移动或销毁 DOM 与组件实例；低频切换用 `v-if`、高频切换用 `v-show`，还要考虑子树初始化成本和是否保留状态；Props 不建议直接修改，因为其所有权属于父组件，直接修改会破坏单向数据流；`nextTick` 等待 Vue 完成当前批次的 DOM 更新，适合更新状态后读取尺寸、聚焦新元素；Composable 适合复用状态逻辑，Pinia 适合需要统一身份、Devtools、跨页面共享和集中管理的状态，两者可以组合；避免组件越来越大——按业务职责拆分组件、派生状态放 `computed`、可复用逻辑放 Composable、跨页面业务状态放 Store、请求协议放 API 层；性能优化先测量，常用路由懒加载、控制响应式范围、长列表虚拟化、减少无效更新、优化图片和第三方依赖；前端路由守卫不能保证安全——它只能控制前端导航和展示，服务器必须对每个受保护请求进行身份与权限验证。

## 第 17 站：一个完整页面的思考过程——六步设计法

结业答辩的最后一题是：“接到‘做一个任务列表页’的需求，你的第一反应是什么？”陈屿要的不是代码，是思考顺序。

**第一步：列出状态**——任务数据 `tasks`、加载状态 `loading`、错误信息 `error`、筛选条件 `filter`、当前编辑项 `editingTask`、新增弹窗状态 `createDialogOpen`。

**第二步：判断状态归属**：

```text
任务数据：多个页面共享 → Pinia 或服务器状态层
加载与错误：与任务请求绑定 → Store 或请求层
筛选条件：可分享 → URL query
编辑项：当前页面使用 → 页面状态
弹窗状态：局部交互 → 页面或组件状态
```

**第三步：设计组件树**：

```text
TaskView
├── TaskPageHeader
├── TaskFilterBar
├── TaskSummary
├── TaskList
│   └── TaskItem
├── TaskEditorDialog
└── AsyncStatePanel
```

**第四步：设计数据流**：

```text
路由 query → filter
Store → tasks / loading / error
TaskView → TaskList（Props）
TaskItem → TaskList → TaskView（Events）
TaskView → Store Action
Store Action → API
```

**第五步：定义失败行为**——初次加载失败显示重试按钮；删除失败保留原任务并提示；乐观更新失败回滚状态；登录过期清理会话并跳转登录；请求取消不显示为业务错误。

**第六步：定义测试重点**——筛选结果是否正确、删除后列表是否更新、接口失败时是否回滚、无任务时是否显示空状态、未登录是否被引导到登录页、键盘能否完成主要操作。

“这套思考方式比记住一百个 API 更接近真正的工程能力。”陈屿说。

## 尾声：那个九百行的文件，被拆成了十四个模块

六周后的产品评审会上，苏晴演示了重写后的任务系统：切换筛选条件不丢状态、请求失败有重试按钮、快速勾选再也不会“吞操作”、URL 里可以直接分享筛选结果。技术负责人打开代码仓库——当初那个九百行的单文件，如今是 `views`、`stores`、`composables`、`api` 各司其职的十四个模块。

散会时，苏晴把这段修行浓缩成五个核心思想，贴在了工位隔板上：

1. **状态驱动界面**——不要手动同步大量 DOM，让 UI 由状态自然推导；
2. **单向数据流**——Props 向下，事件向上，状态所有权必须清晰；
3. **组合而不是堆积**——用组件组合界面，用 Composable 组合逻辑，用 Store 组织共享状态；
4. **副作用必须有边界**——请求、事件、定时器和第三方实例，都需要明确的创建、失败、取消与清理过程；
5. **架构服务于变化**——最好的代码不是最炫技的代码，而是当需求变化时仍然容易理解、测试和修改的代码。

Vue 入门确实很快，但从“会写 Vue”到“能设计可靠的 Vue 应用”，需要经历大量真实项目训练。当你能够清楚回答下面几个问题时，就已经从入门走向了精通：

- 这份状态应该放在哪里？
- 谁拥有修改它的权利？
- 组件之间怎样通信最清晰？
- 请求失败、重复和取消时会发生什么？
- 代码变大后如何测试和维护？
- 性能问题是否经过测量？
- 这个抽象真的比重复代码更简单吗？

> Vue 只是工具，真正决定项目质量的，是你对状态、边界、数据流和复杂度的理解。

云帆实验室的故事告一段落，但你的故事才刚刚开始。打开终端，敲下 `npm create vue@latest` 吧。

---

## 官方资料与延伸阅读

- Vue 官方文档：https://vuejs.org/
- Vue 快速上手：https://vuejs.org/guide/quick-start.html
- `<script setup>` API：https://vuejs.org/api/sfc-script-setup.html
- Vue TypeScript 指南：https://vuejs.org/guide/typescript/overview.html
- Vue Router 官方文档：https://router.vuejs.org/
- Pinia 官方文档：https://pinia.vuejs.org/
- Vite 官方文档：https://vite.dev/guide/

> 版本提示：本文以 Vue 3 + Vite + Composition API + `<script setup>` + TypeScript 为主线。Vue 生态迭代较快，实际使用时请以官方文档的最新说明为准。

