public class SortArr {
    // 冒泡排序
    public static int[] maopao(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - 1 - i; j++) {
                if (arr[j] > arr[j + 1]) {
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                }
            }
        }
        return arr;
    }

    // 选择排序
    public static int[] xuanze(int[] arr) {
        int n = arr.length;
        int minIndex, temp;
        for (int i = 0; i < n - 1; i++) {
            minIndex = i;
            for (int j = i + 1; j < n; j++) {
                if (arr[minIndex] > arr[j]) {
                    minIndex = j;
                }
            }
            if (minIndex != i) {
                temp = arr[i];
                arr[i] = arr[minIndex];
                arr[minIndex] = temp;
            }
        }
        return arr;
    }

    // 插入排序
    public static int[] insertSort(int[] arr) {
        int n = arr.length;
        int perIndex, current;
        for (int i = 1; i < n; i++) {
            current = arr[i];
            perIndex = i - 1;
            while (perIndex >= 0 && current < arr[perIndex]) {
                arr[perIndex + 1] = arr[perIndex];
                perIndex--;
            }
            arr[perIndex + 1] = current;
        }
        return arr;
    }

    public static void main(String[] args) {
        int[] arr = {66, 123, 88, 77, 543, 210};

        int[] new_arr1 = maopao(arr);
        for (int value : new_arr1) {
            System.out.println(value);
        }
        System.out.println();

        int[] new_arr2 = xuanze(arr);
        for (int value : new_arr2) {
            System.out.println(value);
        }
        System.out.println();

        int[] new_arr3 = insertSort(arr);
        for (int value : new_arr3) {
            System.out.println(value);
        }
        System.out.println();
    }
}