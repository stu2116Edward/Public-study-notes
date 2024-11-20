# chmod文件权限管理

![file-permissions-rwx](https://github.com/user-attachments/assets/d37ff0df-afe3-4369-b2fa-7d7c5dc6fc77)  
![rwx-standard-unix-permission-bits](https://github.com/user-attachments/assets/e88795b4-c720-4938-b794-0deba810df4d)  

## 符号模式
<table>
  <tr>
    <th>标识符</th>
    <th>用户类型</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>u</td>
    <td>user</td>
    <td>文件所有者</td>
  </tr>
  <tr>
    <td>g</td>
    <td>group</td>
    <td>文件所有者所在组</td>
  </tr>
  <tr>
    <td>o</td>
    <td>others</td>
    <td>所有其他用户</td>
  </tr>
  <tr>
    <td>a</td>
    <td>all</td>
    <td>所有用户, 相当于 ugo</td>
  </tr>
</table>


<table>
  <tr>
    <th>Operator</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>+</td>
    <td>为指定的用户类型增加权限</td>
  </tr>
  <tr>
    <td>-</td>
    <td>去除指定用户类型的权限</td>
  </tr>
  <tr>
    <td>=</td>
    <td>设置指定用户权限的设置，即将用户类型的所有权限重新设置</td>
  </tr>
</table>


<table>
  <tr>
    <th>模式</th>
    <th>名字</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>r</td>
    <td>读</td>
    <td>设置为可读权限</td>
  </tr>
  <tr>
    <td>w</td>
    <td>写</td>
    <td>设置为可写权限</td>
  </tr>
  <tr>
    <td>x</td>
    <td>执行权限</td>
    <td>设置为可执行权限</td>
  </tr>
  <tr>
    <td>X</td>
    <td>特殊执行权限</td>
    <td>只有当文件为目录文件，或者其他类型的用户有可执行权限时，才将文件权限设置可执行</td>
  </tr>
  <tr>
    <td>s</td>
    <td>setuid/gid</td>
    <td>当文件被执行时，根据who参数指定的用户类型设置文件的setuid或者setgid权限</td>
  </tr>
  <tr>
    <td>t</td>
    <td>粘贴位</td>
    <td>设置粘贴位，只有超级用户可以设置该位，只有文件所有者u可以使用该位</td>
  </tr>
</table>


## 数字表示
<table>
  <tr>
    <th>#</th>
    <th>权限</th>
    <th>rwx</th>
    <th>二进制</th>
  </tr>
  <tr>
    <td>7</td>
    <td>读 + 写 + 执行</td>
    <td>rwx</td>
    <td>111</td>
  </tr>
  <tr>
    <td>6</td>
    <td>读 + 写</td>
    <td>rw-</td>
    <td>110</td>
  </tr>
  <tr>
    <td>5</td>
    <td>读 + 执行</td>
    <td>r-x</td>
    <td>101</td>
  </tr>
  <tr>
    <td>4</td>
    <td>只读</td>
    <td>r--</td>
    <td>100</td>
  </tr>
  <tr>
    <td>3</td>
    <td>写 + 执行</td>
    <td>-wx</td>
    <td>011</td>
  </tr>
  <tr>
    <td>2</td>
    <td>只写</td>
    <td>-w-</td>
    <td>010</td>
  </tr>
  <tr>
    <td>1</td>
    <td>只执行</td>
    <td>--x</td>
    <td>001</td>
  </tr>
  <tr>
    <td>0</td>
    <td>无</td>
    <td>---</td>
    <td>000</td>
  </tr>
</table>


# 常用示例
<table>
  <tr>
    <th>权限设置</th>
    <th>符号模式命令</th>
    <th>数字模式命令</th>
  </tr>
  <tr>
    <td>设置所有者可读写执行，组和其他用户可读执行</td>
    <td><code>chmod u=rwx,g=rx,o=rx file.txt</code></td>
    <td><code>chmod 755 file.txt</code></td>
  </tr>
  <tr>
    <td>设置所有者可读写，组和其他用户可读</td>
    <td><code>chmod u=rw,g=r,o=r file.txt</code></td>
    <td><code>chmod 644 file.txt</code></td>
  </tr>
  <tr>
    <td>给文件所有者增加读权限</td>
    <td><code>chmod u+r file.txt</code></td>
    <td><code>chmod 400 file.txt</code> (增加读权限后)</td>
  </tr>
  <tr>
    <td>给目录的所属组增加写权限</td>
    <td><code>chmod g+w directory</code></td>
    <td><code>chmod 774 directory</code></td>
  </tr>
  <tr>
    <td>给其他用户增加对文件的执行权限</td>
    <td><code>chmod o+x file.txt</code></td>
    <td><code>chmod 755 file.txt</code></td>
  </tr>
  <tr>
    <td>移除所有用户对文件的读、写和执行权限</td>
    <td><code>chmod a-rwx file.txt</code></td>
    <td><code>chmod 000 file.txt</code></td>
  </tr>
  <tr>
    <td>设置文件所有者具有读、写和执行权限</td>
    <td><code>chmod u=rwx file.txt</code></td>
    <td><code>chmod 700 file.txt</code></td>
  </tr>
  <tr>
    <td>设置文件的所属组只有读权限</td>
    <td><code>chmod g=r file.txt</code></td>
    <td><code>chmod 640 file.txt</code></td>
  </tr>
  <tr>
    <td>移除其他用户对文件的所有权限</td>
    <td><code>chmod o= file.txt</code></td>
    <td><code>chmod 750 file.txt</code> (移除后)</td>
  </tr>
</table>
