//
//  SortMethodClass.m
//  SearchAndSortDemo
//
//  Created by iOS开发T001 on 2019/1/23.
//  Copyright © 2019 iOS开发. All rights reserved.
//

#import "SortMethodClass.h"

#define MAXSIZE 10 // 用于要排序数组个数最大值，可根据需要修改
#define MAX_LENGTH_INSERT_SORT 7 // 数组长度阈值

typedef struct {
    int r[MAXSIZE+1];// 用于存储要排序的数组，r[0]用作哨兵
    int length; // 用于记录顺序表的长度
}SqList;

@implementation SortMethodClass
#pragma mark -- 冒泡排序
// 时间复杂度为O(n^2)
void BubbleSort0(SqList *L) {
    int i,j;
    for (i = 1; i < L->length; i++) {
        for (j = i+1; j <= L->length; j++) {
            if (L->r[i] > L->r[j]) {
                swap(L, i, j);
            }
        }
    }
}

void BubbleSort1(SqList *L) {
    int i,j;
    for (i = 1; i < L->length; i++) {
        for (j = L->length-1; j >= i; j--) {
            if (L->r[j] > L->r[j+1]) {
                swap(L, j, j+1);
            }
        }
    }
}

void BubbleSort2(SqList *L) {
    int i,j;
    BOOL flag = TRUE;// flag用来作为标记
    for (i = 1; i < L->length && flag; i++) {
        flag = FALSE;
        for (j = L->length-1; j>=i; j--) {
            if (L->r[j] > L->r[j+1]) {
                swap(L, j, j+1);
                flag = TRUE;
            }
        }
    }
}

#pragma mark -- 简单选择排序
// 时间复杂度O(n^2)
void SelectSort(SqList *L) {
    int i,j,min;
    for (i = 1; i < L->length; i++) {
        min = i;
        for (j = i+1; j <= L->length; j++) {
            if (L->r[min] > L->r[j]) {
                min = j;
            }
        }
        if (i != min) {
            swap(L, i, min);
        }
    }
}

#pragma mark -- 直接插入排序
// 时间复杂度O(n^2)
void InsertSort(SqList *L) {
    int i,j;
    for (i = 2; i <= L->length; i++) {
        if (L->r[i] < L->r[i-1]) {
            L->r[0] = L->r[i];
            for (j = i-1; L->r[j] > L->r[0]; j--) {
                L->r[j+1] = L->r[j];
            }
            L->r[j+1] = L->r[0];
        }
    }
}

#pragma mark -- 希尔排序
// 时间复杂度O(n^(3/2))
void ShellSort(SqList *L) {
    int i,j;
    int increment = L->length;
    do {
        increment = increment/3+1;
        for (i = increment+1; i <= L->length; i++) {
            if (L->r[i] < L->r[i-increment]) {
                L->r[0] = L->r[i];
                for (j = i-increment; j>0 && L->r[0] < L->r[j]; j-=increment) {
                    L->r[j+increment] = L->r[j];
                }
                L->r[j+increment] = L->r[0];
            }
        }
    } while (increment>1);
}

#pragma mark -- 堆排序
// 时间复杂度O(nlogn)
void HeapSort(SqList *L) {
    int i;
    for (i = L->length/2; i > 0; i--) {// 把L中的r构建成一个大顶堆
        HeapAdjust(L,i,L->length);
    }
    
    for (i = L->length; i > 1; i--) {
        swap(L, 1, i);
        HeapAdjust(L,1,i-1);
    }
}

// 调整L->r[s]的关键字，使L->r[s..m]成为一个大顶堆
void HeapAdjust(SqList *L,int s, int m) {
    int temp,j;
    temp = L->r[s];
    for (j = 2*s; j <= m; j*= 2) {
        if (j < m && L->r[j] < L->r[j+1]) {
            ++j;
        }
        if (temp >= L->r[j]) {
            break;
        }
        L->r[s] = L->r[j];
        s=j;
    }
    L->r[s] = temp;
}

