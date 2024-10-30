// ==UserScript==
// @name         zjooc
// @namespace    https://github.com/4o4E/zjooc-script
// @version      1.0.1
// @description  zjooc 自动刷题
// @author       404E
// @match        *://www.zjooc.cn/ucenter/student/course/study/*/plan/detail/*
// @grant        none
// @supportURL   https://github.com/4o4E/zjooc-script/issues
// ==/UserScript==

(function () {
  'use strict';

  // 设置, 根据自己的网络状况调整
  const config = {
    // 首次学习开始之前的延迟(等待html加载)
    start: 3000,
    // 点击链接跳转到下一学习后等待加载的时长
    next: 3000,
    // 跳转后开始前的等待时长
    before: 3000,
    // 跳过已完成的视频
    skip: true
  }

  const btnStyle = "color: red; font-size: 20px; line-height: 28px; font-weight: 1000;"

  function getCurrent() {
    let list = $(".plan-detail > .el-header > ul > li").map((_, b) => $(b).text().trim());
    return list[0] + " > " + list[1] + " > " + list[2];
  }

  // 前往下一个学习
  function next() {
    setTimeout(() => {
      if (stop) return;
      // 尝试从当前播放列表中挑选下一个(同一节)
      let next = $(".fr .el-tabs__nav-scroll .el-tabs__nav").find(".is-active + .el-tabs__item.is-top").first();
      if (next.length != 0) {
        console.log("[zjooc] > 跳转至下一项: " + next.find("span > span").text());
        console.log(next[0]);
        next[0].style = "color: green;";
        next.click();
        setTimeout(checkAndStart, config.before);
        return;
      }
  
      // 尝试从当前节中挑选下一个(同一章)
      next = $(".base-asider .el-submenu.is-active .is-active + li").first();
      if (next.length != 0) {
        console.log("[zjooc] > 跳转至下一节: " + next.text());
        console.log(next[0]);
        next[0].style = "color: green;";
        next.click();
        setTimeout(checkAndStart, config.before);
        return;
      }
  
      // 尝试从下一章中挑选第一个
      next = $(".base-asider .el-submenu.is-active + li").find("ul > li").first();
      if (next.length != 0) {
        console.log("[zjooc] > 跳转至下一章: " + next.text());
        console.log(next[0]);
        next[0].style = "color: green;";
        next.click();
        setTimeout(checkAndStart, config.before);
        return;
      }
      alert("已完成所有学习");
      stop = true;
    }, 1000);
  }

  // 尝试完成文档类型的学习
  function tryDoc() {
    if (stop) return;
    console.log("[zjooc] > 开始文档学习: " + getCurrent());
    // 点击完成学习按钮
    $(".el-main .el-button")[0].click();
    // 等待跳转
    setTimeout(() => {
      // 学习完成
      console.log("[zjooc] > 完成文档学习: " + getCurrent());
      next();
    }, config.next);
  }

  // 视频设置点击
  function configVideo() {
    // 静音
    $("video")[0].parentElement.children[2].children[18].click();
    // 4倍速
    $("video")[0].parentElement.children[8].children[0].click();
    // 开始播放
    $("video")[0].parentElement.children[2].children[0].click();
  }

  let lastTime;

  // 尝试完成视频学习
  function tryVideo() {
    if (stop) return;
    console.log("[zjooc] > 开始视频学习: " + getCurrent());
    configVideo();
    lastTime = "-1";
    // let b = false;
    // 循环检测是否结束
    let id = setInterval(() => {
      // 错误的检测
      if ($("video").length == 0) {
        clearInterval(id);
        tryDoc();
        return;
      }
      // 已完成
      if (config.skip && $(".fr .el-tabs__nav-scroll .el-tabs__nav .is-active span > i")[0].classList.contains("complete")) {
        console.log("[zjooc] > 跳过学习过的内容: " + getCurrent());
        // 取消定时器
        clearInterval(id);
        next();
        return;
      }
      let arr = $("video")[0].parentElement.children[2].children[7].innerHTML.split(' / ');
      // 若视频未开始播放则修复
      if (arr[0] === "00:00" || arr[0] === lastTime) configVideo();
      lastTime = arr[0];
      if (arr[0] === arr[1] && arr[0] != "00:00") {
        // 播放完成
        console.log("[zjooc] > 完成视频学习: " + getCurrent());
        // 取消定时器
        clearInterval(id);
        if (stop) return;
        // 等待跳转
        setTimeout(next, config.next);
        return;
      }
    }, 1000);
  }

  // 检测学习类型并开始学习
  function checkAndStart() {
    if (stop) return;
    // 已完成
    if (config.skip && $(".fr .el-tabs__nav-scroll .el-tabs__nav .is-active span > i")[0].classList.contains("complete")) {
      console.log("[zjooc] > 跳过学习过的内容: " + getCurrent());
      next();
      return;
    }
    if ($("video").length != 0) tryVideo();
    else tryDoc();
  }

  // 修复所在的位置和左侧导航栏位置不同的bug
  function fix() {
    let list = $(".plan-detail > .el-header > ul > li").map((_, b) => $(b).text().trim());
    $(".base-asider .el-submenu")
      .filter((_, obj) => $(obj).find(".of_eno")[0].innerHTML.trim() === list[0])
      .find("ul > li")
      .filter((_, obj) => $(obj).find(".of_eno")[0].innerHTML.trim() === list[1])
      .first()
      .click();
  }

  let stop = false;

  // 添加事件监听
  function bind(element, func) {
    try {
      // Chrome、FireFox、Opera、Safari、IE9.0及其以上版本
      element.addEventListener("click", func, false);
    } catch (e) {
      try {
        // IE8.0及其以下版本
        element.attachEvent('onclick', func);
      } catch (e) {
        // 早期浏览器
        console.warn("[zjooc] > 绑定事件失败", e)
      }
    }
  }

  // 创建按钮
  function createBtn() {
    let li2 = document.createElement("li");
    li2.setAttribute("class", "li_second");
    let span2 = document.createElement("span");
    span2.innerHTML = "停止学习";
    span2.style = btnStyle
    // 添加事件监听
    bind(li2, () => { stop = true; });
    li2.appendChild(span2);
    $(".online_service")[0].insertBefore(li2, $(".online_service > li")[0]);

    let li1 = document.createElement("li");
    li1.setAttribute("class", "li_second");
    let span1 = document.createElement("span");
    span1.innerHTML = "开始学习";
    span1.style = btnStyle
    // 添加事件监听
    bind(li1, start);
    li1.appendChild(span1);
    $(".online_service")[0].insertBefore(li1, $(".online_service > li")[0]);
  }

  function start() {
    stop = false;
    fix();
    checkAndStart();
  }

  window.onload = createBtn;
})();
