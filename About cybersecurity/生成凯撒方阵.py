def generate_caesar_matrix():
    matrix = []
    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for i in range(len(alphabet)):
        row = alphabet[i:] + alphabet[:i]  # 循环移位
        matrix.append(row)
    return  matrix

# 打印凯撒方阵
caesar_matrix = generate_caesar_matrix()
for row in caesar_matrix:
    print(row)