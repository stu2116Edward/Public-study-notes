'''
约瑟夫问题，是一个计算机科学和数学中的问题在计算机编程的算法中，类似问题又称为约瑟夫环：
N个人围成一圈，从第一个开始报数，第M个将被杀掉，最后剩下一个人，其余人都将被杀掉
例如：N=6, M=5 被杀的顺序是：5, 4, 6, 2, 3
'''

# 循环链表:
class CircularListNode():
    def __init__(self, data):
        self.value = data   # 链表节点的数据域
        self.next = None    # 链表节点的指针域
        
def append_node(head, value):
    if head is None:
        return
    cur = head
    # 1.移动指针变量到末尾节点
    while cur.next is not head:
        cur = cur.next
    # 2.将新节点追加到末尾节点
    new_node = CircularListNode(value)
    cur.next = new_node
    new_node.next = head    # 更改末尾节点的指向

def print_node(head):
    if head is None:
        return
    cur = head.next
    if head is cur:     # 只有一个节点
        print(cur.value)
        return
    # 1.打印头节点
    print(head.value, end='\t')
    # 2.遍历打印下一个节点
    while cur is not head:
        print(cur.value, end='\t')
        cur = cur.next
    print()

# 删除操作，删除第k个节点(返回删除的节点)
def remove_node(head, k):
    if head is None or head is head.next:
        return head
    # 情况1：删除的节点为头节点
    if k == 0:
        cur = head
        # 找到末尾节点
        while cur.next is not head:
            cur = cur.next
        # 更改末尾节点的指针域
        cur.next = head.next
        return head
    # 情况2：删除的节点为非头节点
    cur = head
    for i in range(k - 1):
        cur = cur.next
    temp = cur.next     # 删除的节点
    cur.next = cur.next.next    # 删除节点操作
    return temp      # 返回删除的节点

def josephus(N, M):
    # 1.创建一个循环链表
    head = CircularListNode(1)
    head.next = head    # 构成循环链表
    # 2. 添加节点
    for i in range(1, N):
        append_node(head, i + 1)
    print_node(head)
    
    # 3.依次删除链表节点
    for j in range(N):
        node = remove_node(head, M - 1)
        print(node.value, end='\t')
        head = node.next    # 下次开始时，开始节点为删除节点的下一个节点
    print()

        
if __name__ == '__main__':
    # 第二行输出的最后一位就是存活的节点
    josephus(6, 5)
