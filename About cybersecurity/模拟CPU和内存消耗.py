import time
import random
import threading

# 模拟高CPU占用的任务
def cpu_intensive_task():
    while True:
        # 做一些无意义的计算,消耗CPU
        _ = 3.14159265359 * 2.71828182846
        if time.time() % 5 < 0.1:    # 每5秒输出一次
            print("病毒正在消耗CPU资源...")

# 模拟内存消耗
def memory_intensive_task():
    memory_chunks = []
    while True:
        # 每次创建一个大列表,模拟内存消耗
        large_list = [random.randint(0, 1000000) for _ in range(100000)]
        memory_chunks.append(large_list)    # 将这个列表加入内存
        if len(memory_chunks) % 10 == 0:
            print(f"已分配{len(memory_chunks)}个大内存块，内存消耗增高...")

# 主函数，启动多个线程模拟病毒不同的行为
def main():
    print("病毒实验启动...")

    # 启动多个线程模拟病毒行为
    threads = []

    # 启动CPU消耗线程
    cpu_thread = threading.Thread(target=cpu_intensive_task)
    threads.append(cpu_thread)

    # 启动内存消耗线程
    memory_thread= threading.Thread(target=memory_intensive_task)
    threads.append(memory_thread)

    # 启动所有线程
    for thread in threads:
        thread.start()
    
    # 等待线程结束
    for thread in threads:
        thread.join()

if __name__ == "__main__":
    main()