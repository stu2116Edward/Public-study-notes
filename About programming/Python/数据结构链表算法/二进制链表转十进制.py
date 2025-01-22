class ListNode:
    def __init__(self, value = 0, next = None):
        self.value = value
        self.next = next

class Solution:
    def getDecimalValue(self, head: ListNode) -> int:
        if head is None:
            return 0
        # 1.定义操作节点的指针变量
        res = head.value    # 赋值为1个节点的值
        cur = head.next     # 指向第2个节点

        # 2.移动操作节点指针变量，计算二进制的值
        while cur is not None:
            res = res * 2 + cur.value   # 右侧每增加一个数，需对原来的数乘上2再加上新对应的数
            cur = cur.next  # 移动指针变量

        return res

if __name__ == '__main__':
    # 这个链表是 0 0 1
    head = ListNode(1)
    head.next = ListNode(0)
    head.next.next = ListNode(0)

    s = Solution()
    value = s.getDecimalValue(head)
    print(value)
