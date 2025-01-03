'''
普通链表:
每个节点包含数据和一个指向下一个节点的指针
最后一个节点的指针指向null或None，表示链表的结束
'''
class ListNode:
    def __init__(self, data):
        self.value = data   # 链表的数据域
        self.next = None    # 链表的指针域

# 链表节点封装函数
def insert_node(node, value):
    if node is None:
        return
    # 创建一个新节点
    new_node = ListNode(value)
    cur = node
    while cur.next is not None:
        cur = cur.next    # 移动指针变量
    # 末尾节点的next指针连接新节点
    cur.next = new_node

# 打印链表
def print_node(node):
    cur = node
    # 遍历每一个节点
    while cur is not None:
        print(cur.value, end='\t')
        cur = cur.next
    print()



if __name__ == '__main__':
    # 这里的tmp和head指向的都是同一份链表操作的是同一份数据
    head = ListNode(1)          # 创建第一个节点
    head.next = ListNode(123)   # 更改指针域(指向下一个节点)
    head.next.next = ListNode(456)      # 更改指针域(指向下一个节点)
    head.next.next.next = ListNode(789) # 更改指针域(指向下一个节点)
    
    tmp = head          # 指针变量赋值
    tmp = tmp.next      # 移动指针变量
    tmp.next = None     # 截断链表
    tmp.next = ListNode(100)    # 增加节点
    head.next.next = None

    # 使用链表节点封装函数添加节点
    root = ListNode(10)
    insert_node(root, 20)
    insert_node(root, 30)
    insert_node(root, 40)
    insert_node(root, 50)
    insert_node(root, 60)
    
    # 输出链表
    print_node(root)
    