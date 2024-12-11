from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_OAEP
from Crypto.Signature import pkcs1_15
from Crypto.Hash import SHA256

# 生成 RSA 密钥对
key = RSA.generate(2048)
private_key = key
public_key = key.publickey()

# 加密
plaintext = b'Hahaha'
cipher = PKCS1_OAEP.new(public_key)
ciphertext = cipher.encrypt(plaintext)

# 解密
cipher_decrypt = PKCS1_OAEP.new(private_key)
decrypted_text = cipher_decrypt.decrypt(ciphertext)

print("原始文本:", plaintext)
print("加密后的密文:", ciphertext)
print("解密后的文本:", decrypted_text)

# 数字签名
hash_obj = SHA256.new(plaintext)
signature = pkcs1_15.new(private_key).sign(hash_obj)

# 签名验证
try:
    pkcs1_15.new(public_key).verify(hash_obj, signature)
    print("签名验证成功")
except (ValueError, TypeError):
    print("签名验证失败")