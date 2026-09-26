# [Vite 从入门到精通：现代前端工程化完全指南](https://mp.weixin.qq.com/s/ZAPZPvmcC_QrR3aCOJrm9g)

> 这是一个关于“青崖科技”的故事——一个十二人的电商前端团队，和他们的新成员周屿从“只会三个命令”到“能掌控整个构建体系”的 Vite 修行。你会跟着周屿一起，把原生 ESM、依赖预构建、HMR、环境变量、代理、插件、分包、部署一条条打通，最后亲手把团队的 Webpack 老项目迁移到 Vite 8。读完之后你会发现：Vite 的价值不只是“启动快”——入门只要几分钟，掌握靠理解配置，而精通，需要理解模块、浏览器、编译器、构建器、缓存和部署之间的完整关系。

---

## 故事的起点：一次等了四分半钟的启动

“青崖科技”的电商中台前端项目，是一个三年老 Webpack 仓库：三百多个路由、上千个组件、四个团队共同维护。周屿入职第一天，导师方蕾给他的欢迎仪式是——跑起来这个项目。

`npm run dev` 敲下去，进度条爬了四分半钟。热更新改一行按钮文字，浏览器刷新又卡住十几秒。周屿想起面试时背过的答案：“Vite 很快。”可他只会三个命令：`npm create vite@latest`、`npm run dev`、`npm run build`——为什么快，说不上来。

周五迭代会上，测试同学抱怨“本地改一个样式要等半天”，产品经理抱怨“构建后页面白屏过一次”，周屿发现自己一个问题都接不住。

散会后方蕾把他留下来，在白板上写了一行字：

> 真正掌握 Vite，不是会启动一个项目，而是理解它为什么快、开发与生产为什么采用不同策略、配置何时生效、插件怎样参与模块转换，以及项目变大以后怎样控制构建结果。

她给周屿定了个目标：**六周，从“会敲命令”学到“能讲清每一行报错”，期末作业是把中台项目迁移到 Vite 8。**

这个故事，就是这六周走完的完整路线图。

---

## 第 1 站：Vite 到底是什么——前端工程调度中心

第一周第一课，方蕾先纠正了一个误解。“Vite 是面向现代 Web 项目的前端开发与构建工具，它主要提供两类能力：”

1. **开发服务器**：在开发阶段按需处理源代码，提供快速启动和热更新；
2. **生产构建器**：在发布阶段分析完整模块关系，压缩、分包并输出静态资源。当前 Vite 8 的生产构建由 **Rolldown** 驱动，TypeScript、JSX 等转换大量使用 **Oxc** 工具链。

“可以把 Vite 理解为一个‘前端工程调度中心’：”

```text
源代码
  │
  ├── 开发阶段
  │     ├── 原生 ESM
  │     ├── 按需编译
  │     ├── 依赖预构建
  │     └── 精确 HMR
  │
  └── 生产阶段
        ├── 模块打包
        ├── Tree Shaking
        ├── 代码分割
        ├── 资源哈希
        └── 压缩优化
```

“它不是 React、Vue 或 Svelte 的替代品。React、Vue、Svelte 负责组织界面，TypeScript 负责类型系统，ESLint 负责静态检查，Vitest 负责测试——**Vite 负责把这些工具组织成高效的开发和构建流程**。”

“那它为什么快？”周屿问。方蕾反问：“你觉得为什么中台那个 Webpack 项目启动要四分半？”

## 第 2 站：为什么传统项目启动越来越慢——四分半钟的账单

方蕾把传统“先打包、再启动”模式的启动流程写在白板上：

1. 找到入口文件；
2. 递归分析所有依赖；
3. 转换 TypeScript、JSX、CSS；
4. 将模块打成一个或多个 Bundle；
5. 启动本地服务器；
6. 浏览器才能访问页面。

“项目越大，模块越多，首次打包时间越长。”她画出了中台项目的依赖树：

```text
src/main.ts
  ├── App.vue
  ├── router/index.ts
  ├── store/index.ts
  ├── pages/*
  ├── components/*
  └── utils/*
```

“即使用户只打开首页，传统打包器也可能先分析大量暂时不会访问的模块。Vite 的核心思路是：**开发阶段不必先把整个应用打成一个大包，而是让浏览器通过原生 ESM 按需请求模块**。浏览器访问首页时，只请求首页真正依赖的模块；进入其他页面后，再加载对应代码。”

“这就把‘启动时必须完成的全部工作’，改成了‘按访问路径逐步完成的工作’。”周屿在笔记本上抄下这句话——四分半钟的账单，就是这么省下来的。

## 第 3 站：Vite 为什么快——五个机制联合作战

“Vite 的速度来自多个机制，而不是某一个神奇优化。”方蕾一口气讲了五个。

**第一，原生 ES Modules。**现代浏览器原生支持 `import { createApp } from './app.js'`，Vite 开发服务器保留模块关系，让浏览器按 URL 请求模块：

```html
<script type="module" src="/src/main.ts"></script>
```

浏览器请求 `/src/main.ts` 后，发现其中又导入了 `App.vue`，便继续请求对应资源。Vite 只转换当前请求所需的文件，而不是在启动时把整个应用全部打包。

**第二，按需转换。**“假设项目有 3000 个模块，但首页只用到 150 个。Vite 不需要在启动前处理全部 3000 个模块。这种模式特别适合大型后台管理系统、路由页面很多的 SPA、Monorepo、组件数量庞大的设计系统、包含大量动态导入的应用。”

**第三，依赖预构建。**“浏览器虽然支持 ESM，但不能直接理解裸模块导入——它需要可访问的 URL，而不是 npm 包名：”

```js
import axios from 'axios'
import { debounce } from 'lodash-es'
```

Vite 会扫描依赖并预构建，把请求重写成类似 `/node_modules/.vite/deps/axios.js?v=xxxx`。预构建主要解决两个问题：将 CommonJS、UMD 等依赖转换成浏览器可使用的 ESM；合并内部模块过多的依赖，减少浏览器请求数量。

**第四，精确 HMR**（Hot Module Replacement，热模块替换）。“当某个文件变化时，Vite 不必重新构建整个应用，只需沿模块图找到受影响的边界：”

