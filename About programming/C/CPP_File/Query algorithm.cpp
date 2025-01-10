#include <iostream>
using namespace std;

// 顺序查找
int SequenceSearch(int arr[], int value, int n)
{
    for (int i = 0; i < n; i++)
    {
        if (arr[i] == value)
        {
            return i;
        }
    }
    return -1;
}

// 冒泡排序
void maopao(int arr[], int n)
{
    for (int i = 0; i < n - 1; i++)
    {
        for (int j = 0; j < n - 1; j++)
        {
            if (arr[j] > arr[j + 1])
            {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

// 二分查找(折半)
int BinarySearch1(int arr[], int value, int n)
{
    int low, high, mid;
    low = 0;
    high = n;
    while (low <= high)
    {
        mid = (low + high) / 2;
        if (arr[mid] == value)
            return mid;
        if (arr[mid] > value)
            high = mid - 1;
        if (arr[mid] < value)
            low = mid + 1;
    }
    return -1;
}

// 二分查找(递归)
int BinarySearch2(int arr[], int value, int low, int high) {
    if (low > high) {
        return -1;
    }
    int mid = low + (high - low) / 2;
    if (arr[mid] == value) {
        return mid;
    } else if (arr[mid] > value) {
        return BinarySearch2(arr, value, low, mid - 1);
    } else {
        return BinarySearch2(arr, value, mid + 1, high);
    }
}

// 插值查找
int InsertionSearch(int arr[], int value, int low, int high) {
    if (low > high) {
        return -1;  // 递归终止条件：查找区间为空
    }
    if (arr[low] == arr[high]) {
        if (value == arr[low]) {
            return low;  // 如果值相等，返回low
        } else {
            return -1;  // 否则，返回-1表示未找到
        }
    }
    // 防止整数溢出，使用更安全的计算方式
    int mid = low + (value - arr[low]) * (high - low) / (arr[high] - arr[low]);
    if (arr[mid] == value) {
        return mid;  // 找到值，返回索引
    } else if (arr[mid] > value) {
        return InsertionSearch(arr, value, low, mid - 1);  // 值在左侧，递归查找
    } else {
        return InsertionSearch(arr, value, mid + 1, high);  // 值在右侧，递归查找
    }
}

int main()
{
    int arr1[6] = {66, 123, 88, 77, 543, 210};
    int len = sizeof(arr1) / sizeof(arr1[0]);

    int index1 = SequenceSearch(arr1, 88, len);
    cout << "88的索引为：" << index1 << endl;

    maopao(arr1, len);
    for (int i = 0; i < len; i++)
    {
        cout << arr1[i] << " ";
    }
    cout << endl;

    int index2 = BinarySearch1(arr1, 77, len);
    cout << "排序后77的索引为：" << index2 << endl;

    int index3 = BinarySearch2(arr1, 77, 0, len - 1);
    cout << "排序后77的索引为：" << index3 << endl;

    int index4 = InsertionSearch(arr1, 210, 0, len - 1);
    cout << "排序后210的索引为：" << index4 << endl;

    return 0;
}
