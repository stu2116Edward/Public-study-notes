#include <stdio.h>

// 修改了地址的值就是修改了变量的值，只有对地址进行修改才能作用到变量本身
void swap(int *a, int *b)
{
    int temp = *a;
    *a = *b;
    *b = temp;
}

// 这是错误示例这里的变量a, b是相对独立的只在当前局部变量内生效
// void swap(int a, int b)
// {
//     int temp = a;
//     a = b;
//     b = temp;
// }

int main()
{   
    // 这里的a是变量
    int a = 10;
    // 这里的*b表示这是一个指针用于存储int类型的内存地址
    int *b;
    // 使用&符号用来获取到变量a的内存地址并将其指向b
    b = &a;
    // 或者也可以合并为如下内容
    // int *b = &a;

    // 这里必须使用*b来调用指针变量的值(直接使用b输出的是内存地址)
    printf("变量a的值为：%d\n指针变量b的值为：%d\n", a,*b);
    // printf("%p\n", b);
    // printf("%p\n", &a);
    // 这里修改了指针变量*b的值(地址)的同时同样也会修改变量a的值
    *b = 6;
    // 输出变量a的值为6
    printf("变量a的值为：%d\n", a);

    // 使用swap函数交换两个变量的内容
    int c = 15;
    printf("交换前变量a的值为：%d\n交换前变量c的值为：%d\n", a, c);
    // 注意这里使用的是内存地址
    swap(&a, &c);
    printf("交换后变量a的值为：%d\n交换后变量c的值为：%d\n", a, c);

    // 如何使用数组
    // 注意字符串也是个数组
    // 这里的arr表示的是一个长度为3的地址
    int arr[3] = {1, 3, 5};
    // 获取数组的长度
    int len = sizeof(arr) / sizeof(arr[0]);
    // 输出默认指向数组中第一个内存地址
    printf("%d\n", *arr);
    // 演示变量数组 
    for (int i = 0; i < len; i++)
    {   
        // 这里*(arr + 1) 和 arr[1]是一样的
        // 指针移位加往左减往右
        printf("%d\n", *(arr + i));
        // printf("%d\n", arr[i]);
    }

    // 使用地址作运算并存储在指针变量中输出的是位移后的值
    int *value = arr + 1;
    printf("值：%d\n", *value);
    printf("值：%d\n", *(value + 1));
    // 这里*(value + 1) 和 value[1]是一样的
    printf("值：%d\n", value[1]);
    printf("地址：%p\n", (void*)value);
    // // 数组名和指针唯一的区别就是数组名不能被重新赋值而指针可以
    // int arr[3] = {1, 2, 3};
    // // 正确：将指针ptr指向数组arr的首地址
    // int *ptr = arr;
    // // 错误：数组名不能被重新赋值
    // arr = 1;
    // // 字符串的操作也和数组是类似的
}