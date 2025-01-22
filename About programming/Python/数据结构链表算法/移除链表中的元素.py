# 给你一个链表的头节点head和一个整数value,请你删除链表中所有满足Node.value == value的节点,并返回新的节点
# 示例：
# 输入：head = [1, 2, 6, 3, 4, 5, 6], value = 6
# 输出：[1, 2, 3, 4, 5]
from typing import Optional

class ListNode:
    def __init__(self, value = 0, next = None):
        self.value = value
        self.next = next

class Solution:
    def removeElements(self, head: Optional[ListNode], value: int) -> Optional[ListNode]:
        # 1.定义虚拟头节点
        tmp_head = ListNode(-1) # 虚拟头节点
        tmp_head.next = head
        cur = tmp_head  # 操作节点的指针变量

        # 2.删除节点
        while cur.next is not None:
            if cur.next.value == value:
                cur.next = cur.next.next    # 如果下一个节点值与比较值相同，删除下一个节点
            else:
                cur = cur.next      # 如果下一个节点的值不相同，则移动指针变量
        return tmp_head.next

# 打印链表（从链表头节点开始打印链表的值）
def print_node(head):
    cur = head
    # 遍历每一个节点
    while cur is not None:
        print(cur.value, end='\t')
        cur = cur.next
    print()

if __name__ == '__main__':
    head = ListNode(1)
    head.next = ListNode(2)
    head.next.next = ListNode(3)
    head.next.next.next = ListNode(4)
    head.next.next.next.next = ListNode(5)
    head.next.next.next.next.next = ListNode(6)
    print_node(head)

    s = Solution()
    node = s.removeElements(head, 3)
    print_node(node)