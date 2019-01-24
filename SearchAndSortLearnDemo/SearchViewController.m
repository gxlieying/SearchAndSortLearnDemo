//
//  SearchViewController.m
//  SearchAndSortDemo
//
//  Created by iOS开发T001 on 2019/1/22.
//  Copyright © 2019 iOS开发. All rights reserved.
//

#import "SearchViewController.h"

#define MAXSIZE (10)

typedef struct BiTNode {
    int data;
    struct BiTNode *lchild,*rchild;
} BiTNode, *BiTree;

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    int a[MAXSIZE+1];
    int array[MAXSIZE+1]={0,1,16,24,35,47,59,62,73,88,99};
    int i,key;
    
    for(i=0;i<=MAXSIZE;i++)
    {
        a[i]=i;
    }
    
    key=5;
    printf("从数组a中查找%d的地址为%d\n",key,Sequential_Search(a,MAXSIZE,key));
    
    key=7;
    printf("从数组a中查找%d的地址为%d\n",key,Sequential_Search2(a,MAXSIZE,key));
    
    key=47;
    printf("从数组array中查找%d的地址为%d\n",key,Binary_Search(array,MAXSIZE,key));
    
    key = 99;
    printf("从数组array中查找%d的地址为%d\n",key,Fibonacci_Search(array,MAXSIZE,key));
    
}


/**
 顺序查找(无哨兵)
 函数名称：Sequential_Search(int *a,int n,int key)
 函数参数：
 a---待查找数组指针,
 n---待查找数组中元素个数,
 key---查找关键字
 函数说明：顺序查找(无哨兵),当成功查找时返回关键字在记录中的位置，当没有查找时返回0.
 */
int Sequential_Search(int *a,int n,int key)
{
    int i;
    for(i=1;i<=n;i++)
    {
        if(a[i]==key)
            return i;
    }
    return 0;
}

/**
 顺序查找(含哨兵)
 函数名称：Sequential_Search2(int *a,int n,int key)
 函数参数：
 a---待查找数组指针,
 n---待查找数组中元素个数,
 key---查找关键字
 函数说明：顺序查找(含哨兵),当成功查找时返回关键字在记录中的位置，当没有查找时返回0.
 */
int Sequential_Search2(int *a,int n,int key)
{
    a[0]=key;
    int i=n;
    while(a[i]!=key)
    {
        i--;
    }
    return i;
}

/**折半查找(二分查找)
 函数参数:a----数组
 length-----数组长度(从0开始)
 key----关键字
 */

int Binary_Search(int*a,int length,int key) {
    int low=0,high=length-1;
    int mid;
    while(low<=high)
    {
        mid=(low+high)/2;
//        mid = (high - low) * (key -a[low])/(a[high]-a[low]);// 插值查找
        if(key<a[mid])
        {
            high=mid-1;
        }
        else if(key>a[mid])
        {
            low=mid+1;
        }
        else
        {
            return mid;
        }
    }
    return 0;
}

/** 斐波那契查找
 函数参数:a----数组
 length-----数组长度(从0开始)
 key----关键字
 */
int Fibonacci_Search(int *a,int n,int key) {
    int low,high,mid,i,k;
    low = 1;
    high = n;
    k=0;
    while (n > Fbi(k) - 1) {
        k++;
    }
    for (i = n; i < Fbi(k) - 1; i++) {
        a[i] = a[n];
    }
    while (low <= high) {
        mid = low + Fbi(k-1) - 1;
        if (key < a[mid]) {
            high = mid - 1;
            k = k - 1;
        } else if (key > a[mid]) {
            low = mid + 1;
            k = k -2;
        } else {
            if (mid <= n) {
                return mid;
            } else {
                return n;
            }
        }
    }
    return 0;
}
/* 斐波那契的递归函数*/
int Fbi(int i) {
    if (i < 2) {
        return i == 0 ? 0 : 1;
    }
    return Fbi(i-1) + Fbi(i - 2);
}

#pragma mark -- 二叉排序树
// 递归查找二叉排序树T中是否存在key
BOOL SearchBST(BiTree T, int key, BiTree f, BiTree *p) {
    if (!T) {
        *p = f;
        return FALSE;
    } else if (key == T->data) {
        *p = T;
        return TRUE;
    } else if (key < T->data) {
        return SearchBST(T->lchild, key, T, p);
    } else {
        return SearchBST(T->rchild, key, T, p);
    }
}
// 二叉排序树插入操作
BOOL InserBST(BiTree *T, int key) {
    BiTree p,s;
    if (!SearchBST(*T, key, NULL, &p)) {// 查找不成功
        s = (BiTree)malloc(sizeof(BiTNode));
        s->data = key;
        s->lchild = s->rchild = NULL;
        if (!p) {
            *T = s;
        } else if (key < p->data) {
            p->lchild = s;
        } else {
            p->rchild = s;
        }
        return TRUE;
    } else
        return FALSE;
}

// 二叉排序树删除
BOOL DeleteBST(BiTree *T,int key) {
    if (!*T) {
        return FALSE;
    } else {
        if (key == (*T)->data) {
            return Delete(T);
        } else if (key < (*T)->data) {
            return DeleteBST(&(*T)->lchild, key);
        } else
            return DeleteBST(&(*T)->rchild, key);
    }
}
// 从二叉排序树中删除节点p，并重接它的左或右子树
BOOL Delete(BiTree *p) {
    BiTree q,s;
    if ((*p)->rchild == NULL) {
        q = *p;
        *p = (*p)->lchild;
        free(q);
    } else if ((*p)->lchild == NULL) {
        q = *p;
        *p = (*p)->rchild;
        free(q);
    } else {
        q = *p;
        s = (*p)->lchild;
        while (s->rchild) {
            q = s;
            s = s->rchild;
        }
        (*p)->data = s->data;
        if (q != *p) {
            q->rchild = s->lchild;
        } else {
            q->lchild = s->lchild;
        }
        free(s);
    }
    return TRUE;
}
@end
