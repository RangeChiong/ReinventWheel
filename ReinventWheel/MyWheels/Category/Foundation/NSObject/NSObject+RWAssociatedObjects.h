//
//  NSObject+RWAssociatedObjects.h
//  RWKit
//
//  Created by Ranger on 16/5/5.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (RWAssociatedObjects)

/** 关联对象 nonatomically, strong/retain  */
- (void)rw_associateValue:(nullable id)value key:(const void *)key;
/** 关联对象 nonatomically, strong/retain  */
+ (void)rw_associateValue:(nullable id)value key:(const void *)key;

/** 关联对象 atomically, strong/retain  */
- (void)rw_atomicallyAssociateValue:(nullable id)value key:(const void *)key;
/** 关联对象 atomically, strong/retain  */
+ (void)rw_atomicallyAssociateValue:(nullable id)value key:(const void *)key;

/** 关联对象 nonatomically, copy  */
- (void)rw_associateCopyOfValue:(nullable id)value key:(const void *)key;
/** 关联对象 nonatomically, copy  */
+ (void)rw_associateCopyOfValue:(nullable id)value key:(const void *)key;

/** 关联对象 atomically, copy  */
- (void)rw_atomicallyAssociateCopyOfValue:(nullable id)value key:(const void *)key;
/** 关联对象 atomically, copy  */
+ (void)rw_atomicallyAssociateCopyOfValue:(nullable id)value key:(const void *)key;

/** 关联对象 nonatomically, weak  */
- (void)rw_weaklyAssociateValue:(nullable __autoreleasing id)value key:(const void *)key;
/** 关联对象 nonatomically, weak  */
+ (void)rw_weaklyAssociateValue:(nullable __autoreleasing id)value key:(const void *)key;

/** 根据key获取关联对象  */
- (nullable id)rw_associatedValueForKey:(const void *)key;
/** 根据key获取关联对象  */
+ (nullable id)rw_associatedValueForKey:(const void *)key;

/** 关联对象 nonatomically, strong/retain  */
- (void)rw_removeAllAssociatedObjects;
/** 关联对象 nonatomically, strong/retain  */
+ (void)rw_removeAllAssociatedObjects;

@end

NS_ASSUME_NONNULL_END