import os
import time
from datetime import datetime

# 定义用户权限
permissions = {
    "hhr1": ["read", "write", "delete"],
    "hhr2": ["read", "write"],
    "hhr3": ["read"]
}

# 审计日志函数
def log_action(user, action, file):
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    with open("audit_log.txt", "a") as log:
        log.write(f"{timestamp} = 用户：{user}， 操作：{action}, 文件：{file}\n")
# 文件访问函数
def access_file(user, file, action):
    if action in permissions.get(user, []):
        print(f"允许操作：{action} 文件 {file}")
        log_action(user, action, file)
        if action == "read":
            with open(file, "r") as f:
                print(f.read())
        elif action == "write":
            with open(file, "a") as f:
                f.write("\nNew data written by" + user)
        elif action == "delete":
            os.remove(file)
            print()
        return True
    else:
        print(f"权限不足：{user} 无法执行 {action} 操作")
        log_action(user, "unauthorized", file)
        return False

# 实验模拟
file_path = "test_file"
if not os.path.exists(file_path):
    with open(file_path, "w") as f:
        f.write("初始内容")

# 循环输入
while True:
    user = input("请输入用户(hhr1/hhr2/hhr3)或输入")
    if user.lower() == "exit":
        print("退出程序")
        break
    
    if user not in permissions:
        print("无效的用户角色，请重新输入！")
        continue

    action = input("请输入操作(read/write/delete)：")
    if action not in ["read", "write", "delete"]:
        print("无效的操作，请重新输入！")
        continue
    access_file(user, file_path, action)