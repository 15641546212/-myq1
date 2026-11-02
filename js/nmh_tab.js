/* ============================================================
   作者：倪铭浩
   建立时间：2026-11-02 13:39
   使用模型：GLM-5.3-Flash
   功能名称及简介：nmh_tab.js —— 可复用的 Tab 选项卡组件
   说明：
     - 对外暴露 nmh_initTabs(选项卡容器id, 面板容器id) 一个工厂函数
     - 任何页面只要按约定写好选项卡按钮（带 data-nmh-tab 属性）
       与同数量的面板，即可调用本函数复用整套切换逻辑
     - 核心思路：事件监听（事件委托）→ 先清除所有选项卡的
       选中状态 → 再设置当前元素的选中状态
   ============================================================ */
"use strict";

/**
 * 作者：倪铭浩 | 建立时间：2026-11-02 13:39 | 使用模型：GLM-5.3-Flash
 * 功能：nmh_initTabs —— 初始化一组选项卡（可复用入口）
 * @param {string} nmh_tabBoxId   选项卡按钮容器 id
 * @param {string} nmh_panelBoxId 内容面板容器 id（子元素顺序与按钮一一对应）
 * @returns {{nmh_switchTo: Function}} 返回切换接口，供外部编程式控制
 */
function nmh_initTabs(nmh_tabBoxId, nmh_panelBoxId) {
  var nmh_tabBox = document.getElementById(nmh_tabBoxId);
  var nmh_panelBox = document.getElementById(nmh_panelBoxId);
  var nmh_tabs = nmh_tabBox.querySelectorAll("[data-nmh-tab]");
  var nmh_panels = nmh_panelBox.children;

  /**
   * 作者：倪铭浩 | 建立时间：2026-11-02 13:39 | 使用模型：GLM-5.3-Flash
   * 功能：nmh_clearActive —— 清除所有选项卡与面板的选中状态（移除 nmh_active 类）
   */
  function nmh_clearActive() {
    var nmh_i;
    for (nmh_i = 0; nmh_i < nmh_tabs.length; nmh_i++) {
      nmh_tabs[nmh_i].classList.remove("nmh_active");
    }
    for (nmh_i = 0; nmh_i < nmh_panels.length; nmh_i++) {
      nmh_panels[nmh_i].classList.remove("nmh_active");
    }
  }

  /**
   * 作者：倪铭浩 | 建立时间：2026-11-02 13:39 | 使用模型：GLM-5.3-Flash
   * 功能：nmh_setActive —— 设置第 nmh_index 个选项卡与对应面板为选中状态
   */
  function nmh_setActive(nmh_index) {
    nmh_tabs[nmh_index].classList.add("nmh_active");
    nmh_panels[nmh_index].classList.add("nmh_active");
  }

  /**
   * 作者：倪铭浩 | 建立时间：2026-11-02 13:39 | 使用模型：GLM-5.3-Flash
   * 功能：nmh_switchTo —— 切换到第 nmh_index 个选项卡
   *       核心模式：先清除所有选中状态，再设置当前元素的选中状态
   */
  function nmh_switchTo(nmh_index) {
    nmh_clearActive();
    nmh_setActive(nmh_index);
  }

  /* 事件监听（事件委托）：点击容器内任意 [data-nmh-tab] 按钮即触发切换 */
  nmh_tabBox.addEventListener("click", function (nmh_e) {
    var nmh_btn = nmh_e.target.closest("[data-nmh-tab]");
    if (!nmh_btn) { return; }                       // 点在按钮以外不处理
    nmh_switchTo(Number(nmh_btn.getAttribute("data-nmh-tab")));
  });

  /* 初始化：默认选中第 0 个选项卡（国内新闻） */
  nmh_switchTo(0);

  /* 返回接口，供外部（如自动轮播、键盘导航）复用 */
  return { nmh_switchTo: nmh_switchTo };
}
