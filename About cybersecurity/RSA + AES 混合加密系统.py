from Crypto.Cipher import AES, PKCS1_OAEP
from Crypto.PublicKey import RSA
from Crypto.Random import get_random_bytes
from Crypto.Util.Padding import pad, unpad
import base64

# 生成RSA密钥对
private_key = RSA.generate(2048)
public_key = private_key.publickey()

# 使用AES加密数据
def encrypt_with_aes(data, aes_key):
    cipher_aes = AES.new(aes_key, AES.MODE_CBC)
    ciphertext = cipher_aes.encrypt(pad(data, AES.block_size))
    return cipher_aes.iv + ciphertext

# 使用RSA加密AES密钥
def encrypt_rsa(aes_key, public_key):
    cipher_rsa = PKCS1_OAEP.new(public_key)
    encrypted_aes_key = cipher_rsa.encrypt(aes_key)
    return encrypted_aes_key

# 解密AES密钥
def decrypt_rsa(encrypted_aes_key, private_key):
    cipher_rsa = PKCS1_OAEP.new(private_key)
    aes_key = cipher_rsa.decrypt(encrypted_aes_key)
    return aes_key

# 解密AES数据
def decrypt_with_aes(ciphertext, aes_key):
    iv = ciphertext[:AES.block_size]    # 提取 iv
    cipher_aes = AES.new(aes_key, AES.MODE_CBC, iv=iv)
    plaintext = unpad(cipher_aes.decrypt(ciphertext[AES.block_size:]), AES.block_size)
    return plaintext

# 原始数据
data = b'249065309hhr'

# 生成AES密钥
aes_key = get_random_bytes(16)

# AES加密数据
encrypted_data = encrypt_with_aes(data, aes_key)

# RSA加密AES密钥
encrypted_aes_key = encrypt_rsa(aes_key, public_key)

# 解密过程
# 使用RSA解密AES密钥
decrypted_aes_key = decrypt_rsa(encrypted_aes_key, private_key)

# 使用AES解密数据
decrypted_data = decrypt_with_aes(encrypted_data, decrypted_aes_key)

print("Original data:", data)
print("Encrypted data (AES + RSA", base64.b64encode(encrypted_data))
print("Encrypted AES key:", base64.b64encode(encrypted_aes_key))
print("Decrypted data:", decrypted_data)
