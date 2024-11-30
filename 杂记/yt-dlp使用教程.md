# yt-dlp使用教程

## yt-dlp 的安装
yt-dlp 是 youtube-dl 的一个更活跃的分支，支持更多网站和功能。你可以通过多种方式安装 yt-dlp  
使用 pip 安装
```bash
pip install yt-dlp
```
使用 Homebrew 安装（macOS 和 Linux）
```bash
brew install yt-dlp
```
从源代码安装
1.从 [yt-dlp GitHub](https://github.com/yt-dlp/yt-dlp) 仓库 下载最新的源码
2.运行以下命令
```
python setup.py install
```


windows系统中只有火狐浏览器可以直接从浏览器里面获取cookie  
要登陆一下对应的视频网站如果能够看到最高的分辨率就下载最高分辨率的  

方法一(使用火狐浏览器下载)：
```bash
yt-dlp --cookies-from-browser firefox <video url>
```
方法二：
```bash
yt-dlp "你的视频下载链接" -f "ba+bv"
```
示例：
```bash
yt-dlp --cookies-from-browser firefox https://www.bilibili.com/video/BV1A2DVY2EC5?t=330.2
```
使用浏览器Cookie下载：  
1.Chrome浏览器中安装`get cookie locally`扩展  
2.执行下面的命令：
```bash
yt-dlp --cookies <你的cookies.txt文件路径> <你视频的url>
```


yt-dlp 下载 YouTube 视频的命令  
基本下载命令  
```bash
yt-dlp -f 'bestvideo+bestaudio' "https://www.youtube.com/watch?v=VIDEO_ID" -o '%(title)s.%(ext)s'
```
- -f 'bestvideo+bestaudio'：选择最佳视频和最佳音频格式
- `https://www.youtube.com/watch?v=VIDEO_ID`：目标视频的 URL
- -o '%(title)s.%(ext)s'：输出文件的命名格式，%(title)s 表示视频标题，%(ext)s 表示视频格式

视频输出为mp4
```bash
yt-dlp -f 'bestvideo+bestaudio' "https://www.youtube.com/watch?v=Oa0ZHfcalCM&ab_channel=BBCWorldService" -o '%(title)s.%(ext)s' --merge-output-format mp4
```
- -f 'bestvideo+bestaudio'：选择最佳视频和音频流进行下载。
- -o '%(title)s.%(ext)s'：指定输出文件名格式。
- --merge-output-format mp4：指定合并后的输出格式为 MP4。
这个命令会下载最佳的视频和音频流，然后合并成 MP4 格式。确保你有 ffmpeg  

使用 --continue 选项  
yt-dlp 默认支持断点续传，你可以使用 --continue 选项来确保从上次结束的地方继续下载。通常情况下，这个选项是默认启用的，但你可以显式指定它以确保续传功能开启  
```bash
yt-dlp --continue -f 'bv*[height=1080]+ba' "https://www.youtube.com/watch?v=vLRQUR68MSo&list=PL9nxfq1tlKKl1uTYq11gCFJ6I__wYRXsX&index=1" -o '%(title)s.%(ext)s'
```
下载缩略图的命令
```bash
yt-dlp --write-thumbnail --skip-download "https://www.youtube.com/watch?v=VIDEO_ID"
```
- --write-thumbnail：下载视频的缩略图
- --skip-download：仅下载缩略图而不下载视频

如果希望同时下载视频和缩略图：
```bash
yt-dlp --write-thumbnail -f 'bestvideo+bestaudio' "https://www.youtube.com/watch?v=VIDEO_ID" -o '%(title)s.%(ext)s'
```

下载哔哩哔哩 (Bilibili) 视频时，如果遇到需要登录时候，需要注意的事情  
需要提供登录状态的 cookies。以下是具体步骤：  

- 方法一：使用浏览器扩展导出 Netscape 格式的 cookies  
1. 安装`Cookie-Editor`扩展（例如 edge 浏览器）  
1. 打开 Bilibili 并登录  
2. 使用 Cookie-Editor导出 cookies，选择“导出为文本（Netscape 格式）”，保存为 cookies.txt 文件  

- 方法二：使用 --cookies-from-browser 选项
直接从浏览器中读取 cookies 进行下载：
```bash
yt-dlp --cookies-from-browser chrome -f 'bv*[height=1080]+ba' "https://www.bilibili.com/video/BV1uY28YdECM" -o '%(title)s.%(ext)s'
```
将 chrome 替换为你的浏览器名称，例如 firefox 或 edge  
验证可用格式并下载  
1.查看可用格式  
```bash
yt-dlp --cookies cookies.txt --list-formats "https://www.bilibili.com/video/BV1ocxveJE2H/?vd_source=6278f29e0b4b9859224ba32ab49ee184"
```
2.下载指定格式的视频
```bash
yt-dlp --cookies cookies.txt -f 'bv*[height=1080]+ba' "https://www.bilibili.com/video/BV1ocxveJE2H/?vd_source=6278f29e0b4b9859224ba32ab49ee184" -o '%(title)s.%(ext)s'
```

其他注意事项:  
● 确保 cookies 文件的路径正确，并且文件格式为 Netscape 格式  
● 确保你的账号具有相应的权限，如果视频需要付费会员，请确保你的账号是会员  
● cookies 文件有可能会过期，如果下载失败，请重新导出新的 cookies 文件  
