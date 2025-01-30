package src.day20250130;

public class QueryAlgorithms {
    public static void main(String[] args) {
        int[] arr1 = {1, 4, 23, 56};
        System.out.println(orderSearch(arr1, 5));
        System.out.println(binarySearch(arr1, 23));
    }

    // 顺序查找
    public static int orderSearch(int[] arr, int keyWord) {
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] == keyWord) {
                return i;
            }
        }
        return -1;
    }

    // 折半查找（针对有序序列）：
    public static int binarySearch(int[] arr, int keyWord) {
        int low = 0;
        int height = arr.length - 1;
        int mid;
        while (low <= height) {
            mid = (low + height) / 2;
            if (arr[mid] > keyWord) {
                height = mid - 1;
            } else if (arr[mid] < keyWord) {
                low = mid + 1;
            } else if (arr[mid] == keyWord) {
                return mid;
            }
        }
        return -1;
    }
}
