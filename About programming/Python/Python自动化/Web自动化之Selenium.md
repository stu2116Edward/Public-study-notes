# Web自动化之Selenium

### 安装配置环境
安装浏览器和与之对应的WebDriver:
[Edge果核离线安装包](https://www.ghxi.com/microsoftedge.html)  
[EdgeDriver](https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/?form=MA13LH)  

[Chrome & ChromeDriver](https://googlechromelabs.github.io/chrome-for-testing)  

[FireFox](https://www.firefox.com.cn/download/#product-desktop-release)  
[geckodriver](https://github.com/mozilla/geckodriver/releases)  
**这里的版本要对应**  
在浏览器中输入查看浏览器版本：  
edge:
```
edge://version
```
chrome:
```
chrome://version
```
firefox:
```
about:support
```

下载完成之后将`chromedriver.exe`文件的路径复制，并添加到环境变量中即可。

安装Selenium：
```bash
pip install selenium
```

### 模块导入
```python
from selenium import webdriver  # webdriver对象
from selenium.webdriver.edge.options import Options  # options选项因webdriver类型而异，这里使用edge
from selenium.webdriver.common.by import By  # 定位元素By类
from selenium.webdriver.common.keys import Keys  # 模拟按键操作Keys类
from selenium.webdriver.support.ui import WebDriverWait  # 显性等待
from selenium.webdriver import ActionChains  # 用来模拟人为操作鼠标的一系列动作
from selenium.webdriver.support import expected_conditions as EC  # 条件等待，配合显性等待使用
from selenium.common.exceptions import TimeoutException  # 超时错误
from selenium.common.exceptions import NoSuchElementException  # 元素定位错误
```

### 设置webdriver对象
按照你的webdriver类型选择webdriver对象：
```python
browser = webdriver.ChromiumEdge()  # 设定一个webdriver对象, Edge浏览器
browser = webdriver.Chrome()  # 设定一个webdriver对象, Chrome浏览器
browser = webdriver.Firefox()  # 设定一个webdriver对象, Firefox浏览器
```

### 设定options
selenium中的options是用来设定浏览器的一些属性和必要的操作选项的。  
options也因浏览器的类型而异，导入时也应该按照你的webdriver类型选择：
```python
from selenium.webdriver.firefox.options import Options  # 火狐浏览器
from selenium.webdriver.edge.options import Options  # Edge浏览器
from selenium.webdriver.chrome.options import Options  # Chrome浏览器
```

以下是一些常见的options选项（主要是用来隐藏自动化控制的痕迹并且设置文件下载路径）：
```python
options = Options()
options.add_argument('--disable-blink-features=AutomationControlled')  # 隐藏自动化控制标头
options.add_experimental_option('excludeSwitches', ['enable-automation'])  # 隐藏自动化标头
options.add_argument('--ignore-ssl-errors')  # 忽略SSL错误
options.add_argument('--ignore-certificate-errors')  # 忽略证书错误
prefs = {
    'download.default_directory': '文件夹路径',  # 设置文件默认下载路径，替换为你的文件夹路径
    "profile.default_content_setting_values.automatic_downloads": True  # 允许多文件下载
}
options.add_experimental_option("prefs", prefs)  # 将prefs字典传入options
```

最后，我们需要将已经设定好的options传入到先前设定的webdriver对象中：
```python
browser = webdriver.ChromiumEdge(options=options)  # 将options传入到webdriver中
```

这样，我们便可以使用`browser`（已经设定好的options的webdriver对象）进行web自动化时，浏览器就会带有options中的特性了，可以进行后续自动化流程了。

### 打开网页
接着我们使用已经配置好的webdriver使用`get`方法即可打开网页：
```python
url = 'https://www.example.com'
browser.get(url)
```

### 查找和定位元素

#### 查找元素
selenium中查找元素有两种方法：`find_element()`与`find_elements()`。

使用`find_element`或`find_elements`方法时，其内部第一个参数为定位方式，使用`By`类下的8个属性指明，后边紧跟着的是元素在html页面中的定位值，类型为字符串。

```python
browser.find_element(By.XPATH, '')  # 根据条件查找单个元素，返回结果为webelement
browser.find_elements(By.XPATH, '')  # 查找所有符合条件的元素，返回结果为webelement构成的列表
```

特别地，在使用`find_elements`方法时，它会返回所有匹配给定定位器和值的元素列表。如果没有找到任何元素，它将返回一个空列表。这与`find_element`方法不同，后者在找不到元素时会抛出`NoSuchElementException`异常。因此，在使用`find_elements`方法时，我们需要检查返回的列表是否为空，以避免出现错误。

同时，selenium还支持链式查找，即：你可以在查找到一个顶层元素后，直接对该元素使用`find_element()`和`find_elements()`方法来定位其内部的子元素。

```python
top_element = browser.find_element(By.ID, '')
sub_elements = top_element.find_elements(By.TAG_NAME, '')
```

#### 定位元素
selenium定位元素时共有八种方式：
```python
browser.find_element(By.XPATH, '')
browser.find_element(By.CSS_SELECTOR, '')
browser.find_element(By.ID, '')
browser.find_element(By.CLASS_NAME, '')
browser.find_element(By.PARTIAL_LINK_TEXT, '')
browser.find_element(By.LINK_TEXT, '')
browser.find_element(By.TAG_NAME, '')
browser.find_element(By.NAME, '')
```

##### XPATH和CSS_SELECTOR定位
XPATAH和CSS_SELECTOR，在浏览器中打开开发者工具，找到指定元素后，右击，点击复制，便可以直接复制该元素的XPATH和CSS_SELECTOR路径用于定位。

```python
element = browser.find_element(By.XPATH, '//*[@id="home-content-box"]/div[3]/div[2]/div[5]/div/div/div/div/a[1]')
element = browser.find_element(By.CSS_SELECTOR, '#home-content-box > div.home-article > div.home-article-cont > div:nth-child(5) > div > div > div > div > a.article-title.word-1')
```

##### ID定位
使用ID定位元素时需要待定位元素具有id属性才可以，id属性通常在Input输入框和Button按钮这两个组件中较为常见。

该组件为一个id为“toolbar-search-button”名为搜索的按钮，那么我们在定位该元素时便可以：
```python
search_button = browser.find_element(By.ID, 'toolbar-search-button')
search_button.click()
```

##### CLASS_NAME定位
同样的，使用CLASS_NAME定位元素时，元素需要具有class_name属性，一般来说class_name在html中常见于div标签（盒子）。

上边是一些由div组件构成的新闻列表，我们想要获得每个div组件内的所有新闻名称，即每个div元素的text属性，那么便可以使用class_name的定位方式：
```python
divs = browser.find_elements(By.CLASS_NAME, 'headswiper-item')
titles = [div.text for div in divs]
print(titles)
```

##### LINK_TEXT与PARTIAL_LINK_TEXT定位
LINK_TEXT与PARTIAL_LINK_TEXT在定位元素时主要根据链接的全部文本或部分文本进行定位。LINK_TEXT指的是完整的链接文本，而PARTIAL_LINK_TEXT则是链接文本的一部分。

例如，如果页面中有一个链接是“点击这里访问百度”，那么可以使用LINK_TEXT('点击这里访问百度')或PARTIAL_LINK_TEXT('点击这里')来定位这个链接。这种定位方式对于页面中的链接元素非常有效，尤其是当链接文本较为独特，不容易与其他元素混淆时。

这里我们以csdn网页中的最顶层一栏为例：

对于顶层一栏中的“下载”文本，在开发者工具中观察其原码，我们不难发现这就是一个典型的LinkText，并且当我们点击这个文本后，页面便会跳转到新的链接。对此，我们便可以使用LINK_TEXT方法定位：
```python
download = browser.find_element(By.LINK_TEXT, '下载')
download.click()
```

##### TAG_NAME定位
TAG_NAME是HTML标签的名称，通过元素的标签名来定位元素时，若html中不止一个元素具有此标签名的话，我们通常使用`find_elements()`函数查找。

比如上边的网页中，每个论文的都被放在标签名为'li'的容器内，其内部的text属性是我们想要获取的文章标题，那么我们的代码便可以这样写：
```python
essay_container = browser.find_element(By.XPATH, '//*[@id="new-article-list"]/div/ul')
essays = essay_container.find_elements(By.TAG_NAME, "li")
essay_titles = [essay.text for essay in essays]
```

##### NAME定位
NAME定位是通过元素的name属性来定位元素。在HTML中，一些元素如input、select等都可以设置name属性。使用NAME定位时，我们只需传入元素的name属性值即可。
```python
input_element = browser.find_element(By.NAME, 'username')
input_element.send_keys('user')
```

### WebDriver常用方法
这里我们假设`browser`为已经设定好的一个webdriver对象。

#### 打开网页
```python
browser.get(url)  # 打开网页
```

#### 获得当前浏览器界面内打开过的所有窗口句柄列表
```python
browser.window_handles  # 获得当前所有打开的窗口句柄，是一个列表，获得最新的当期界面可以用
```

#### 利用`browser.window_handles`切换当前窗口至最新打开的窗口
```python
latest_window = browser.window_handles[-1]
browser.switch_to.window(latest_window)
```

#### 切换到iframe
```python
browser.switch_to.frame()  # 切换到iframe
```

#### 给当前webdriver添加cookie
```python
browser.add_cookie()  # 给当前webdriver添加cookie，通常出现在免登录情境下
```

#### 获得当前页面url的cookies
```python
browser.get_cookies()  # 获得当前页面url的cookies
```

#### 删除当前webdriver已经添加过的所有cookies
```python
browser.delete_all_cookies()  # 删除当前所有cookies
```

#### 关闭警告或广告弹窗
```python
browser.switch_to.alert.dismiss()  # 注意，该方法只能关闭使用js的alert函数实现的弹窗，其余弹窗无法关闭，还会引发错误
```

#### 回退至上一个网页
```python
browser.back()  # 回退至前一个网页
```

#### 跳转至下一个网页
```python
browser.forward()  # 跳转至下一个网页
```

#### 关闭当前窗口
```python
browser.close()  # 关闭当前窗口
```

#### 获得当前窗口的url
```python
browser.current_url  # 返回当前窗口的url
```

#### 获得当前的窗口句柄
```python
browser.current_window_handle  # 获得当前的窗口句柄，常与browser.switch_to.window()配合使用
```

#### 刷新当前界面
```python
browser.refresh()  # 刷新一下当前界面
```

#### 在当前页面内执行js脚本
```python
browser.execute_script()  # 在当前页面内执行js脚本，传入参数是js代码的字符串形式
```

#### 在当前页面内执行异步js脚本
```python
browser.execute_async_script()  # 在当前页面内执行异步js脚本
```

#### 向元素输入指定内容
```python
input_element = browser.find_element(By.XPATH, '')
input_element.send_keys('待输入内容')
```

#### 模拟元素被按下键盘上的指定按键
```python
input_element.send_keys(Keys.ENTER)  # 模拟按下回车键
```

#### 页面截图
获取当前网页页面截图有以下3种方法：
```python
browser.get_screenshot_as_png()
browser.get_screenshot_as_base64()
browser.get_screenshot_as_file('filename.png')
```

用法详解：
```python
pic_data = browser.get_screenshot_as_png()
with open('页面截图.png', 'wb') as f:
    f.write(pic_data)
base64_string = browser.get_screenshot_as_base64()
browser.get_screenshot_as_file('filename.png')
```

#### 元素截图
获取某个元素的截图有以下3种方法：
```python
element.screenshot_as_png
element.screenshot_as_base64
element.screenshot('filename.png')
```

用法详解：
```python
element = browser.find_element(By.XPATH, '')
pic_data = element.screenshot_as_png
with open('filename.png', 'wb') as f:
    f.write(pic_data)
base64_string = element.screenshot_as_base64
element.screenshot('filename.png')
```

#### 添加Cookie实现免登录
不同网站的cookie失效时间不同，一般而言为了安全，很多网站的cookie设置为30min或会话，有的网站也有可能时间更长。总之使用cookie实现免登录的思路就是先保存登录过的页面的cookie至本地，然后下载打开网页时直接添加到webdriver中，刷新后此时webdriver内的页面便是已登录的状态了。
```python
import json
# 首先获取登录后页面的cookie
cookies = browser.get_cookies()
with open('cookies.json', 'w') as f:
    json.dump(cookies, f)

with open('cookies.json', 'r') as f:
    cookies = json.load(f)

for cookie in cookies:
    cookie_dict = {
        'domain': cookie.get('domain'),
        'name': cookie.get('name'),
        'value': cookie.get('value'),
        'expires': cookie.get('expires'),
        'path': '/',
        'httpOnly': False,
        'secure': False
    }
    browser.add_cookie(cookie_dict)
browser.refresh()
```

#### 关闭webdriver
```python
browser.quit()
```

### 等待机制
在使用selenium进行web自动化任务时，有三种等待机制，隐性等待，显性等待，以及`time.sleep`。

#### 隐性等待
```python
browser.implicitly_wait(秒数)  # 全局设置一次即可
```

#### 显性等待
```python
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

WebDriverWait(browser, 10).until(EC.presence_of_element_located((By.XPATH, '')))
```

#### `time.sleep`
```python
import time
time.sleep(秒数)  # 阻塞当前程序内线程，让整个程序停下来，等待已经打开的webdriver内的元素加载完毕
```

### 异常处理机制
在selenium进行web自动化任务过程中，最常见的两个异常分别是：`NoSuchElementException`与`TimeoutException`。对此，我们使用`try except`语句捕获异常进行处理即可，不过，在这之前我们需要先从selenium内的`exceptions`模块中导入这两个异常。
```python
from selenium.common.exceptions import TimeoutException
from selenium.common.exceptions import NoSuchElementException

try:
    element = browser.find_element(By.XPATH, '')
    element.click()
except NoSuchElementException:
    print('无法找到该元素!')
    browser.quit()
```

### ActionChains常用方法
首先，我们需要将`ActionChains`导入并与`webdriver`绑定：
```python
from selenium.webdriver import ActionChains
action = ActionChains(browser)
```

接着对于`action`，我们便可以用来模拟鼠标的一系列复杂动作，如拖动、点击、双击、悬停等。假设我们已经定位到一个元素：
```python
element = browser.find_element(By.XPATH, '')
```

#### 鼠标左键单击元素
```python
action.click(element).perform()
```

#### 鼠标右键单击元素
```python
action.context_click(element).perform()
```

#### 鼠标移动并悬停在元素
```python
action.move_to_element(element).perform()
```

#### 鼠标左键单击长按一个元素
```python
action.click_and_hold(element).perform()
```

#### 双击元素
```python
action.double_click(element).perform()
```

#### 将元素1拖动到元素2上（比如：上传文件）
```python
action.drag_and_drop(element1, element2).perform()
```

#### 模拟鼠标从当前位置按照偏移量移动到指定位置
```python
action.move_by_offset(xoffset, yoffset).perform()
```

#### 将一个元素按照指定偏移量拖转到目的地（滑块验证）
```python
action.drag_and_drop_by_offset(element, xoffset, yoffset).perform()
```

**点击元素时出现`element click intercepted exception`的两个解决办法**
1. 使用webdriver的`execute_script()`方法执行`"arguments[0].click()"`这串js代码
```python
button = browser.find_element(By.XPATH, '')
browser.execute_script('arguments[0].click()', button)
```

2. 使用`ActionChains`的模拟鼠标移动到元素上后单击
```python
action.move_to_element(element).click(element).perform()
```