```text
Button.vue 发生变化
      │
      └── 仅更新 Button 相关模块
```

理想情况下：页面不整页刷新、表单输入不会丢失、组件状态尽量保留、更新延迟只与当前变更链路有关，而不是与项目总规模成正比。

**第五，强缓存。**依赖预构建结果通常存放在 `node_modules/.vite/`，浏览器也会通过 HTTP 缓存复用依赖请求。“所以第一次启动可能要处理依赖，后续启动和刷新往往明显更快。”

方蕾在白板上画了最后一条分界线：“这是理解 Vite 最重要的一点——**开发模式与生产模式不是同一件事**。”

| | 开发阶段 | 生产阶段 |
|---|---|---|
| 目标 | 快速启动、快速反馈、保留源码可读性、精确更新、尽量少做无关工作 | 减少请求、缩小体积、Tree Shaking、合理分包、文件名带哈希、适配部署环境 |
| 主要机制 | 原生 ESM + 按需转换 + 依赖预构建 + HMR | 完整模块分析 + Rolldown 打包 + Oxc/Lightning CSS 压缩 + 资源优化 |

“因此，‘Vite 开发阶段不打包’并不等于‘Vite 完全不打包’。准确说法是：**Vite 在开发阶段尽量采用按需服务，在生产阶段仍然会进行完整构建。**”

---

## 第 4 站：搭好环境，创建第一个 Vite 项目

第一周的后半段是动手课。Vite 8 要求较新的 Node.js，方蕾建议直接使用当前维护中的 LTS，并用版本管理工具控制项目环境。查看版本：

```bash
node -v
npm -v
```

推荐使用：macOS/Linux 上的 `nvm`、`fnm` 或 `mise`；Windows 上的 `nvm-windows`、`fnm` 或 `Volta`。以 `fnm` 为例：

```bash
fnm install 22
fnm use 22
node -v
```

团队协作时，项目中可以增加 `.nvmrc`：

```text
22
```

或者在 `package.json` 中声明（`engines` 主要用于提示和约束，是否强制执行还取决于包管理器配置）：

```js
{
  "engines": {
    "node": "^20.19.0 || >=22.12.0"
  }
}
```

创建项目有两种方式。交互式创建：

```bash
npm create vite@latest
```

依次选择项目名称、框架、JavaScript 或 TypeScript、是否启用框架附加选项。或者直接指定模板：

```bash
# Vue + TypeScript
npm create vite@latest my-vue-app -- --template vue-ts

# React + TypeScript
npm create vite@latest my-react-app -- --template react-ts

# 原生 TypeScript
npm create vite@latest my-app -- --template vanilla-ts
```

进入目录并安装依赖：

```bash
cd my-app
npm install
npm run dev
```

终端会显示 `Local: http://localhost:5173/`。在当前目录创建用 `npm create vite@latest . -- --template react-ts`——“`.` 表示当前目录，使用前确认没有会被覆盖的重要文件。”

以 React + TypeScript 项目为例，目录长这样：

```text
my-app/
├── public/
├── src/
│   ├── assets/
│   ├── App.tsx
│   ├── App.css
│   ├── index.css
│   └── main.tsx
├── index.html
├── package.json
├── tsconfig.json
├── vite.config.ts
└── eslint.config.js
```

方蕾特别指出一个新手误区：“在 Vite 中，`index.html` 不是被藏在 `public` 里的模板，而是**应用入口的一部分**：”

```html
<!doctype html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Vite App</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
```

Vite 会处理其中的 `<script type=“module”>`、CSS 链接、图片等资源引用、HTML 中的环境变量替换、生产构建时的资源路径和哈希。`src/` 放需要参与模块分析和构建的源代码；`public/` 放需要“原样复制”的文件——`favicon.ico`、`robots.txt`、固定名称的第三方验证文件、不希望经过哈希处理的资源。脚手架生成的 `package.json` 脚本：

```js
{
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "lint": "eslint .",
    "preview": "vite preview"
  }
}
```

## 第 5 站：必须掌握的命令与配置文件

“命令是日常操作，配置是进阶起点。”方蕾把常用命令列成一张清单。

启动开发服务器（本质执行 `vite`）：

```bash
npm run dev
```

指定主机（局域网设备访问，例如手机调试）和端口：

```bash
npm run dev -- --host
npm run dev -- --port 3000
```

生产构建，默认输出到 `dist/`：

```bash
npm run build
```

本地预览构建结果——“注意：`vite preview` 只用于本地检查构建产物，**不是正式生产服务器**”：

```bash
npm run preview
```

强制重新预构建依赖——“当依赖缓存异常、依赖源码变化或软链接包更新未生效时很有用”：

```bash
npm run dev -- --force
```

调试与性能分析：

```bash
vite --debug          # 查看调试日志
vite --debug hmr      # 查看 HMR 相关日志
vite --profile        # 生成性能分析文件，定位慢插件或慢转换
```

配置文件的最基础形态——“`defineConfig` 不是必须的，但它能提供更好的类型提示”：

```js
import { defineConfig } from 'vite'

export default defineConfig({
  // 配置项
})
```

很多项目需要根据命令和模式动态返回配置：

```js
import { defineConfig } from 'vite'

export default defineConfig(({ command, mode, isSsrBuild }) => {
  console.log({ command, mode, isSsrBuild })

  return {
    base: mode === 'production' ? '/app/' : '/',
  }
})
```

其中 `command` 通常为 `serve` 或 `build`，`mode` 例如 `development`、`production`、`staging`，`isSsrBuild` 表示是否为 SSR 构建。

---

## 第 6 站：一份企业级配置——中台项目的第一块基石

第二周开始，方蕾给周屿布置了实战：为中台新起的 React 子项目写一份能上生产的企业级配置。她给出的基准版是这样的：

