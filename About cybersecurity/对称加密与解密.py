from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes

#生成密钥和初始化向量
key = get_random_bytes(16) #16字节密钥
cipher = AES.new(key, AES.MODE_EAX)

plaintext = b'Hahaha'
nonce = cipher.nonce
ciphertext,tag =cipher.encrypt_and_digest(plaintext)

#解密
cipher_decrypt = AES.new(key, AES.MODE_EAX, nonce=nonce)
decrypted_text = cipher_decrypt.decrypt(ciphertext)

print("原始文本：",plaintext)
print("加密后的密文：",ciphertext)
print("解密后的文本：",decrypted_text)