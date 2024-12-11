import hashlib
import os, re

def hash_password(password):
    salt = os.urandom(16)
    hashed_password = hashlib.sha256(salt + password.encode()).hexdigest()
    return salt, hashed_password

def verify_password(stored_salt, stored_hash, password):
    new_hash = hashlib.sha256(stored_salt + password.encode()).hexdigest()
    return new_hash == stored_hash

def check_password_strength(password):
    if len(password) < 8:
        return "密码长度至少8位"
    if not re.search("[A-Z]", password):
        return "密码至少需要一个大写字母"
    if not re.search("[0-9]", password):
        return "密码至少需要一个数字"
    if not re.search("[!@#$%^&*(),.?\":{}|<>]", password):
        return "密码至少需要一个特殊字符"
    return "Password is strong."

# 存储密码
password = "stu2116Hhr2705?"
salt, hashed_password = hash_password(password)
print(f"Stored Salt: {salt.hex()}")
print(f"Stored Hashed Password: {hashed_password}")

# # 验证密码
password_to_verify = "stu2116Hhr2705?"
is_valid = verify_password(salt, hashed_password, password_to_verify)
print(f"Password is valid: {is_valid}")

# 校验密码强度
print(check_password_strength(password))