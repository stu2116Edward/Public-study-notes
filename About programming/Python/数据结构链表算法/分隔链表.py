# 给定一个链表的头节点head和一个特定值x,请你对链表进行分隔，使得所有小于x的节点都出现在大于或等于x的节点之前
# 示例：
# 输入：head = [1, 4, 3, 2, 5, 2], x = 3
# 输出：[1, 2, 2, 4, 3, 5]
from typing import Optional

class ListNode:
    def __init__(self, value = 0, next = None):
        self.value = value
        self.next = next

# 打印链表（从链表头节点开始打印链表的值）
def print_node(head):
    cur = head
    # 遍历每一个节点
    while cur is not None:
        print(cur.value, end='\t')
        cur = cur.next
    print()

class Solution:
    def partition(self, head: Optional[ListNode], x: int) -> Optional[ListNode]:
        # 1.定义虚拟头节点与指针变量
        small_head = ListNode(-1)   # 较小值链表的虚拟头节点
        small_cur = small_head      # 较小值链表的操作指针变量

        large_head = ListNode(-1)   # 较大值链表的虚拟头节点
        large_cur = large_head      # 较大值链表的操作指针变量

        cur = head # 源链表的操作指针变量

        # 2.循环比较链表的节点值
        while cur is not None:
            if cur.value < x:
                small_cur.next = cur    # 将当前节点衔接到较小值链表中
                small_cur = cur         # 移动操作节点指针变量
            else:
                large_cur.next = cur    # 将当前节点衔接到较大值链表中
                large_cur = cur         # 移动操作节点指针变量

            cur = cur.next          # 移动当前操作节点的指针变量

        # 3.处理较小值、较大值链表
        large_cur.next = None   # 较大值组成的链表，末尾指向Null
        small_cur.next = large_head.next    # 衔接2个链表

        return small_head.next

if __name__ == '__main__':
    head = ListNode(1)
    head.next = ListNode(4)
    head.next.next = ListNode(3)
    head.next.next.next = ListNode(2)
    head.next.next.next.next = ListNode(5)
    head.next.next.next.next.next = ListNode(2)
    print_node(head)

    s = Solution()
    node = s.partition(head, 3)
    print_node(node)