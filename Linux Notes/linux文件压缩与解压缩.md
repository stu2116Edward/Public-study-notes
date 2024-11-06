<h1>Linux 压缩包使用指南</h1>
<p>以下是Linux系统中常用的压缩和解压缩命令列表，包括使用zip、tar命令，以及如何设置密码保护。</p>

<table>
  <tr>
    <th>命令</th>
    <th>描述</th>
    <th>示例</th>
  </tr>
  <!-- ZIP 压缩相关命令 -->
  <tr>
    <td colspan="3"><strong>ZIP 压缩命令</strong></td>
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
    <td>查看zip内容</td>
    <td>查看zip压缩包中的内容而不解压。</td>
    <td><code>zip -sf 压缩包名称.zip</code></td>
  </tr>
  <tr>
    <td>更新zip压缩包</td>
    <td>向现有的zip压缩包中添加新文件。</td>
    <td><code>zip -g 压缩包名称.zip 新文件</code></td>
  </tr>
  <!-- TAR 压缩相关命令 -->
  <tr>
    <td colspan="3"><strong>TAR 压缩命令</strong></td>
  </tr>
  <tr>
    <td>安装tar</td>
    <td>如果系统中尚未安装tar包，使用此命令进行安装。</td>
    <td><code>sudo apt install tar</code></td>
  </tr>
  <tr>
    <td>打包成tar</td>
    <td>将文件或目录打包成一个tar格式的压缩包。</td>
    <td><code>tar -cvf 压缩包名称.tar 文件/目录</code></td>
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
    <td>压缩成tar.xz</td>
    <td>将文件或目录压缩成一个tar.xz格式的压缩包。</td>
    <td><code>tar -cJvf 压缩包名称.tar.xz 文件/目录</code></td>
  </tr>
  <tr>
    <td>解压缩tar</td>
    <td>解压一个tar格式的压缩包。</td>
    <td><code>tar -xvf 压缩包名称.tar</code></td>
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
    <td>解压缩tar.xz</td>
    <td>解压一个tar.xz格式的压缩包。</td>
    <td><code>tar -xJvf 压缩包名称.tar.xz</code></td>
  </tr>
  <tr>
    <td>查看tar内容</td>
    <td>查看tar.gz或tar.bz2压缩包中的内容而不解压。</td>
    <td><code>tar -tzvf 压缩包名称.tar.gz</code> 或 <code>tar -tzvf 压缩包名称.tar.bz2</code></td>
  </tr>
  <tr>
    <td>排除文件压缩</td>
    <td>压缩时排除特定文件或目录。</td>
    <td><code>tar --exclude='*.tmp' -cvf 压缩包名称.tar 文件/目录</code></td>
  </tr>
  <!-- RAR 压缩相关命令 -->
  <tr>
    <td colspan="3"><strong>RAR 压缩命令</strong></td>
  </tr>
  <tr>
    <td>安装unrar</td>
    <td>如果系统中尚未安装unrar包，使用此命令进行安装。</td>
    <td><code>sudo apt install unrar</code></td>
  </tr>
  <tr>
    <td>解压缩rar</td>
    <td>解压一个rar格式的压缩包。</td>
    <td><code>unrar x 压缩包名称.rar</code></td>
  </tr>
  <tr>
    <td>打包成rar</td>
    <td>将文件或目录压缩成一个rar格式的压缩包。</td>
    <td><code>rar a 压缩包名称.rar 文件/目录</code></td>
  </tr>
  <tr>
    <td>带密码打包成rar</td>
    <td>将文件或目录压缩成一个带密码保护的rar格式的压缩包。</td>
    <td><code>rar a -hp 压缩包名称.rar 文件/目录</code></td>
  </tr>
  <tr>
    <td>带密码解压缩rar</td>
    <td>解压一个带密码保护的rar格式的压缩包。</td>
    <td><code>unrar x -p 压缩包名称.rar</code>（会提示输入密码）</td>
  </tr>
  <tr>
    <td>查看rar内容</td>
    <td>查看rar压缩包中的内容而不解压。</td>
    <td><code>unrar l 压缩包名称.rar</code></td>
  </tr>
  <!-- 7z 压缩相关命令 -->
  <tr>
    <td colspan="3"><strong>7z 压缩命令</strong></td>
  </tr>
  <tr>
    <td>安装p7zip-full</td>
    <td>如果系统中尚未安装p7zip-full包，使用此命令进行安装。</td>
    <td><code>sudo apt install p7zip-full</code></td>
  </tr>
  <tr>
    <td>压缩成7z</td>
    <td>将文件或目录压缩成一个7z格式的压缩包。</td>
    <td><code>7z a 压缩包名称.7z 文件/目录</code></td>
  </tr>
  <tr>
    <td>解压缩7z</td>
    <td>解压一个7z格式的压缩包。</td>
    <td><code>7z x 压缩包名称.7z</code></td>
  </tr>
  <tr>
    <td>查看7z内容</td>
    <td>查看7z压缩包中的内容而不解压。</td>
    <td><code>7z l 压缩包名称.7z</code></td>
  </tr>
  <!-- .Z 压缩相关命令 -->
  <tr>
    <td colspan="3"><strong>.Z 压缩命令</strong></td>
  </tr>
  <tr>
    <td>安装压缩工具</td>
    <td>如果系统中尚未安装压缩工具，使用此命令进行安装。</td>
    <td><code>sudo apt install gzip</code></td>
  </tr>
  <tr>
    <td>压缩成.Z</td>
    <td>将文件压缩成一个.Z格式的压缩包。</td>
    <td><code>compress 要压缩的文件</code></td>
  </tr>
  <tr>
    <td>解压缩.Z</td>
    <td>解压一个.Z格式的压缩包。</td>
    <td><code>uncompress 压缩文件名.Z</code></td>
  </tr>
  <tr>
    <td>查看.Z内容</td>
    <td>查看.Z压缩包中的内容而不解压。</td>
    <td><code>zcat 压缩文件名.Z</code></td>
  </tr>
</table>
