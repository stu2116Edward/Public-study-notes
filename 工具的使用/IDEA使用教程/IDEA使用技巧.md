# IDEA使用技巧

**Create New Project**：创建一个新的项目  
**Import Project**：导入一个现有的项目  
**Open**：打开一个已有项目。比如：可以打开 Eclipse 项目  
**Check out from Version Control**：可以通过服务器上的项目地址 check out Github 上面项目或其他 Git 托管服务器上的项目  

> [!Note]
项目下的 src 类似于 Eclipse 下的 src 目录，用于存放代码
项目下的.idea 和 project01.iml 文件都是 IDEA 项目特有的。类似于 Eclipse 项目下的.settings、.classpath、.project 文件等  

### 创建Java项目结构
使用快捷键**Ctrl+Alt+Shift+S**，打开Project Structure，选择Modules，点击+号，选择New Module，选择Java，设置Module name，选择SDK，点击Finish，即可创建一个Java项目结构  

**创建软件包（Package ）**：  
在 src 目录下创建一个 package  
**创建Java文件（class）**：  
在包下 New 一个 Java Class  

> [!Note]
不管是创建 Class，还是 Interface，还是 Annotation，都是选择 New → Java Class，然后在 Kind 下拉框中选择创建的结构的类型。接着在类里声明主方法，输出结果，完成测试  
