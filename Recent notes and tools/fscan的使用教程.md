扫描全部模块  
```
fscan.exe -h <目标IP>  
```
例如：  
```
fscan.exe -h 192.168.3.110
```
扫描A段  
```
fscan.exe -h 192.168.3.110/8
```
扫描B段  
```
fscan.exe -h 192.168.3.110/16
```
扫描C段  
```
fscan.exe -h 192.168.3.110/24
```
ssh 爆破成功后，命令执行  
```
fscan.exe -h 192.168.3.110/32 -c whoami
```