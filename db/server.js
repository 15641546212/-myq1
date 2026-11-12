/* ============================================================
   作者：马宇乾
   建立时间：2026-11-12 13:47
   使用模型：Trae
   功能名称及简介：数据服务器 —— 读取 db.json 的 poems 数据，对外提供 /poems 接口，端口 3004
   启动方式：在 db 目录下执行  node server.js
   访问地址：http://localhost:3004/poems
   ============================================================ */

const express = require('express');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 3004;

// 允许跨域（前端页面可能由其他端口/静态服务器打开）
app.use(function (req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  next();
});

// 允许前端访问项目根目录下的静态资源（HTML、图片等）
app.use(express.static(path.join(__dirname, '..')));

/* 读取 db.json 中的 poems 数据 */
function myq_readPoems() {
  const myq_file = path.join(__dirname, 'db.json');
  const myq_raw = fs.readFileSync(myq_file, 'utf-8');
  const myq_data = JSON.parse(myq_raw);
  return myq_data.poems || [];
}

// 接口：获取全部诗词
app.get('/poems', function (req, res) {
  try {
    const myq_poems = myq_readPoems();
    res.json({ code: 0, msg: 'ok', data: myq_poems });
  } catch (e) {
    res.status(500).json({ code: 1, msg: '读取 db.json 失败：' + e.message });
  }
});

// 启动服务器
app.listen(PORT, function () {
  console.log('数据服务器已启动：http://localhost:' + PORT);
  console.log('诗词接口：http://localhost:' + PORT + '/poems');
});