```js
import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'
import { fileURLToPath, URL } from 'node:url'

export default defineConfig(({ mode }) => {
  // 第三个参数为空字符串，表示在配置文件中读取全部环境变量。
  // 不代表这些变量会自动暴露给浏览器。
  const env = loadEnv(mode, process.cwd(), '')

  return {
    plugins: [react()],

    base: env.APP_BASE || '/',

    resolve: {
      alias: {
        '@': fileURLToPath(new URL('./src', import.meta.url)),
      },
    },

    server: {
      host: true,
      port: 5173,
      strictPort: true,
      open: true,
      proxy: {
        '/api': {
          target: env.API_PROXY_TARGET || 'http://localhost:8080',
          changeOrigin: true,
          rewrite: (path) => path.replace(/^\/api/, ''),
        },
      },
    },

    preview: {
      port: 4173,
      strictPort: true,
    },

    build: {
      outDir: 'dist',
      assetsDir: 'assets',
      sourcemap: mode === 'staging',
      target: 'baseline-widely-available',
      cssCodeSplit: true,
      reportCompressedSize: true,
    },

    css: {
      modules: {
        localsConvention: 'camelCaseOnly',
      },
    },

    define: {
      __APP_VERSION__: JSON.stringify(process.env.npm_package_version),
    },
  }
})
```

对应类型声明放在 `src/vite-env.d.ts`：

```ts
/// <reference types="vite/client" />

declare const __APP_VERSION__: string

interface ImportMetaEnv {
  readonly VITE_API_BASE_URL: string
  readonly VITE_APP_TITLE: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
```

方蕾逐块讲了里面最重要的两块：**路径别名**和**代理**。

项目里常见的层层返回 `import { formatDate } from '../../../utils/date'`，可以设置别名后写成 `import { formatDate } from '@/utils/date'`：

```js
import { defineConfig } from 'vite'
import { fileURLToPath, URL } from 'node:url'

export default defineConfig({
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
})
```

“注意 TypeScript 也需要认识这个别名，两边都要配：”

```js
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"]
    }
  }
}
```

“Vite 8 也支持读取 `tsconfig` 的路径映射，但这会增加解析成本。大型项目中，显式维护 Vite alias 往往更直观。”

代理解决的是开发阶段的跨域问题。前端请求 `fetch('/api/users')`，配置转发：

```js
server: {
  proxy: {
    '/api': {
      target: 'http://localhost:8080',
      changeOrigin: true,
      rewrite: (path) => path.replace(/^\/api/, ''),
    },
  },
}
```

请求链路是：浏览器请求 `/api/users` → Vite 开发服务器 rewrite → `http://localhost:8080/users`。方蕾强调了一个必考点：“**代理只在开发服务器生效**。生产环境需要由 Nginx、网关、CDN、BFF 或云平台反向代理处理真实 API 路由。”WebSocket 代理要显式声明 `ws: true`：

```js
server: {
  proxy: {
    '/socket': {
      target: 'ws://localhost:9000',
      ws: true,
    },
  },
}
```

开发服务器的其他常用配置她也过了一遍：`host: true` 允许局域网访问（或命令行 `vite --host`）；`port` 期望端口，`strictPort: false` 端口占用时自动尝试下一个、`strictPort: true` 直接报错——“OAuth 回调、微前端和固定域名联调中，建议用 `strictPort: true`”；`open: true` 自动打开浏览器，还可以指定路径 `open: '/login'`。

## 第 7 站：环境变量与模式——白屏事故的第一现场

配置写好第二天，出事了：测试环境的构建产物部署后白屏。周屿查了一上午，最后发现是环境变量读不到——`import.meta.env.VITE_API_BASE_URL` 是 `undefined`。

方蕾趁热打铁讲清了环境变量体系。Vite 通过 `import.meta.env` 暴露环境信息，内置变量有 `MODE`、`BASE_URL`、`DEV`、`PROD`、`SSR`：

```js
import.meta.env.MODE
import.meta.env.BASE_URL
import.meta.env.DEV
import.meta.env.PROD
import.meta.env.SSR
```

`.env` 文件有一套优先级规则：

```text
.env
.env.local
.env.development
.env.development.local
.env.production
.env.production.local
.env.staging
```

```text
# .env.development
VITE_API_BASE_URL=http://localhost:8080
VITE_APP_TITLE=本地开发环境
```

使用：

```js
const apiBase = import.meta.env.VITE_API_BASE_URL
```

“为什么必须用 `VITE_` 前缀？”周屿问。“**默认情况下，只有以 `VITE_` 开头的变量才会暴露给客户端**。这是安全设计，不是形式主义：”

```text
VITE_PUBLIC_KEY=abc
DB_PASSWORD=secret
```

```js
console.log(import.meta.env.VITE_PUBLIC_KEY) // 可用
console.log(import.meta.env.DB_PASSWORD)     // undefined
```

“那条安全规则要刻在脑子里——不要把数据库密码、云服务私钥、服务端 JWT 签名密钥、支付平台 Secret、管理员访问令牌、任何不能公开给用户的凭据写进 `VITE_` 变量。**因为进入客户端 Bundle 的内容，最终都能被用户查看。**”

另一个坑是类型：“环境变量都是字符串。`VITE_TIMEOUT=5000`、`VITE_ENABLE_MOCK=false`，读取后要用 `Number()` 和 `=== 'true'` 手动转换：”

```js
const timeout = Number(import.meta.env.VITE_TIMEOUT)
const enableMock = import.meta.env.VITE_ENABLE_MOCK === 'true'
```

自定义模式解决多环境部署：

```bash
vite --mode staging
vite build --mode staging
```

此时会读取 `.env`、`.env.local`、`.env.staging`、`.env.staging.local`。“建议把‘模式’和‘Node 运行环境’区分开：`mode` 是 Vite 的配置模式，`NODE_ENV` 会影响部分库的行为，两者相关但不完全等价。”

周屿的白屏，最后定位为 `.env.staging` 文件名写成了 `.env.stage`——正是“检查文件名是否正确、修改后是否重启开发服务器、是否在正确 mode 下运行”这几条排查口诀里最朴素的一条。

---

## 第 8 站：TypeScript 与 CSS——Vite 只转译，不负责类型检查

白屏事故复盘后，方蕾又抛出一个反直觉的知识点：“Vite 能直接处理 `.ts` 和 `.tsx`——”

```ts
interface User {
  id: number
  name: string
}

const user: User = {
  id: 1,
  name: 'Vite',
}
```