#pragma mark -- 归并排序
// 时间复杂度O(nlogn),空间复杂度O(n+logn)
/* 递归归并排序*/
void MergeSort(SqList *L) {
    MSort(L->r, L->r, 1, L->length);
}
// 将SR[s..t]归并排序为TR1[s..t]
void MSort(int SR[], int TR1[],int s,int t) {
    int m;
    int TR2[MAXSIZE+1];
    if (s==t) {
        TR1[s] = SR[s];
    } else {
        m = (s+t)/2;
        MSort(SR, TR2, s, m);
        MSort(SR, TR2, m+1, t);
        Merge(TR2,TR1,s,m,t);
    }
}

/* 非递归归并排序*/
// 空间复杂度O(n)
void MergeSort2(SqList *L) {
    int *TR = (int *)malloc(L->length*sizeof(int));
    int k = 1;
    while (k < L->length) {
        MergePass(L->r, TR, k, L->length);
        k = 2*k;
        MergePass(TR, L->r, k, L->length);
        k = 2*k;
    }
}
void MergePass(int SR[],int TR[],int s,int n) {
    int i = 1;
    int j;
    while (i <= n-2*s+1) {
        Merge(SR, TR, i, i+s-1, i+2*s-1);// 两两归并
        i = i+2*s;
    }
    if (i < n-s+1) {// 归并最后两个u序列
        Merge(SR, TR, i, i+s-1, n);
    } else {
        for (j = i; j <= n; j++) {
            TR[j] = SR[j];
        }
    }
}

// 将有序的SR[i..m]和SR[m+1..n]归并p为有序的TR[i..m]
void Merge(int SR[],int TR[],int i,int m,int n) {
    int j,k,l;
    for (j = m+1,k=i;i <= m && j <= n; k++) {
        if (SR[i] < SR[j]) {
            TR[k] = SR[i++];
        } else {
            TR[k] = SR[j++];
        }
    }
    if (i <= m) {
        for (l = 0; l <= m-i; l++) {
            TR[k+1] = SR[i+1];
        }
    }
    if (j <= n) {
        for (l = 0; l <= n-j; l++) {
            TR[k+1] = SR[j+1];
        }
    }
}

#pragma mark -- 快速排序
// 时间复杂度O(nlogn),空间复杂度O(nlogn)
void QuickSort(SqList *L) {
    QSort(L, 1, L->length);
}
// 对顺序表L中子序列L->r[low..high]作快速排序
void QSort(SqList *L,int low,int high) {
    int pivot;
    if ((high-low) > MAX_LENGTH_INSERT_SORT) {
        while (low<high) {
            pivot = Partition(L, low, high);
            QSort(L,low,pivot-1);// 对低子表递归排序
            low = pivot + 1;// 尾递归
        }
    } else// 当high-low小于等于常数时直接插入排序
        InsertSort(L);
}
// 交换顺序表L中子表的记录，使枢纽记录到位，并返回其所在位置
int Partition(SqList *L,int low,int high) {
    int pivotkey;
    int m = low + (high - low) / 2;
    if (L->r[low] > L->r[high]) {
        swap(L, low, high);
    }
    if (L->r[m] > L->r[high]) {
        swap(L, high, m);
    }
    if (L->r[m] > L->r[low]) {
        swap(L, m, low);
    }
    /* 此时L.r[low]已经为整个序列左中右三个关键字的中间值*/
    pivotkey = L->r[low];
    L->r[0] = pivotkey;
    while (low < high) {
        while (low < high && L->r[high] > pivotkey) {
            high--;
        }
        L->r[low] = L->r[high];// 将比枢纽记录小的记录交换到低端
        while (low < high && L->r[low] <= pivotkey) {
            low++;
        }
        L->r[high] = L->r[low];// 将比枢纽记录大的记录交换到高端
    }
    L->r[low] = L->r[0];// 将枢纽数值替换回L.r[low];
    return low;
}

#pragma mark -- 交换L中数组r的下标为i和j的值
void swap(SqList *L,int i,int j) {
    int temp = L->r[i];
    L->r[i] = L->r[j];
    L->r[j] = temp;
}

@end
