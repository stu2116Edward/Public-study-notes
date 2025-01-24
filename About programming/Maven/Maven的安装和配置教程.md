# Maven的安装和配置教程

### 1.什么是Maven
Maven是一个自动化构建工具，主要用于Java项目，它由Apache软件基金会维护。Maven能够自动化完成编译、测试、打包、发布等构建过程，可以大大提高开发效率，保证项目的质量  

下面我们从几个方面来介绍一下Maven的功能与特性：  
1. 项目管理工具
Maven不仅仅是一个构建工具，它还是一个项目管理工具。它通过项目对象模型（Project Object Model，POM）来管理项目的构建、报告和文档。
2. 依赖管理
Maven的一个核心功能是依赖管理。它允许开发者声明项目所依赖的库（如jar文件），Maven会自动下载这些依赖，并管理它们的版本。这样可以确保项目在不同的环境中有一致的依赖，减少了因依赖问题导致的错误。
3. 构建生命周期
Maven定义了项目的构建生命周期，包括清理、编译、测试、打包、集成测试、验证和部署等阶段。每个阶段都由插件来执行特定的任务。
4. 插件机制
Maven本身不执行构建的具体操作，而是通过插件来完成。插件是Maven的核心扩展点，用户可以通过添加或自定义插件来扩展Maven的功能。
5. 多模块项目管理
Maven支持多模块项目。这意味着一个大的项目可以被拆分成多个模块，每个模块都有自己的POM文件。Maven能够处理模块间的依赖关系，并协调它们的构建顺序。
6. 标准和约定优于配置
Maven鼓励使用标准和约定来减少配置的工作量。例如，它有一套标准的项目目录结构，如果遵循这些标准和约定，很多配置就可以省略，简化了项目的搭建过程。
7. 集成和扩展性
Maven可以与其他工具和系统集成，如持续集成服务器（如Jenkins）、问题跟踪系统等。同时，它也支持自定义插件来满足特定的构建需求。
8. 中央仓库
Maven使用中央仓库来存储依赖库。当Maven需要下载依赖时，它会首先从中央仓库查找。此外，Maven还支持设置镜像仓库和本地仓库，以优化下载速度和提高可靠性。

### 2.Maven的安装
1. 下载Maven点击[Maven官网](https://maven.apache.org/)
2. 点击Download，下载适合自己的版本：
**Windows用户选   apache-maven-3.9.8-bin.zip 这个就行了**
3. 解压刚刚下载的zip包(最好路径中不要有中文)

4. 配置环境变量  
复制 apache-maven-3.9.8-bin的路径，我的是：
<pre>
D:\apache-maven-3.9.8-bin\apache-maven-3.9.8
</pre>

打开环境变量设置：“此电脑” 鼠标右键 → “属性” → 高级系统设置 → 环境变量 → 在下面的系统变量中 → 新建  
变量名填：
```
MAVEN_HOME
```
变量值是刚刚复制的路径（以你自己电脑的路径为准）：
```
D:\apache-maven-3.9.8-bin\apache-maven-3.9.8
```
接着找到Path → 新建 → 填入：
```
%MAVEN_HOME%\bin
```

5. 验证环境变量是否成功配置：  
win+R运行cmd，输入:
```
mvn -version
```

### Maven的配置
#### 1.配置本地仓库
**本地仓库（Local Repository）在Maven中扮演着重要的角色，是Maven工作原理的一个关键部分**
1. 缓存依赖：
   - 当第一次运行Maven命令来构建项目时，Maven会从远程仓库（如中央仓库）下载项目所依赖的库（jar文件）到本地仓库。这些依赖被缓存在本地仓库中，以便于未来的构建可以重用，不需要再次从远程仓库下载，节省时间。
2. 离线工作：
   - 如果没有网络连接或者远程仓库不可用，Maven可以从本地仓库获取依赖，可以在离线状态下构建项目。
3. 减少网络流量：
   - 由于依赖一旦下载就会存储在本地仓库中，因此在项目开发过程中，重复构建时不需要多次下载相同的依赖，减少网络流量和远程仓库的负载。
4. 自定义依赖管理：
   - 可以将自己的项目构件（如jar文件）安装到本地仓库中，这样其他项目就可以通过Maven依赖机制使用这些构件，方便了项目的共享和重用。
5. 版本控制：
   - 本地仓库会存储不同版本的依赖，可以轻松地在项目中切换依赖的版本，不用担心其他项目的干扰。
6. 提高构建速度：
   - 本地仓库通常位于本地硬盘上，访问速度远快于远程仓库，可以显著提高项目构建的速度。
7. 自定义仓库配置：
   - 可以配置多个本地仓库，例如，为不同的项目或不同的环境设置不同的本地仓库，以更好地管理依赖。

**下面来详细介绍配置本地仓库的过程：**
1. 找到之前解压的MAVEN文件，新建一个 **Maven local repository** 文件夹作为本地的仓库  

2. 在 **D:\apache-maven-3.9.8-bin\apache-maven-3.9.8** 下找到`conf文件夹`，打开，找到`settings.xml`文件：  

3. 找到 `localRepository` 节点，在注释外添加：  
```
<localRepository>D:\apache-maven-3.9.8-bin\MAVEN—local repository</localRepository>
```

#### 2.配置阿里云服务器镜像
国外的服务器下载jar包很慢，所以我们需要将其改为国内的阿里云服务器  
1. 同样的，在之前这个 `settings.xml` 文件中找到 `mirrors` 节点  

2. 将下面的内容复制粘贴进去：
```
<!-- 阿里云仓库 -->
<mirror>
	<id>alimaven</id>
	<mirrorOf>central</mirrorOf>
	<name>aliyun maven</name>
	<url>http://maven.aliyun.com/nexus/content/repositories/central/</url>
</mirror>
```

#### 3.配置JDK
1. 同样的，在之前这个 `settings.xml` 文件中找到 `profiles` 节点：

2. 将下面的内容复制粘贴进去：
```
<!-- java版本 --> 
<profile>
	  <id>jdk-1.8</id>
	  <activation>
		<activeByDefault>true</activeByDefault>
		<jdk>1.8</jdk>
	  </activation>
 
	  <properties>
		<maven.compiler.source>1.8</maven.compiler.source>
		<maven.compiler.target>1.8</maven.compiler.target>
		<maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
	  </properties>
</profile>
```

3. 查看是否配置成功，**win+R**快捷键运行**cmd**，输入 **mvn help:system** 测试：
如果出现下载很多文件的页面，说明您配置成功啦！！！  
如果您第一次执行 mvn help:system 命令，Maven相关工具会自动到Maven中央仓库下载缺失的或者Maven中央仓库更新的各种配置文件和类库（jar包)到Maven本地仓库中。
下载完各种文件后， mvn help:system 命令会打印出所有的**Java系统属性和环境变量**  
到这里，所有的配置就大功告成了  
