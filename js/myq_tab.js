/* ============================================================
   作者：马宇乾
   建立时间：2026-11-02 13:39
   使用模型：GLM-5.3-Flash
   功能名称及简介：myq_tab.js —— 可复用的 Tab 选项卡组件
   说明：
     - 对外暴露 myq_initTabs(选项卡容器id, 面板容器id) 一个工厂函数
     - 任何页面只要按约定写好选项卡按钮（带 data-myq-tab 属性）
       与同数量的面板，即可调用本函数复用整套切换逻辑
     - 核心思路：事件监听（事件委托）→ 先清除所有选项卡的
       选中状态 → 再设置当前元素的选中状态
   ============================================================ */
"use strict";

/**
 * 作者：马宇乾 | 建立时间：2026-11-02 13:39 | 使用模型：GLM-5.3-Flash
 * 功能：myq_initTabs —— 初始化一组选项卡（可复用入口）
 * @param {string} myq_tabBoxId   选项卡按钮容器 id
 * @param {string} myq_panelBoxId 内容面板容器 id（子元素顺序与按钮一一对应）
 * @returns {{myq_switchTo: Function}} 返回切换接口，供外部编程式控制
 */
function myq_initTabs(myq_tabBoxId, myq_panelBoxId) {
  var myq_tabBox = document.getElementById(myq_tabBoxId);
  var myq_panelBox = document.getElementById(myq_panelBoxId);
  var myq_tabs = myq_tabBox.querySelectorAll("[data-myq-tab]");
  var myq_panels = myq_panelBox.children;

  /**
   * 作者：马宇乾 | 建立时间：2026-11-02 13:39 | 使用模型：GLM-5.3-Flash
   * 功能：myq_clearActive —— 清除所有选项卡与面板的选中状态（移除 myq_active 类）
   */
  function myq_clearActive() {
    var myq_i;
    for (myq_i = 0; myq_i < myq_tabs.length; myq_i++) {
      myq_tabs[myq_i].classList.remove("myq_active");
    }
    for (myq_i = 0; myq_i < myq_panels.length; myq_i++) {
      myq_panels[myq_i].classList.remove("myq_active");
    }
  }

  /**
   * 作者：马宇乾 | 建立时间：2026-11-02 13:39 | 使用模型：GLM-5.3-Flash
   * 功能：myq_setActive —— 设置第 myq_index 个选项卡与对应面板为选中状态
   */
  function myq_setActive(myq_index) {
    myq_tabs[myq_index].classList.add("myq_active");
    myq_panels[myq_index].classList.add("myq_active");
  }

  /**
   * 作者：马宇乾 | 建立时间：2026-11-02 13:39 | 使用模型：GLM-5.3-Flash
   * 功能：myq_switchTo —— 切换到第 myq_index 个选项卡
   *       核心模式：先清除所有选中状态，再设置当前元素的选中状态
   */
  function myq_switchTo(myq_index) {
    myq_clearActive();
    myq_setActive(myq_index);
  }

  /* 事件监听（事件委托）：点击容器内任意 [data-myq-tab] 按钮即触发切换 */
  myq_tabBox.addEventListener("click", function (myq_e) {
    var myq_btn = myq_e.target.closest("[data-myq-tab]");
    if (!myq_btn) { return; }                       // 点在按钮以外不处理
    myq_switchTo(Number(myq_btn.getAttribute("data-myq-tab")));
  });

  /* 初始化：默认选中第 0 个选项卡（国内新闻） */
  myq_switchTo(0);

  /* 返回接口，供外部（如自动轮播、键盘导航）复用 */
  return { myq_switchTo: myq_switchTo };
}
