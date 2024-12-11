import hashlib
import os

# 文件路径(用于保存用户数据)
USER_DATA_FILE = "user_data.txt"

# 加密函数
def hash_password(password):
    # 使用 SHA-256 对密码进行加密
    return hashlib.sha256(password.encode()).hexdigest()

# 注册函数
def register():
    username = input("请输入用户名：")
    password = input("请输入密码：")
    hashed_password = hash_password(password)

    # 检查用户是否已存在
    if os.path.exists(USER_DATA_FILE):
        with open(USER_DATA_FILE, "r") as f:
            for line in f:
                existing_user, _=line.strip().split(":")
                if existing_user == username:
                    print("用户已存在，请选择其他用户名！")
                    return
                
    # 保存用户数据
    with open(USER_DATA_FILE, "a") as f:
        f.write(f"{username}:{hashed_password}\n")
    print("注册成功!")

# 登录函数
def login():
    username = input("请输入用户名：")
    password = input("请输入密码：")
    hashed_password = hash_password(password)
    
    # 验证用户信息
    if os.path.exists(USER_DATA_FILE):
        with open(USER_DATA_FILE, "r") as f:
            for line in f:
                existing_user, stored_hashed_password = line.strip().split(":")
                if existing_user == username:
                    if stored_hashed_password == hashed_password:
                        print("登录成功!")
                        return
                    else:
                        print("密码错误!")
                        return
    print("用户名不存在!")

# 主函数
def main():
    while True:
        print("\n身份认证系统")
        print("1.注册")
        print("2.登录")
        print("3.退出")
        choice = input("请选择操作：")

        if choice == "1":
            register()
        elif choice == "2":
            login()
        elif choice == "3":
            print("退出系统,再见!")
            break
        else:
            print("无效选择,请重试!")

if __name__ == "__main__":
    main()
