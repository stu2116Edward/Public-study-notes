<h1>Linux 压缩包使用指南</h1>
<p>以下是Linux系统中常用的压缩和解压缩命令列表，包括使用zip和tar命令，以及如何设置密码保护。</p>

<table>
  <tr>
    <th>命令</th>
    <th>描述</th>
    <th>示例</th>
  </tr>
  <tr>
    <td>安装zip</td>
    <td>如果系统中尚未安装zip包，使用此命令进行安装。</td>
    <td><code>sudo apt install zip</code></td>
  </tr>
  <tr>
    <td>打包成zip</td>
    <td>将文件或目录压缩成一个zip格式的压缩包。</td>
    <td><code>zip -r 压缩包名称.zip 文件/目录</code></td>
  </tr>
  <tr>
    <td>带密码打包成zip</td>
    <td>将文件或目录压缩成一个带密码保护的zip格式的压缩包。</td>
    <td><code>zip -er 压缩包名称.zip 文件/目录</code></td>
  </tr>
  <tr>
    <td>解压缩zip</td>
    <td>解压一个zip格式的压缩包。</td>
    <td><code>unzip 压缩包名称.zip</code></td>
  </tr>
  <tr>
    <td>带密码解压缩zip</td>
    <td>解压一个带密码保护的zip格式的压缩包。</td>
    <td><code>unzip 压缩包名称.zip</code>（会提示输入密码）</td>
  </tr>
  <tr>
    <td>安装tar</td>
    <td>如果系统中尚未安装tar包，使用此命令进行安装。</td>
    <td><code>sudo apt install tar</code></td>
  </tr>
  <tr>
    <td>压缩成tar.gz</td>
    <td>将文件或目录压缩成一个tar.gz格式的压缩包。</td>
    <td><code>tar -czvf 压缩包名称.tar.gz 文件/目录</code></td>
  </tr>
  <tr>
    <td>压缩成tar.bz2</td>
    <td>将文件或目录压缩成一个tar.bz2格式的压缩包。</td>
    <td><code>tar -cjvf 压缩包名称.tar.bz2 文件/目录</code></td>
  </tr>
  <tr>
    <td>解压缩tar.gz</td>
    <td>解压一个tar.gz格式的压缩包。</td>
    <td><code>tar -xzvf 压缩包名称.tar.gz</code></td>
  </tr>
  <tr>
    <td>解压缩tar.bz2</td>
    <td>解压一个tar.bz2格式的压缩包。</td>
    <td><code>tar -xjvf 压缩包名称.tar.bz2</code></td>
  </tr>
  <tr>
    <td>查看zip内容</td>
    <td>查看zip压缩包中的内容而不解压。</td>
    <td><code>zip -sf 压缩包名称.zip</code></td>
  </tr>
  <tr>
    <td>查看tar内容</td>
    <td>查看tar.gz或tar.bz2压缩包中的内容而不解压。</td>
    <td><code>tar -tzvf 压缩包名称.tar.gz</code> 或 <code>tar -tzvf 压缩包名称.tar.bz2</code></td>
  </tr>
  <tr>
    <td>排除文件压缩</td>
    <td>压缩时排除特定文件或目录。</td>
    <td><code>zip -r 压缩包名称.zip --exclude=*.tmp 文件/目录</code></td>
  </tr>
  <tr>
    <td>更新zip压缩包</td>
    <td>向现有的zip压缩包中添加新文件。</td>
    <td><code>zip -g 压缩包名称.zip 新文件</code></td>
  </tr>
  <tr>
    <td>压缩成tar.xz</td>
    <td>将文件或目录压缩成一个tar.xz格式的压缩包。</td>
    <td><code>tar -cJvf 压缩包名称.tar.xz 文件/目录</code></td>
  </tr>
  <tr>
    <td>解压缩tar.xz</td>
    <td>解压一个tar.xz格式的压缩包。</td>
    <td><code>tar -xJvf 压缩包名称.tar.xz</code></td>
  </tr>
</table>
