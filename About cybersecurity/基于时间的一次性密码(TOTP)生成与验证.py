import pyotp
import time

# 生成密钥，通常在用户注册时生成并保存
secret = pyotp.random_base32()
print(f"密钥：{secret}")

# 生成一个基于时间的动态口令(TOTP)
totp = pyotp.TOTP(secret)

# 获取当前的动态口令
current_otp = totp.now()
print(f"当前生成的动态口令：{current_otp}") 

# 验证动态口令
def verify_otp(input_otp):
    if totp.verify(input_otp):
        print("动态口令验证成功")
    else:
        print("动态口令验证失败")

# 测试验证过程
user_input = input("请输入动态口令进行验证：")
verify_otp(user_input)

# 模拟一定时间后的口令变化
print("\n等待 10 秒后，获取新的动态口令...")
time.sleep(10)

# 生成新的动态口令
new_otp = totp.now()
print(f"新的动态口令：{new_otp}")
