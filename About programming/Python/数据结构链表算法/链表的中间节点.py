# 获取链表的中间节点(如果有两个中间节点输出后面的那个，即节点个数为偶数个时)
# 示例：
# 输入：head = [1, 2, 3, 4, 5]
# 输出：3
# 输入：head = [1, 2, 3, 4, 5, 6]
# 输出：4
from typing import Optional

class ListNode:
    def __init__(self, value = 0, next = None):
        self.value = value
        self.next = next

class Solution:
    def middleNode(self, head: Optional[ListNode]) -> Optional[ListNode]:
        # 1.定义快慢指针
        fast = head # 快指针
        slow = head # 慢指针

        # 2.移动快慢指针
        while fast is not None and fast.next is not None:
            fast = fast.next.next   # 每次移动2个节点
            slow = slow.next        # 每次移动1个节点

        return slow

if __name__ == '__main__':
    head = ListNode(1)
    head.next = ListNode(2)
    head.next.next = ListNode(3)
    head.next.next.next = ListNode(4)
    head.next.next.next.next = ListNode(5)
    head.next.next.next.next.next = ListNode(6)

    s = Solution()
    node = s.middleNode(head)
    print(node.value)
