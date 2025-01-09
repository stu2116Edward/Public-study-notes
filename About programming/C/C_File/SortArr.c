# include <stdio.h>

// 冒泡排序
int *maopao(int arr[], int n)
{
    for (int i = 0; i < n - 1; i++)
    {
        for (int j = 0; j < n - 1 - i; j++)
        {
            if (arr[j] > arr[j + 1])
            {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
    return arr;
}

// 选择排序
int *xuanze(int arr[], int n)
{   
    int minIndex, temp;
    for (int i = 0; i < n - 1; i++)
    {
        minIndex = i;
        for (int j = i + 1; j < n; j++)
        {
            if (arr[minIndex] > arr[j])
            {
                minIndex = j;
            }
        }
        if (minIndex != i)
        {
            temp = arr[i];
            arr[i] = arr[minIndex];
            arr[minIndex] = temp;
        }
    }
    return arr;
}

// 插入排序
int *insertSort(int arr[], int n)
{
    int perIndex, current;
    for (int i = 1; i < n; i++)
    {
        current = arr[i];
        perIndex = i - 1;
        while (perIndex >= 0 && current < arr[perIndex])
        {
            arr[perIndex + 1] = arr[perIndex];
            perIndex--;
        }
        arr[perIndex + 1] = current;
    }
    return arr;
}

int main()
{
    int arr1[6] = {66, 123, 88, 77, 543, 210};
    // 获取到数组的长度
    int n = sizeof(arr1) / sizeof(arr1[0]);

    // 对数组进行冒泡排序并遍历
    int *new_arr1 = maopao(arr1, n);
    for (int i = 0; i < n; i++) {
        printf("%d ", new_arr1[i]);
    }
    printf("\n");

    // 对数组进行选择排序并遍历
    int *new_arr2 = xuanze(arr1, n);
    for (int i = 0; i < n; i++) {
        printf("%d ", new_arr2[i]);
    }
    printf("\n");

    // 对数组进行插入排序并遍历
    int *new_arr3 = insertSort(arr1, n);
    for (int i = 0; i < n; i++) {
        printf("%d ", new_arr3[i]);
    }
    printf("\n");

    return 0;
}