“——但必须理解：**Vite 的转换过程不会替你完成完整的 TypeScript 类型检查**。原因是：转译可以逐文件完成，类型检查需要分析整个类型关系图，把全量类型检查放进热更新链路会拖慢反馈速度。”

所以推荐脚本把两件事分开：

```js
{
  "scripts": {
    "dev": "vite",
    "typecheck": "tsc --noEmit",
    "build": "npm run typecheck && vite build"
  }
}
```

开发时可以单独监听 `tsc --noEmit --watch`。两个配套习惯：用 `import type { User } from './types'` 明确告诉工具链“这个导入只用于类型，不应进入运行时代码”；启用 `isolatedModules: true`，适配 Vite 以单文件方式工作的 TS 转换。

CSS 方面，Vite 可以直接 `import './style.css'`，开发阶段注入页面并支持 HMR。**CSS Modules** 以 `.module.css` 命名：

```css
.primary {
  color: white;
  background: #646cff;
}
```

```js
import styles from './button.module.css'

export function Button() {
  return <button className={styles.primary}>保存</button>
}
```

Vue 中也可以用 `<style module>` 使用模块化样式。Sass、Less、Stylus 内置了预处理器接入能力，但仍需安装对应编译器（`npm add -D sass-embedded`、`npm add -D less`、`npm add -D stylus`），然后直接使用：

```scss
// style.scss
$primary: #646cff;

.button {
  color: $primary;
}
```

PostCSS 只要项目中存在 `postcss.config.js` 就会自动应用：

```js
export default {
  plugins: {
    autoprefixer: {},
  },
}
```

“还有一个 Vite 8 的新变化要记住：**生产 CSS 默认由 Lightning CSS 压缩**。PostCSS 仍可负责其他转换；CSS 压缩器与 CSS 转换流程不是完全相同的概念；升级 Vite 后应检查极端 CSS 写法和浏览器兼容性。”

静态资源处理是周屿这周的另一个收获。通过 import 导入：

```js
import logoUrl from './assets/logo.png'

const img = document.createElement('img')
img.src = logoUrl
```

生产构建时，Vite 会计算哈希、生成最终 URL、根据配置决定是否内联、自动更新引用关系。需要基于当前模块位置计算 URL 时用 `new URL()` 写法：

```js
const iconUrl = new URL('./assets/icon.svg', import.meta.url).href
```

查询后缀提供三种特殊导入：`?url` 作为 URL 导入、`?raw` 作为文本导入、`?worker` 作为 Worker 导入：

```js
import shaderUrl from './shader.glsl?url'
import source from './shader.glsl?raw'
import WorkerConstructor from './worker.ts?worker'

const worker = new WorkerConstructor()
```

`public` 目录的文件直接按根路径访问——“`/favicon.ico`、`/config.json`，**不要写** `/public/favicon.ico`。`public` 中的文件不会获得内容哈希，因此适合必须保留固定文件名的文件、HTML 外部系统会直接访问的文件、不需要参与模块图的资源。业务图片通常更适合放在 `src/assets` 并通过 `import` 引用，以获得哈希和依赖追踪。”

## 第 9 站：Glob、动态导入与 Web Worker——把“重活”挪出首屏

中台首页首屏过慢，方蕾教了周屿三招。

**第一招，批量导入用 `import.meta.glob`。**它会转换为按需的动态导入映射：

```js
const modules = import.meta.glob('./pages/*.ts')
```

```js
const modules = {
  './pages/home.ts': () => import('./pages/home.ts'),
  './pages/about.ts': () => import('./pages/about.ts'),
}
```

常见用途：自动注册路由、扫描 Markdown 文章、批量加载图标、构建插件系统、自动收集组件、生成文档目录。同步加载加 `eager: true`，只导入默认导出加 `import: 'default'`：

```js
const modules = import.meta.glob('./modules/*.ts', {
  eager: true,
})

const modules = import.meta.glob('./modules/*.ts', {
  import: 'default',
  eager: true,
})
```

“三条注意：Glob 参数必须是字面量；不能把任意变量直接传进去；这是 Vite 特性，不是浏览器标准。”

**第二招，路由懒加载——控制首屏体积最有效的手段之一：**

```js
// React
import { lazy } from 'react'

const SettingsPage = lazy(() => import('./pages/SettingsPage'))
```

```js
// Vue Router
const routes = [
  {
    path: '/settings',
    component: () => import('@/pages/SettingsPage.vue'),
  },
]
```

**第三招，重活交给 Web Worker。**标准推荐写法：

```js
const worker = new Worker(
  new URL('./worker.ts', import.meta.url),
  { type: 'module' },
)
```

主线程与 Worker 通过消息通信：

```js
worker.postMessage({ numbers: [1, 2, 3, 4] })

worker.onmessage = (event) => {
  console.log(event.data)
}
```

```js
self.onmessage = (event) => {
  const numbers: number[] = event.data.numbers
  const sum = numbers.reduce((a, b) => a + b, 0)
  self.postMessage({ sum })
}
```

适合放入 Worker 的任务：大规模数据计算、图像处理、压缩和解压、加密、文本解析、复杂排序、不需要直接操作 DOM 的 CPU 密集任务。“记住：Worker 不能直接访问 DOM。”方蕾说，“JSON 也能直接导入，甚至可以只导入顶层字段：`import config from './config.json'`、`import { version } from './package-info.json'`。”

---

## 第 10 站：插件系统——从使用者到扩展者

第三周，周屿开始啃插件体系。“Vite 的扩展能力来自插件。”安装并使用一个插件：

```bash
npm add -D @vitejs/plugin-legacy
```

```js
import { defineConfig } from 'vite'
import legacy from '@vitejs/plugin-legacy'

export default defineConfig({
  plugins: [
    legacy({
      targets: ['defaults', 'not IE 11'],
    }),
  ],
})
```

插件生态覆盖：框架插件（React、Vue）、SVG 组件插件、PWA 插件、Mock 插件、自动导入插件、路由生成插件、Markdown 转换插件、Bundle 分析插件、错误检查插件、国际化资源插件。

插件可以指定执行顺序 `enforce: 'pre'` 或 `enforce: 'post'`，粗略的执行链是：

```text
pre 插件
  ↓
Vite 核心插件
  ↓
普通插件
  ↓
构建相关插件
  ↓
post 插件
```

