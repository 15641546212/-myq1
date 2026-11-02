# 项目开发规则（Project Rules）

> 本文件是所有 Agent 会话必须遵守的长期约束。执行任何编码/构建任务前先查阅本文件。

---

## 规则 1：命名前缀 `wy_`

所有 **CSS 类名 / ID、JavaScript 变量、函数、对象属性** 必须以 `wy_` 开头。

### 适用

| 场景 | 正确 | 错误 |
|------|------|------|
| CSS 类 | `.wy_module { }` | `.module { }` |
| CSS ID | `#wy_main { }` | `#main { }` |
| JS 变量 | `let wy_count = 0` | `let count = 0` |
| JS 函数 | `function wy_render() { }` | `function render() { }` |
| JS 对象属性 | `wy_config.wy_theme` | `config.theme` |
| HTML class | `class="wy_header wy_active"` | `class="header active"` |
| HTML id | `id="wy_nav"` | `id="nav"` |

### 不适用

- 第三方库 API（如 `axios.get()`、`React.useState()`）
- 浏览器内置全局对象（如 `document`、`window`、`console`）
- HTML 标签名（如 `<div>`、`<span>`）
- HTML 标准属性名（如 `class`、`id`、`href` 本身）

---

## 规则 2：提示词日志 `wy_prompt.md`

**每次执行用户提示词之前**，必须先将提示词追加写入项目根目录的 `wy_prompt.md`。

### 写入格式

```
---
时间：YYYY-MM-DD HH:mm:ss
模型：Trae
提示词：
<用户原始提示词原文>
```

### 行为守则

1. **先写后做** — 写入必须发生在任何读取文件 / 执行命令 / 编辑代码之前
2. **追加不覆盖** — 使用 append 模式，保留全部历史
3. **时间格式** — 使用本地时区 Asia/Shanghai，格式 `yyyy-MM-dd HH:mm:ss`
4. **原文照录** — 提示词字段原样拷贝用户输入，不做改写或总结

### 示例

```
---
时间：2026-11-02 15:30:00
模型：Trae
提示词：
提交到github
---
时间：2026-11-02 16:05:22
模型：Trae
提示词：
创建一个带轮播图的首页
```

---

## 规则 3：新建 HTML 必须含首页超链接

本项目中**所有新建的 HTML 文件**，必须在页面显著位置加入跳转到 `index.html` 的超链接。

### 实现要求

- **链接文本**：「返回首页」或「回到首页」
- **链接路径**：根据文件层级使用 `./index.html` 或 `../index.html`
- **摆放位置**：页面顶部导航栏 或 底部页脚（用户一眼可见）
- **已有导航则跳过**：若新建页面已有统一导航栏且导航栏中已包含首页链接，无需重复添加

### 最简写法

```html
<a href="./index.html" class="wy_back-home">返回首页</a>
```

### 例外（不需要加）

| 情况 | 原因 |
|------|------|
| `index.html` 自身 | 它就是首页 |
| 纯 iframe / 模板片段 | 不直接对用户展示 |
| 由主页面 `include` 的局部片段 | 主页面已含首页链接 |

---

## 规则总览

| # | 触发时机 | 核心动作 |
|---|---------|---------|
| 1 | 写 CSS / JS / HTML 标识符时 | 所有类名、ID、变量、函数以 `wy_` 开头 |
| 2 | 收到每条用户提示词时 | 先追加写入 `wy_prompt.md` 再执行 |
| 3 | 创建新 HTML 文件时 | 必须包含 `index.html` 的返回链接 |
