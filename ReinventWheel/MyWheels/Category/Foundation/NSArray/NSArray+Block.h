//
//  NSArray+Block.h
//  RWKit
//
//  Created by Ranger on 16/5/5.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Block)

/** 快速遍历 enumerateObjects */
- (void)rw_each:(void (^)(id obj))block;

/** 无序遍历 处理任务速度更快 */
- (void)rw_apply:(void (^)(id obj))block;

/** 匹配一个需要的对象，返回nil或者匹配到的对象  */
- (nullable id)rw_match:(BOOL (^)(id obj))block;

/** 匹配多个对象，将满足条件的对象返回成一个新的数组 */
- (NSArray *)rw_select:(BOOL (^)(id obj))block;

/** 将数组中的对象遍历出来，处理后返回成一个新的数组 */
- (NSArray *)rw_map:(id (^)(id obj))block;

@end

NS_ASSUME_NONNULL_END