也可以按命令生效——`apply: 'build'`、`apply: 'serve'`，或用函数：

```js
{
  apply(config, { command }) {
    return command === 'build'
  }
}
```

**动手写第一个插件**——把 `.txt` 文件转换成 JavaScript 模块：

```js
import fs from 'node:fs/promises'
import type { Plugin } from 'vite'

function textLoader(): Plugin {
  return {
    name: 'vite-plugin-text-loader',

    enforce: 'pre',

    async load(id) {
      if (!id.endsWith('.txt')) return null

      const text = await fs.readFile(id, 'utf-8')

      return {
        code: `export default ${JSON.stringify(text)}`,
        moduleType: 'js',
      }
    },
  }
}
```

使用它之后，业务代码就能直接 `import article from './article.txt'`。

常用插件钩子一览：

```text
config              修改用户配置
configResolved      读取最终配置
configureServer     扩展开发服务器
resolveId           自定义模块解析
load                自定义模块加载
transform           转换模块代码
transformIndexHtml  转换 HTML
handleHotUpdate     自定义热更新
buildStart          构建开始
generateBundle      生成产物
closeBundle         构建结束
```

进阶形态是**虚拟模块插件**——在内存里“造”出一个模块：

```js
import type { Plugin } from 'vite'

function appInfoPlugin(): Plugin {
  const virtualId = 'virtual:app-info'
  const resolvedId = '\0' + virtualId

  return {
    name: 'vite-plugin-app-info',

    resolveId(id) {
      if (id === virtualId) {
        return resolvedId
      }
    },

    load(id) {
      if (id === resolvedId) {
        return [
          'export const buildTime = ' + JSON.stringify(new Date().toISOString()),
          "export const appName = 'Vite Demo'",
        ].join('\n')
      }
    },
  }
}
```

业务代码直接 `import { appName, buildTime } from 'virtual:app-info'`。“\0 前缀表示内部虚拟模块，避免被其他解析流程当成真实文件路径。”方蕾说，“框架插件处理 HMR 通常已经够用，普通业务代码不需要手写。但在自定义模块或插件中，可以用 HMR API：”

```js
if (import.meta.hot) {
  import.meta.hot.accept((newModule) => {
    console.log('模块已更新', newModule)
  })
}
```

清理旧副作用：

```js
if (import.meta.hot) {
  import.meta.hot.dispose(() => {
    console.log('清理定时器、监听器或连接')
  })
}
```

保存热更新数据：

```js
if (import.meta.hot) {
  import.meta.hot.data.count ??= 0
  import.meta.hot.data.count++
}
```

“当 HMR 退化成整页刷新时，常见原因包括：没有可接受该更新的 HMR 边界、模块存在循环依赖、插件没有正确实现 HMR、模块副作用无法安全替换、框架 Fast Refresh 规则被破坏。执行 `vite --debug hmr`，可以定位循环依赖和更新传播路径。”

## 第 11 站：生产构建与分包——把产物变成可部署的资产

第四周进入构建篇。执行 `npm run build`，默认以项目根目录的 `index.html` 为入口，输出到 `dist`：

```text
dist/
├── index.html
└── assets/
    ├── index-D8x9s2.js
    ├── index-A7m2p1.css
    └── logo-K3d8a1.svg
```

“哈希文件名的好处：内容变化，文件名变化；内容未变化，文件名保持；可以对静态资源设置长期缓存；避免用户拿到旧版本资源。”

**基础路径**按部署位置配置：

```js
export default defineConfig({ base: '/' })        // 域名根目录
export default defineConfig({ base: '/my-app/' }) // https://example.com/my-app/
export default defineConfig({ base: './' })       // 路径未知或相对路径
```

**Source Map** 的三种策略：“浏览器可直接访问用 `true`；仅上传到监控平台用 `hidden`；正式环境关闭用 `false`。是否上传，应结合 Sentry 等错误监控平台和公司的源码安全策略。”**构建目标**用 `target: 'baseline-widely-available'`；需要更老浏览器时设更低目标并配合 `@vitejs/plugin-legacy`——“注意语法转换不等于全部 API Polyfill，新 API 是否可用仍需根据目标浏览器补充。”

**大 Chunk 警告**不是“构建失败”，而是提醒你检查：是否缺少路由懒加载、是否把大型编辑器/图表库放进首屏、是否重复引入同一依赖、是否错误导入完整图标库、是否把大 JSON 直接打入 Bundle、是否存在无法 Tree Shaking 的模块。

分包的正确姿势，方蕾总结了五条。**第一，先做路由级拆分**——“这是收益最大、风险最低的分包方式”：

```js
const ReportPage = () => import('./pages/ReportPage.vue')
// 或 React：
const ReportPage = lazy(() => import('./pages/ReportPage'))
```

**第二，延迟加载重型功能**——富文本编辑器这类，只有用户真正打开时才下载：

```js
async function openEditor() {
  const { createEditor } = await import('./editor')
  createEditor()
}
```

**第三，避免错误的“全量导入”**——不推荐 `import * as icons from 'some-icon-library'`，优先按需 `import { SearchIcon, UserIcon } from 'some-icon-library'`；但最终能否 Tree Shaking，还取决于目标库的模块格式和 `sideEffects` 声明。

**第四，不要把所有依赖强行拆成独立 Chunk**。过度分包会造成请求数量增加、依赖关系复杂、缓存命中不稳定、首屏瀑布流变长、部署版本切换时更容易出现旧 Chunk 加载失败。“分包目标不是‘文件越小越好’，而是在加载性能、缓存复用、请求数量和更新频率之间取得平衡。”

**第五，Vite 8 的底层分包配置**变了名字：

```js
build: {
  rolldownOptions: {
    output: {
      // 根据项目需要配置 codeSplitting
    },
  },
}
```

“旧项目中的 `build.rollupOptions` 已改名为 `build.rolldownOptions`，旧的 `manualChunks` 用法也应根据 Rolldown 的 `codeSplitting` 能力逐步迁移。**在没有明确性能数据前，不建议复制来源不明的分包模板。**”

---

## 第 12 站：依赖预构建、多页应用与库模式

第四周后半段，方蕾把三类“特殊形态”一次讲完。

