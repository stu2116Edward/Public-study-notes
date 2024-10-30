# zjooc-script

自动挂机刷[zjooc](https://www.zjooc.cn/)的[油猴](https://www.tampermonkey.net/)脚本, 目前支持视频学习(自动静音+4倍速)/文档学习/跳过学习过的内容; 部分代码来源于[ColdThunder11/ZJOOCAutoPlay](https://github.com/ColdThunder11/ZJOOCAutoPlay)

**如果此脚本对你有帮助, 请点一个star, 这对我有非常大的帮助**

**遇到问题请在[issue](https://github.com/4o4E/zjooc-script/issues)反馈**

## 如何使用

1. 下载并安装[油猴](https://www.tampermonkey.net/)浏览器扩展
2. 点击打开上方文件列表中的[`zjooc.js`](zjooc.js)并复制其中的文本
3. 在浏览器的扩展中打开油猴的管理面板
4. 点击右上角的加号
5. 将复制的脚本内容粘贴进去并保存
6. 打开zjooc你要刷的课(脚本会自动启动)
7. **如果不是从头开始刷, 需要在打开学习界面后点击(只需要点击一次)需要刷的课, 否则会从头开始刷**

## 可配置项

```javascript
// 设置, 根据自己的网络状况调整
const config = {
  // 首次学习开始之前的延迟(等待html加载)
  start: 1000,
  // 点击链接跳转到下一学习后等待加载的时长
  next: 1000,
  // 跳转后开始前的等待时长
  before: 1000
}
```

## PS

练手作, 本来想让脚本支持多开的同时刷的, 结果发现比较麻烦...