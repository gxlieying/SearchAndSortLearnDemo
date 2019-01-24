//
//  NSMutableArray+SortMethod.m
//  SearchAndSortDemo
//
//  Created by iOS开发T001 on 2019/1/23.
//  Copyright © 2019 iOS开发. All rights reserved.
//

#import "NSMutableArray+SortMethod.h"
#import <objc/message.h>

@interface NSMutableArray()

@property (nonatomic, copy) GXSortComparator comparator;
@property (nonatomic, copy) GXSortExchangeCallback exchangeCallback;

@end

@implementation NSMutableArray (SortMethod)

- (void)gx_sortUsingComparator:(GXSortComparator)comparator sortType:(GXSortType)sortType didExchange:(GXSortExchangeCallback)exchangeCallback {
    
    self.comparator = comparator;
    
    self.exchangeCallback = exchangeCallback;
    
    switch (sortType) {
        case GXSelectionSort:
            //选择排序
            [self gx_selectionSort];
            break;
        case GXBubbleSort:
            //冒泡排序
            [self gx_bubbleSort];
            break;
        case GXInsertionSort:
            //插入排序
            [self gx_insertionSort];
            break;
        case GXMergeSort:
            //归并排序
            [self gx_mergeSort];
            break;
        case GXQuickSort:
            //快速排序
            [self gx_quickSort];
            break;
        case GXIdenticalQuickSort:
            //双路快速排序
            [self gx_identicalQuickSort];
            break;
        case GXHeapSort:
            //堆排序
            [self gx_heapSort];
            break;
        default:
            break;
    }
}

#pragma mark - 私有排序算法

#pragma mark - /**选择排序*/
- (void)gx_selectionSort {
    for (int i = 0; i < self.count; i++) {
        for (int j = i + 1; j < self.count ; j++) {
            if (self.comparator(self[i],self[j]) == NSOrderedDescending) {
                [self gx_exchangeWithIndexA:i indexB:j didExchange:self.exchangeCallback];
            }
        }
    }
}

#pragma mark - /**冒泡排序*/
- (void)gx_bubbleSort{
    bool swapped;
    do {
        swapped = false;
        for (int i = 1; i < self.count; i++) {
            if (self.comparator(self[i - 1],self[i]) == NSOrderedDescending) {
                swapped = true;
                [self gx_exchangeWithIndexA:i  indexB:i- 1 didExchange:self.exchangeCallback];
            }
        }
    } while (swapped);
}

#pragma mark - /**插入排序*/
- (void)gx_insertionSort{
    for (int i = 0; i < self.count; i++) {
        id e = self[i];
        int j;
        for (j = i; j > 0 && self.comparator(self[j - 1],e) == NSOrderedDescending; j--) {
            [self gx_exchangeWithIndexA:j  indexB:j- 1 didExchange:self.exchangeCallback];
        }
        self[j] = e;
    }
}

#pragma mark - /**归并排序 自顶向下*/
- (void)gx_mergeSort{
    [self gx_mergeSortArray:self LeftIndex:0 rightIndex:(int)self.count - 1];
}
- (void)gx_mergeSortArray:(NSMutableArray *)array LeftIndex:(int )l rightIndex:(int)r{
    if(l >= r) return;
    int mid = (l + r) / 2;
    [self gx_mergeSortArray:self LeftIndex:l rightIndex:mid]; //左边有序
    [self gx_mergeSortArray:self LeftIndex:mid + 1 rightIndex:r]; //右边有序
    [self gx_mergeSortArray:self LeftIndex:l midIndex:mid rightIndex:r]; //再将二个有序数列合并
}