**依赖预构建与 optimizeDeps。**“大多数项目不需要手动配置。但以下情况可能需要：依赖没有被自动扫描到、依赖通过插件或运行时动态引入、Monorepo 中链接包频繁变化、某依赖包含异常 CommonJS、开发阶段频繁触发重新优化。”强制包含与排除：

```js
export default defineConfig({
  optimizeDeps: {
    include: ['some-dep'],
  },
})

export default defineConfig({
  optimizeDeps: {
    exclude: ['local-linked-package'],
  },
})
```

缓存异常时：

```bash
rm -rf node_modules/.vite
npm run dev -- --force
```

“但不要把‘删除缓存’当作永久解决方案。更重要的是确认：锁文件是否变化、依赖是否存在多版本、软链接包的 `exports` 是否正确、包是否发布了合法 ESM/CJS 入口、插件是否在运行时改变依赖图。”

**多页应用。**“Vite 不只支持 SPA。目录里放多个 `index.html`：”

```text
project/
├── index.html
├── admin/
│   └── index.html
├── docs/
│   └── index.html
└── vite.config.ts
```

```js
import { resolve } from 'node:path'
import { defineConfig } from 'vite'

export default defineConfig({
  build: {
    rolldownOptions: {
      input: {
        main: resolve(import.meta.dirname, 'index.html'),
        admin: resolve(import.meta.dirname, 'admin/index.html'),
        docs: resolve(import.meta.dirname, 'docs/index.html'),
      },
    },
  },
})
```

适用场景：官网与后台共用仓库、多个独立活动页、传统服务端项目的多个前端入口、不需要前端路由的多页面站点、微前端子应用入口。兼容较旧 Node.js 写法可以用 `fileURLToPath(import.meta.url)` 推导 `__dirname`。

**库模式。**“Vite 可以构建浏览器端组件库：”

```js
import { resolve } from 'node:path'
import { defineConfig } from 'vite'

export default defineConfig({
  build: {
    lib: {
      entry: resolve(import.meta.dirname, 'src/index.ts'),
      name: 'MyLibrary',
      fileName: 'my-library',
    },

    rolldownOptions: {
      external: ['react', 'react-dom'],
      output: {
        globals: {
          react: 'React',
          'react-dom': 'ReactDOM',
        },
      },
    },
  },
})
```

“为什么要 `external`？组件库通常不应把 React 或 Vue 再打包一份，否则消费者项目可能出现 Bundle 体积增大、React 多实例、Hook 调用异常、Vue 响应式对象跨实例不兼容、依赖版本冲突。”`package.json` 用 `peerDependencies` 声明宿主框架：

```js
{
  “name”: “@example/ui”,
  “version”: “1.0.0”,
  “type”: “module”,
  “files”: [“dist”],
  “main”: “./dist/my-library.umd.cjs”,
  “module”: “./dist/my-library.js”,
  “types”: “./dist/index.d.ts”,
  “peerDependencies”: {
    “react”: “^18.0.0 || ^19.0.0”,
    “react-dom”: “^18.0.0 || ^19.0.0”
  }
}
```

“注意：Vite 可以构建 JavaScript 和 CSS，但 TypeScript 声明文件通常需要额外工具生成——`tsc --emitDeclarationOnly`、专门的 DTS 插件、`tsdown`、API Extractor 等。如果是 Node.js 库或复杂多格式库，直接用 Rolldown、tsdown 可能更合适。”

**SSR 与后端集成**，方蕾只讲了原理层。SSR 的链路是：浏览器请求页面 → Node.js 服务端执行组件 → 生成 HTML → 浏览器显示内容 → 客户端 Hydration 接管交互。典型目录分 `entry-client.ts`（挂载或 Hydration）和 `entry-server.ts`（返回 HTML），用 `import.meta.env.SSR` 判断运行环境。但“对于业务应用，通常更推荐成熟上层框架——React Router/Remix 类、Nuxt、SvelteKit、Astro、SolidStart。完整 SSR 还涉及路由、数据预取、Head 管理、Streaming、Hydration、错误边界、静态生成、缓存、部署和代码隔离。**Vite 提供底层能力，上层框架负责完整应用模型。**”

传统后端（Spring Boot、Laravel、Rails、Django、ASP.NET、Go、PHP）接入 Vite 则是另一条路：开发阶段后端管模板、接口、认证，Vite 管 JS、CSS、HMR；生产阶段开启 `build: { manifest: true }`，后端读取 `manifest.json` 找到带哈希的 JS/CSS 地址——“既能保留后端模板系统，又能获得 Vite 的开发体验和生产优化。”

## 第 13 站：部署——白屏、404 与缓存的三堂课

第五周是部署周，方蕾把生产环境最容易翻车的三件事搬进了课堂。

**第一课：SPA 刷新 404。**前端路由用 History 模式时，访问 `https://example.com/users/123`，服务器会找真实文件 `/users/123`，找不到就 404。Nginx 应配置回退：

```nginx
server {
    listen 80;
    server_name example.com;

    root /var/www/app/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /assets/ {
        try_files $uri =404;
        expires 1y;
        add_header Cache-Control “public, immutable”;
    }
}
```

**第二课：缓存策略。**“`index.html` 用 `Cache-Control: no-cache`；带哈希资源用 `public, max-age=31536000, immutable`。为什么 HTML 不应长期缓存？**因为 HTML 中记录了最新资源文件名**。若 HTML 被长期缓存，用户可能继续请求已被删除的旧 Chunk。”

**第三课：新旧版本 Chunk 加载失败。**用户长时间停留在旧页面，网站发布新版本并删除旧文件后，动态导入可能失败。可以监听：

```js
window.addEventListener('vite:preloadError', (event) => {
  event.preventDefault()
  window.location.reload()
})
```

更稳妥的发布策略：保留上一版本静态资源一段时间、使用不可变版本目录、HTML 不缓存、CDN 原子发布、在刷新前提示用户保存未提交内容。

