# AGENTS.md

> 语言约定：本文件所有说明、检查条目统一使用简体中文；文件路径、HTML/CSS/JS 标识符保留英文原文。

## 项目类型
- 纯静态站点：HTML/CSS/JS，无构建工具、无 package.json
- 入口：`index.html`（练习目录页）
- 倪铭浩的中文课程存档项目

## 目录结构（关键文件）
- `index.html` —— 主目录页，链接各练习
- `html_basic001.html`、`html_self.html` —— HTML 基础 / 个人简介
- `stack004.*`、`picture_above004.*`、`layout004.*`、`grid.html` —— CSS 布局练习
- `css3.*` —— CSS3 选择器与动画
- `svg004.*` —— SVG 图标与导航
- `starter-level1-0611nmh.html`、`starter-level2-0611nmh.html` —— 成绩面板实战（等级一/二）
- `data.js`、`js_obj_fun.html` —— JS 数据与对象函数练习
- `cdn/`、`font/`、`img/`、`iconfont-*` —— 静态资源与图标页面

## 开发约定
- 无安装/构建/检查/测试命令（没有 package.json），直接编辑仓库根目录下的文件
- 在浏览器打开 `index.html` 即可预览
- 全部使用本地资源，不引外部 CDN；`.gitignore` 相关说明见「注意事项」

## 通用规范
- 新增页面内容保持与现有页面一致的中文表述
- 新增练习时，同步更新 `index.html` 目录（练习计数 +1），样式与现有条目保持一致
- 保持资源路径不变（`css/`、`img/`、`font/`、`cdn/`）
- 所有 CSS 类名、id 名、JS 变量以 `nmh_` 开头
- 所有新建 HTML 文件必须包含回首页 `index.html` 的超链接（类名用 `nmh_home_link`）

## 注释规范（新建 HTML 文件时强制执行）
- 新建任何 `.html` 文件必须加入注释，**尤其是 `<script>` 中每个函数的主要功能实现**都要有注释
- 注释固定包含四项：**作者（倪铭浩）、建立时间（YYYY-MM-DD HH:mm）、使用模型、功能名称及简介**
- 文件头部示例：
  ```html
  <!--
    作者：倪铭浩
    建立时间：2026-11-02 13:27
    使用模型：GLM-5.3-Flash
    功能名称及简介：xxx 页面 —— 实现 xxx 交互/展示
  -->
  ```
- JS 函数注释示例：
  ```js
  /* 作者：倪铭浩 | 建立时间：2026-11-02 13:27 | 使用模型：GLM-5.3-Flash
     功能：renderStats —— 用 reduce/filter 计算班级总分、平均分与及格率并写入统计卡 */
  ```

## Git 与提示词日志
- 提示词在执行前以追加方式写入 `nmh_prompt.md`（含时间、模型、原文）；含敏感信息必须先脱敏
- 双仓库：`origin` → Gitee（skill：git-push-gitee），`github` → GitHub（skill：git-push-github）
- 禁止强制推送，除非用户明确授权重写历史

## 注意事项
- `.trae/skills/git-push-gitee/` 与 `.gitee-token.local` 已被 gitignore 忽略（内含令牌，禁止入库）
- 新增同类文件时沿用现有命名规则（如 `*-004.*`）

## 文档语言约定（2026-11-02 起强制执行）
- 本项目生成的所有文档、检查清单、说明条目统一使用简体中文
- 文件路径、HTML/CSS/JS 标识符、代码保留英文原文，不做翻译
