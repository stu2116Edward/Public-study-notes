import re

def search_files(file_path, search_string):
    encodings = ['utf-8', 'gbk', 'latin-1']  # 可能的编码格式
    pattern = re.compile(search_string)
    result = []

    for encoding in encodings:
        try:
            with open(file_path, 'r', encoding=encoding) as file:
                for i, line in enumerate(file, 1):
                    if pattern.search(line):
                        result.append(f"{i}: {line}")
            break  # 如果成功打开文件，则跳出循环
        except UnicodeDecodeError:
            continue  # 如果解码错误，则尝试下一个编码格式

    if not result:
        result.append("没有找到")

    return result

file_path = 'list.txt'  # 替换为实际的文件路径
search_string = '字符串'  # 替换为要查找的字符串

lines = search_files(file_path, search_string)
for line in lines:
    print(line)
