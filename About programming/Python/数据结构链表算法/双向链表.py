'''
双向链表：
每个节点包含数据和两个指针，一个指向前一个节点，一个指向后一个节点。
这种链表可以方便地从任一方向遍历(双向遍历)
任何需要频繁进行插入，删除操作，并且需要保持元素顺序的数据结构，都可能是双向链表的应用场景
'''
# 定义双向链表节点
class DoubleListNode:
    def __init__(self, data):
        self.value = data      # 双向链表的数据域
        self.prev = None    # 双向链表的后向指针域
        self.next = None    # 双向链表的前向指针域

# 封装双向链表
class DoubleList:
    def __init__(self):
        self.head = None
        self.tail = None
    # 添加节点(尾部)
    def insert_at_end(self, value):
        new_node = DoubleListNode(value)
        if self.head is None and self.tail is None:
            self.head = new_node
            self.tail = new_node
            return
        # 新节点添加到尾部  
        self.tail.next = new_node
        new_node.prev = self.tail
        self.tail = new_node    # 更新链表的tail节点

    # 添加节点(头部)
    def insert_at_start(self, value):
        new_node = DoubleListNode(value)
        if self.head is None and self.tail is None:
            self.head = new_node
            self.tail = new_node
            return
        # 新节点添加到头部
        new_node.next = self.head
        self.head.prev = new_node
        self.head = new_node    # 更新链表的head节点

    # 双向链表遍历(从前往后)
    def print_at_start(self):
        cur = self.head
        while cur is not None:
            print(cur.value, end='\t')
            cur = cur.next
        print()

    # 双向链表遍历(从后往前)
    def print_at_end(self):
        cur = self.tail
        while cur is not None:
            print(cur.value, end='\t')
            cur = cur.prev
        print()

    # 删除节点(每次只删除一个节点)
    def delete(self, value):
        cur = self.head
        while cur is not None:
            if cur.value == value:
                # 删除节点为：头节点
                if cur.prev is None:
                    self.head = cur.next
                    cur.next = None
                    self.head.prev = None
                    return
                # 删除节点为：尾节点
                if cur.next is None:
                    self.tail = cur.prev
                    cur.prev = None
                    self.tail.next = None
                    return
                # 普通节点删除（删除节点为cur指向的当前节点）
                cur.prev.next = cur.next
                cur.next.prev = cur.prev
                return

            cur = cur.next



if __name__ == '__main__':
    head = DoubleListNode(1)
    
    # 1.添加节点
    new_node1 = DoubleListNode(2)
    head.next = new_node1   # 链表指针衔接：后向
    new_node1.prev = head   # 链表指针衔接：前向
    
    new_node2 = DoubleListNode(3)
    head.next.next = new_node2  # 链表指针衔接：后向
    new_node2.prev = head.next  # 链表指针衔接：前向
    
    # 2.遍历链表节点
    # 向后遍历
    print(head.value)
    print(head.next.value)
    print(head.next.next.value)
    # 向前遍历
    cur = head.next.next
    print(cur.value)
    print(cur.prev.value)
    print(cur.prev.prev.value)
    
    # 3.删除节点(删除值为2的节点)
    head.next = head.next.next
    head.next.prev = head
    
    # 4.添加链表节点(尾部)
    root = DoubleList()
    root.insert_at_end(1)
    root.insert_at_end(2)
    root.insert_at_end(3)
    root.insert_at_end(4)
    root.insert_at_end(5)
    
    # 5.添加链表节点(头部)
    root.insert_at_start(10)
    root.insert_at_start(20)
    root.insert_at_start(30)
    root.insert_at_start(40)
    root.insert_at_start(50)

    # 6.打印链表节点的值
    print("打印链表从前往后的输出：")
    root.print_at_start()
    print("打印链表从后往前的输出：")
    root.print_at_end()

    # 7.删除节点
    print("删除链表中的头节点：")
    root.delete(50)
    root.print_at_start()

    print("删除链表中的尾节点：")
    root.delete(5)
    root.print_at_start()

    print("删除链表中的普通节点：")
    root.delete(1)
    root.print_at_start()

    print("删除链表中不存在的节点：")
    root.delete(100)
    root.print_at_start()
    print()