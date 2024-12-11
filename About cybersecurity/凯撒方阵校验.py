def caesar_encrypt(plaintext, key):
    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    # 生成凯撒方阵
    matrix = []
    for i in range(26):
        row = alphabet[i:] + alphabet[:i]
        matrix.append(row)
    
    # 将密钥转换为对应的位移值
    shift_values = [alphabet.index(c) for c in key]

    encrypted_text = []

    for i, char in enumerate(plaintext):
        shift = shift_values[i % len(key)]
        row = alphabet.index(char)
        encrypted_text.append(matrix[shift][row])

    return "".join(encrypted_text)

# 示例
plaintext = "HELLOWORLD"
key = "PASSWORD"
encrypted_text = caesar_encrypt(plaintext, key)
print("Encrypted Text:", encrypted_text)