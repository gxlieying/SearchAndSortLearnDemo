//
//  NSMutableArray+SortMethod.h
//  SearchAndSortDemo
//
//  Created by iOS开发T001 on 2019/1/23.
//  Copyright © 2019 iOS开发. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GXSortType) {
    GXSelectionSort,         //选择排序
    GXBubbleSort,            //冒泡排序
    GXInsertionSort,         //插入排序
    GXMergeSort,             //归并排序
    GXQuickSort,             //原始快速排序
    GXIdenticalQuickSort,    //双路快速排序
    GXHeapSort,              //堆排序
};
typedef NSComparisonResult(^GXSortComparator)(id obj1, id obj2);

typedef void(^GXSortExchangeCallback)(id obj1,id obj2);

@interface NSMutableArray (SortMethod)

/**
 排序方法
 */
- (void)gx_sortUsingComparator:(GXSortComparator)comparator sortType:(GXSortType )sortType didExchange:(GXSortExchangeCallback)exchangeCallback;

/**
 交换两个元素
 */
- (void)gx_exchangeWithIndexA:(NSInteger)indexA indexB:(NSInteger)indexB;
@end

NS_ASSUME_NONNULL_END
