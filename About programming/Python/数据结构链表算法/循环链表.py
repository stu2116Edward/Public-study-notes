'''
循环链表:
循环链表的最后一个节点的指针指向链表的第一个节点，形成一个闭环
循环链表可以是单向的，也可以是双向的
'''
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
    
def delete_node(head):
    if head is None or head is head.next:
        return head
    cur = head
    # 1.找到链表的倒数第2个节点
    while cur.next.next is not head:
        cur = cur.next
    # 2.删除最后节点
    cur.next = head


        
if __name__ == '__main__':
    # 1.创建一个节点组成循环链表
    head = CircularListNode(1)
    head.next = head
    # head = None
    
    # 2.添加节点
    newNode = CircularListNode(2)
    head.next = newNode
    newNode.next = head
    
    tmp = CircularListNode(3)
    head.next.next = tmp
    tmp.next = head
    
    # 3.删除节点
    # 非尾部节点
    head.next = head.next.next
    
    # 尾部节点
    head.next.next = head
    
    # 4.追加链表节点
    root = CircularListNode(11)
    root.next = root    # 构成循环链表
    append_node(root, 12)
    append_node(root, 13)
    append_node(root, 14)
    append_node(root, 15)
    append_node(root, 16)
    
    # 5.打印链表节点
    print_node(root)
    
    # 6.删除链表节点
    delete_node(root)
    print_node(root)
    
    delete_node(root)
    print_node(root)