构建产物 `dist/` 可以部署到 Nginx、CDN、对象存储、GitHub Pages、Cloudflare Pages、Netlify、Vercel 等静态托管平台。“白屏排查清单也背下来：`base` 配置错误、直接双击 `dist/index.html`、静态服务器 MIME 类型不对、路由回退缺失、资源部署路径与 HTML 不一致、CDN 缓存了旧 HTML。**不要用 `file://` 直接验证生产构建**，应执行 `npm run preview` 或用真实 HTTP 静态服务器。”

---

## 第 14 站：开发性能与 Monorepo——大项目的生存指南

“Vite 默认很快，但大型项目仍可能变慢。”方蕾给出了开发侧的四张处方。

**第一，检查浏览器。**大型项目中浏览器扩展会拦截大量模块请求——用无扩展的开发专用配置、隐私窗口，并检查 DevTools 是否勾选了 Disable Cache。

**第二，审计插件。**慢插件的典型表现：`config` 钩子执行大量 I/O、`buildStart` 扫描整个仓库、每次 `transform` 都解析所有文件、没有过滤 `node_modules`、同步读取大文件、开发阶段执行只应在构建阶段执行的任务。给 `transform` 加过滤：

```js
transform(code, id) {
  if (!id.endsWith('.custom')) return null
  // 只处理目标文件
}
```

**第三，减少配置文件启动成本。**`vite.config.ts` 在服务器启动时执行，避免在顶层 `import hugePackage from 'huge-package'`，可以按需动态导入 `const module = await import('huge-package')`。

**第四，避免“桶文件”扩大更新范围。**大量从统一入口 `import { Button } from '@/components'` 导入时，模块边界可能扩大——关键页面直接 `import { Button } from '@/components/Button'`。大型依赖（图表库、地图库、富文本编辑器、Office 解析器、PDF 处理、代码编辑器、机器学习运行时、日期国际化数据）应尽量动态导入、按功能加载、放入 Worker、使用轻量替代、避免进入首屏。

Monorepo 场景下（`apps/` + `packages/` 的 pnpm workspace），工作区包直接导入源码 `import { Button } from '@repo/ui'`，需要关注四件事：包的 `exports` 要正确（`“.”: “./src/index.ts”`）；避免同一依赖多实例——React、Vue 由工作区统一版本管理，必要时 `resolve: { dedupe: ['react', 'react-dom'] }`；软链接包可能被视为源码参与转换，如果包本身包含 JSX、装饰器、非标准语法，要确认消费端 Vite 配置能正确处理；共享配置用 `packages/vite-config` 导出基础配置，各应用用 `mergeConfig` 扩展——“共享配置应保持适度，避免所有应用被一个巨大配置强耦合。”

测试方面，Vitest 与 Vite 共享解析和转换能力，适合 Vite 项目。安装 `npm add -D vitest`，脚本配 `test`、`test:run`、`test:coverage`：

```js
import { describe, expect, it } from 'vitest'
import { add } from './math'

describe('add', () => {
  it('adds two numbers', () => {
    expect(add(2, 3)).toBe(5)
  })
})
```

浏览器组件测试通常还需要 `jsdom` 或 `happy-dom`、React Testing Library 或 Vue Test Utils。“不要因为 Vitest 与 Vite 关系紧密，就把所有测试配置都塞进 Vite 配置。大型项目可以使用独立 `vitest.config.ts`，保持职责清晰。”

## 第 15 站：期末大考——把中台迁移到 Vite 8

第六周，期末作业来了。方蕾给了两份迁移指南和一份升级清单。

**从 CRA 迁移的七步：**安装 `vite @vitejs/plugin-react`；添加最小配置；把 HTML 从 `public/index.html` 移到项目根目录并用 `<script type=“module” src=“/src/main.tsx”>` 作入口；环境变量从 `process.env.REACT_APP_API_URL` 改成 `import.meta.env.VITE_API_URL`；静态资源路径从 `process.env.PUBLIC_URL` 改用 `import.meta.env.BASE_URL` 或直接模块导入；替换脚本（`“build”: “tsc --noEmit && vite build”`）；检查浏览器代码中不要默认依赖 `process`、`Buffer`、`global`、`__dirname`——“Vite 不会无条件为浏览器自动注入 Node.js Polyfill，应优先改用浏览器 API、替换依赖，仅在确有必要时安装明确的 Polyfill 插件。”

**从 Webpack 迁移，不要机械翻译每一项配置，先分类。**可以直接删除的（Vite 已内置）：CSS 导入、TypeScript/JSX 基础转译、静态资源 URL、CSS Modules、JSON 导入、开发服务器、HMR、HTML 入口、动态导入。需要重新实现的：自定义 Loader（对应 Vite `transform/load` 插件钩子）、特殊虚拟模块、复杂 DefinePlugin（对应 `define` / `import.meta.env`）、自定义 devServer 中间件（对应 `server.proxy`）、多入口、特殊资源输出、Module Federation、自定义编译宏、非标准语言转换。迁移顺序十步：先创建最小 Vite 入口 → 让核心页面运行 → 迁移路径别名 → 迁移环境变量 → 迁移 CSS 和静态资源 → 迁移代理 → 迁移特殊 Loader → 迁移生产构建 → 对比产物 → 最后删除 Webpack 配置。

**Vite 8 升级的五个注意点：**`build.rollupOptions` 已改名 `build.rolldownOptions`（新项目用新名称）；Oxc 承担更多 JS/TS 处理，插件若直接调用旧的 esbuild 转换 API 需检查兼容性；生产 CSS 默认改由 Lightning CSS 压缩，升级后重点测试新 CSS 语法、浏览器目标、CSS Modules、前缀和第三方组件库样式；CJS 默认导入行为更一致，遇到历史包异常应检查真实导出结构而不是盲目加兼容插件；升级前跑 `npm out dated`，按“Node.js → Vite → 框架官方插件 → 测试工具 → 第三方插件 → 自研插件”的顺序升级。

周屿的迁移报告交上去了：启动从四分半降到九秒，HMR 毫秒级，构建产物小了 38%。答辩时方蕾只问了一个问题：“构建内存过高怎么办？”他答了排查清单——超大 Source Map、超大 JSON、图片被转 Base64、插件保留所有 AST、重复依赖、一次性生成大量页面、压缩器参数、机器 Node 内存限制——“可临时 `NODE_OPTIONS=--max-old-space-size=8192 vite build`，但这只是缓解，最终仍应找到高内存来源。”

