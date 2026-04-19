# 解决vscode加载Web视图时出错

<pre>
加载 Web 视图时出错: Error: Could not register service worker: InvalidStateError: Failed to register a ServiceWorker: The document is in an invalid state…
</pre>
在vscode/cursor出现以上报错后，我浅浅地搜了以下解决方案 `code --no-sandbox` 然后就执行了，然后后续问题又继续出现了。  
为了一劳永逸的解决这个问题，我找到那个配置项  

根据官方的更新说明，配置方式如下：  
Open the Command Palette (**Ctrl+Shift+P**).  
打开命令调板（**Ctrl+Shift+P**）。


`Run the Preferences: Configure Runtime Arguments command`.  
运行 首选项：配置运行时参数命令。

This command opens a argv.json file to configure runtime arguments. You might see some default arguments there already.  
此命令将打开 `argv.json` 文件，以配置运行时参数。您可能已经在该文件中看到了一些默认参数。


Add "disable-chromium-sandbox": true.    
添加 "disable-chromium-sandbox": true 。
```
	// Disable Chromium sandbox
	"disable-chromium-sandbox": true,
```
<img width="1754" height="978" alt="屏幕截图 2026-04-19 123343" src="https://github.com/user-attachments/assets/a6716a0e-668a-4a72-8b03-d0f99558f9e2" />  


Restart VS Code.    
重新启动 VS Code。

v1.80更新说明：https://code.visualstudio.com/updates/v1_80