- (void)gx_mergeSortArray:(NSMutableArray *)array LeftIndex:(int )l midIndex:(int )mid rightIndex:(int )r{
    
    // 开辟新的空间 r-l+1的空间
    NSMutableArray *aux = [NSMutableArray arrayWithCapacity:r-l+1];
    for (int i = l; i <= r; i++) {
        // aux 中索引 i-l 的对象 与 array 中索引 i 的对象一致
        // aux[i-l] = array[i];
        [aux addObject:array[i]];
    }
    // 初始化，i指向左半部分的起始索引位置l；j指向右半部分起始索引位置mid+1
    int i = l, j = mid + 1;
    for ( int k = l; k <= r; k++) {
        if (i > mid) { // 如果左半部分元素已经全部处理完毕
            self.comparator(nil, nil);
            self[k] = aux[j - l];
            j++;
        }else if(j > r){// 如果右半部分元素已经全部处理完毕
            self.comparator(nil, nil);
            self[k] = aux[i - l];
            i++;
        }else if(self.comparator(aux[i - l], aux[j - l]) == NSOrderedAscending){// 左半部分所指元素 < 右半部分所指元素
            array[k] = aux[i - l];
            i++;
        }else{
            self.comparator(nil, nil);
            array[k] = aux[j - l];
            j++;
        }
        
        if (self.exchangeCallback) {
            self.exchangeCallback(nil, nil);
        }
    }
    
}
//将有二个有序数列a[first...mid]和a[mid...last]合并。
- (void)GX_mergeSortedArray:(NSMutableArray *)array LeftIndex:(int )l midIndex:(int )mid rightIndex:(int )r
{
    // 开辟新的空间 r-l+1的空间
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:r-l+1];
    // 初始化，i指向左半部分的起始索引位置l；j指向右半部分起始索引位置mid+1
    int i = l, j = mid + 1;
    int m = mid, n = r;
    int k = 0;
    
    while (i <= m && j <= n)
    {
        if (self.comparator(array[i], array[j]) == NSOrderedAscending)// 左半部分所指元素 < 右半部分所指元素
            temp[k++] = array[i++];
        else
            temp[k++] = array[j++];
    }
    
    while (i <= m)
        temp[k++] = array[i++];
    
    while (j <= n)
        temp[k++] = array[j++];
    
    for (i = 0; i < k; i++)
        array[l + i] = temp[i];
}

#pragma mark - /**快速排序*/
- (void)gx_quickSort{
    //要特别注意边界的情况
    [self gx_quickSort:self indexL:0 indexR:(int)self.count - 1];
}
- (void)gx_quickSort:(NSMutableArray *)array indexL:(int)l indexR:(int)r{
    if (l >= r) return;
    int p = [self gx_partition:array indexL:l indexR:r];
    [self gx_quickSort:array indexL:l indexR:p-1];
    [self gx_quickSort:array indexL:p + 1 indexR:r];
}
/**
 对arr[l...r]部分进行partition操作
 返回p, 使得arr[l...p-1] < arr[p] ; arr[p+1...r] > arr[p]
 
 @param array array
 @param l 左
 @param r 右
 @return 返回p
 */
- (int)gx_partition:(NSMutableArray *)array indexL:(int)l indexR:(int)r{
    int j = l;// arr[l+1...j] < v ; arr[j+1...i) > v
    for (int i = l + 1; i <= r ; i++) {
        if ( self.comparator(array[i], array[ l]) == NSOrderedAscending) {
            j++;
            //交换
            [self gx_exchangeWithIndexA:j indexB:i didExchange:self.exchangeCallback];
        }
    }
    self.comparator(nil, nil);
    [self gx_exchangeWithIndexA:j indexB:l didExchange:self.exchangeCallback];
    return j;
}

#pragma mark - /**双路快排*/
///近乎有序数组使用双路排序
- (void)gx_identicalQuickSort{
    //要特别注意边界的情况
    [self gx_quickSort:self indexL:0 indexR:(int)self.count - 1];
}
- (void)gx_identicalQuickSort:(NSMutableArray *)array indexL:(int)l indexR:(int)r{
    if (l >= r) return;
    int p = [self gx_partition2:array indexL:l indexR:r];
    [self gx_quickSort:array indexL:l indexR:p-1];
    [self gx_quickSort:array indexL:p + 1 indexR:r];
}
- (int)gx_partition2:(NSMutableArray *)array indexL:(int)l indexR:(int)r{
    // 随机在arr[l...r]的范围中, 选择一个数值作为标定点pivot
    [self gx_exchangeWithIndexA:l indexB:(arc4random()%(r-l+1)) didExchange:self.exchangeCallback];
    id v = array[l];
    // arr[l+1...i) <= v; arr(j...r] >= v
    int i = l + 1, j = r;
    while (true) {
        
        while (i <= r && self.comparator(array[i],v) == NSOrderedAscending)
            i++;
        
        while (j > l + 1 && self.comparator(array[j],v) == NSOrderedDescending)
            j--;
        
        if (i > j) {
            break;
        }
        [self gx_exchangeWithIndexA:i indexB:j didExchange:self.exchangeCallback];
        
        i++;
        j--;
    }
    [self gx_exchangeWithIndexA:l indexB:j didExchange:self.exchangeCallback];
    
    return j;
}

