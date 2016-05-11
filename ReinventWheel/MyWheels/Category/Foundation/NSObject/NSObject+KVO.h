//
//  NSObject+KVO.h
//  RWKit
//
//  Created by Ranger on 16/5/6.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVO)

/* 
 selector 需要在target中手动实现 形式为 - (void)xxxMethod:(id)anObject change:(id)change
 anObject 为被观察的对象
 change是一个字典
 */
- (void)rw_observe:(id)anObject keyPath:(NSString *)keyPath target:(id)target selector:(SEL)aSelector;

/** 监听对象的属性 block形式 */
- (void)rw_observe:(id)anObject keyPath:(NSString *)keyPath block:(void(^)(id newValue, id oldValue))block;

/** 移除对监听对象的属性监听 */
- (void)rw_removeObserver:(id)anObject keyPath:(NSString *)keyPath;

/** 移除某个监听对象 anObject为空时，调用removeAll*/
- (void)rw_removeObserver:(nullable id)anObject;

/** 移除所有的监听对象 */
- (void)rw_removeAllObserver;

@end

NS_ASSUME_NONNULL_END