## 第 16 站：工程收束——项目结构、排查手册与学习路线

迁移完成后，周屿把六周的笔记整理成了三份“团队资产”。

**第一份：推荐项目结构。**中大型项目按业务域组织：

```text
src/
├── api/
├── assets/
├── components/
│   ├── base/
│   └── business/
├── composables/
├── config/
├── features/
│   ├── auth/
│   ├── orders/
│   └── users/
├── layouts/
├── pages/
├── router/
├── stores/
├── styles/
├── types/
├── utils/
├── App.tsx
└── main.tsx
```

原则：通用组件与业务组件分开（`components/base/Button`、`components/business/OrderCard`）；按业务域组织复杂功能（`features/orders/` 内含 `api.ts`、`components/`、`hooks.ts`、`types.ts`、`index.ts`）；不要让 `utils` 变成垃圾场，按领域拆成 `utils/date.ts`、`utils/currency.ts`、`utils/validation.ts`；环境配置统一封装，业务代码不到处直接读 `import.meta.env`：

```ts
// src/config/env.ts
function required(name: keyof ImportMetaEnv): string {
  const value = import.meta.env[name]

  if (!value) {
    throw new Error(`Missing environment variable: ${name}`)
  }

  return value
}

export const env = {
  apiBaseUrl: required('VITE_API_BASE_URL'),
  appTitle: import.meta.env.VITE_APP_TITLE || 'Vite App',
}
```

**第二份：工程质量脚本与排查手册。**

```js
{
  “scripts”: {
    “dev”: “vite”,
    “build”: “npm run check && vite build”,
    “preview”: “vite preview”,
    “typecheck”: “tsc --noEmit”,
    “lint”: “eslint .”,
    “lint:fix”: “eslint . --fix”,
    “test”: “vitest”,
    “test:run”: “vitest run”,
    “check”: “npm run typecheck && npm run lint && npm run test:run”
  }
}
```

CI 流水线：安装依赖 → 类型检查 → Lint → 单元测试 → 生产构建 → 端到端测试 → 发布。“Vite 只负责其中的开发和构建部分，不应把所有质量职责都塞进 Vite 插件链。”

排查手册浓缩成十条速查：启动后页面空白——查控制台错误、入口路径、根节点 ID、路由基础路径、环境变量是否 `undefined`、依赖是否用了 Node API；构建后白屏——查 `base`、`file://` 验证、MIME 类型、路由回退、CDN 旧 HTML；环境变量读不到——查 `VITE_` 前缀、文件名、是否重启、是否正确 mode；代理不生效——查相对路径、是否只在开发阶段生效、`rewrite`、WebSocket `ws: true`；修改依赖不生效——`vite --force` 或删缓存后查根因；HMR 变整页刷新——查循环依赖、顶层副作用、Fast Refresh 边界；`process is not defined`——浏览器不是 Node.js，改用 `import.meta.env`；动态导入构建失败——路径模式要可静态分析，复杂场景用 `import.meta.glob('./pages/**/*.ts')`；端口自动变化导致回调失败——`strictPort: true`；构建内存过高——按上面清单排查。

**第三份：学习路线。**五个阶段：**会启动**（创建项目、dev/build/preview、index.html、src 与 public、框架基础插件——目标：能独立运行项目）；**会配置**（vite.config.ts、alias、proxy、base、env 和 mode、CSS Modules、静态资源——目标：能搭建真实业务项目）；**懂构建**（原生 ESM、依赖预构建、HMR、模块图、Tree Shaking、动态导入、Chunk、缓存策略——目标：遇到性能和部署问题时能解释原因）；**会扩展**（插件钩子、虚拟模块、HTML 转换、自定义 Loader、HMR API、Dev Server 中间件——目标：能开发内部工程插件）；**会做架构**（Monorepo、库模式、多页应用、SSR、后端集成、CI/CD、CDN 缓存、版本迁移、构建性能分析——目标：能为团队制定前端工程方案）。

## 尾声：四分半 → 九秒

迁移上线的那个周一早会，方蕾把六周前和六周后的两组数字投在了大屏上：冷启动 4 分 31 秒 → 9.2 秒；HMR 平均 11 秒 → 200 毫秒；构建产物 47MB → 29MB。会议室安静了两秒，然后响起一片掌声。

散会后周屿在自己的笔记本扉页写下了一段话，作为这段修行的总结：

> Vite 的价值，不只是“启动快”。它代表了一种现代前端工程思路：开发阶段按需处理，而不是提前完成所有工作；把热更新限制在最小影响范围；让浏览器原生能力参与开发流程；将构建、类型检查、测试和代码规范解耦；用插件扩展特殊需求，而不是让核心配置无限膨胀；在生产阶段重新进行完整优化，以获得可部署的资源。

入门 Vite，只需要几分钟。掌握 Vite，需要理解配置。精通 Vite，则需要理解模块、浏览器、编译器、构建器、缓存和部署之间的完整关系。

> 当你能够从一条报错反推出它属于“模块解析、转换、预构建、HMR、生产分包还是部署缓存”时，Vite 就不再是一个黑盒命令，而会成为你真正掌控的工程工具。

青崖科技的故事告一段落，但你的故事才刚刚开始。打开终端，敲下 `npm create vite@latest` 吧。

---

## 官方资料与延伸阅读

- Vite 官方网站：https://vite.dev/
- Vite 入门指南：https://vite.dev/guide/
- Vite 功能指南：https://vite.dev/guide/features
- Vite 配置参考：https://vite.dev/config/
- 环境变量与模式：https://vite.dev/guide/env-and-mode
- 生产构建：https://vite.dev/guide/build
- 插件 API：https://vite.dev/guide/api-plugin
- 服务端渲染 SSR：https://vite.dev/guide/ssr
- 性能优化指南：https://vite.dev/guide/performance
- Vite 8 发布说明：https://vite.dev/blog/announcing-vite8
- 从 Vite 7 迁移到 Vite 8：https://vite.dev/guide/migration

> 版本提示：本文以 Vite 8（Rolldown + Oxc 工具链）为基线。Vite 迭代较快，实际使用时请以官方文档的最新说明为准。

