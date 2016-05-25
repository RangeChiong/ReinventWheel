//
//  NSDictionary+Extensions.h
//  RWKit
//
//  Created by Ranger on 16/5/5.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Extensions)

/** 快速遍历 */
- (void)rw_each:(void (^)(id key, id obj))block;

/** 无序遍历 速度up */
- (void)rw_apply:(void (^)(id key, id obj))block;

/** 匹配一个需要的对象，返回nil或者匹配到的对象 */
- (nullable id)rw_match:(BOOL (^)(id key, id obj))block;

/** 匹配多个对象，将满足条件的对象返回成一个新的字典 */
- (NSDictionary *)rw_select:(BOOL (^)(id key, id obj))block;

/** 遍历字典，将每个对象处理后返回成一个新的字典 */
- (NSDictionary *)rw_map:(id (^)(id key, id obj))block;

@end

@interface NSMutableDictionary<ObjectType, KeyType> (Safe)

- (void)rw_setObject:(ObjectType)anObject forKey:(KeyType <NSCopying>)aKey;

@end

NS_ASSUME_NONNULL_END