#pragma mark - /**堆排序*/
- (void)gx_heapSort {
    // copy一份副本，对副本排序。增加的此步与排序无关，仅为增强程序健壮性，防止在排序过程中被中断而影响到原数组。
    NSMutableArray *array = [self mutableCopy];
    
    // 排序过程中不使用第0位
    [array insertObject:[NSNull null] atIndex:0];
    
    // 构造大顶堆
    // 遍历所有非终结点，把以它们为根结点的子树调整成大顶堆
    // 最后一个非终结点位置在本队列长度的一半处
    for (NSInteger index = array.count / 2; index > 0; index --) {
        // 根结点下沉到合适位置
        [array sinkIndex:index bottomIndex:array.count - 1 usingComparator:self.comparator didExchange:self.exchangeCallback];
    }
    
    // 完全排序
    // 从整棵二叉树开始，逐渐剪枝
    for (NSInteger index = array.count - 1; index > 1; index --) {
        // 每次把根结点放在列尾，下一次循环时将会剪掉
        [array gx_exchangeWithIndexA:1 indexB:index didExchange:self.exchangeCallback];
        // 下沉根结点，重新调整为大顶堆
        [array sinkIndex:1 bottomIndex:index - 1 usingComparator:self.comparator didExchange:self.exchangeCallback];
    }
    
    // 排序完成后删除占位元素
    [array removeObjectAtIndex:0];
    
    // 用排好序的副本代替自己
    [self removeAllObjects];
    [self addObjectsFromArray:array];
}

/// 下沉，传入需要下沉的元素位置，以及允许下沉的最底位置
- (void)sinkIndex:(NSInteger)index bottomIndex:(NSInteger)bottomIndex usingComparator:(GXSortComparator)comparator didExchange:(GXSortExchangeCallback)exchangeCallback {
    for (NSInteger maxChildIndex = index * 2; maxChildIndex <= bottomIndex; maxChildIndex *= 2) {
        // 如果存在右子结点，并且左子结点比右子结点小
        if (maxChildIndex < bottomIndex && (comparator(self[maxChildIndex], self[maxChildIndex + 1]) == NSOrderedAscending)) {
            // 指向右子结点
            ++ maxChildIndex;
        }
        // 如果最大的子结点元素小于本元素，则本元素不必下沉了
        if (comparator(self[maxChildIndex], self[index]) == NSOrderedAscending) {
            break;
        }
        // 否则
        // 把最大子结点元素上游到本元素位置
        [self gx_exchangeWithIndexA:index indexB:maxChildIndex didExchange:exchangeCallback];
        // 标记本元素需要下沉的目标位置，为最大子结点原位置
        index = maxChildIndex;
    }
}

#pragma mark -- 交换两个元素
- (void)gx_exchangeWithIndexA:(NSInteger)indexA indexB:(NSInteger)indexB didExchange:(GXSortExchangeCallback)exchangeCallback {
    if (indexA >= self.count || indexB >= self.count ) {
        NSLog(@"indexA:%ld,indexB:%ld",(long)indexA,(long)indexB);
        return;
    }
    id temp = self[indexA];
    self[indexA] = self[indexB];
    self[indexB] = temp;
    
    if (exchangeCallback) {
        exchangeCallback(temp, self[indexA]);
    }
}

#pragma mark - Getter && Setter 给NSMutableArray 类动态添加属性 comparator
- (void)setComparator:(GXSortComparator)comparator{
    // objc_setAssociatedObject（将某个值跟某个对象关联起来，将某个值存储到某个对象中）
    // object:给哪个对象添加属性
    // key:属性名称
    // value:属性值
    // policy:保存策略
    objc_setAssociatedObject(self, @"comparator",comparator, OBJC_ASSOCIATION_COPY);
}
- (GXSortComparator)comparator{
    return objc_getAssociatedObject(self, @"comparator");
}

- (void)setExchangeCallback:(GXSortExchangeCallback)exchangeCallback {
    objc_setAssociatedObject(self, @"exchangeCallback",exchangeCallback, OBJC_ASSOCIATION_COPY);
}
- (GXSortExchangeCallback)exchangeCallback {
    return objc_getAssociatedObject(self, @"exchangeCallback");
}

@end
