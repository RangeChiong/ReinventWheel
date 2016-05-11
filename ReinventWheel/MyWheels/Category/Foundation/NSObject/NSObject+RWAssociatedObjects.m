//
//  NSObject+RWAssociatedObjects.m
//  RWKit
//
//  Created by Ranger on 16/5/5.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "NSObject+RWAssociatedObjects.h"
@import ObjectiveC.runtime;

#pragma mark - Weak support

@interface RWWeakAssociatedHelper : NSObject

@property (nonatomic, weak) id value;

@end

@implementation RWWeakAssociatedHelper

@end


@implementation NSObject (rwAssociatedObjects)

#pragma mark-  关联nonatomically, strong/retain对象

- (void)rw_associateValue:(id)value key:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)rw_associateValue:(id)value key:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark-  关联atomically, strong/retain对象

- (void)rw_atomicallyAssociateValue:(id)value key:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}

+ (void)rw_atomicallyAssociateValue:(id)value key:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark-  关联nonatomically, copy对象

- (void)rw_associateCopyOfValue:(id)value key:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void)rw_associateCopyOfValue:(id)value key:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark-  关联atomically, copy对象

- (void)rw_atomicallyAssociateCopyOfValue:(id)value key:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY);
}

+ (void)rw_atomicallyAssociateCopyOfValue:(id)value key:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY);
}

#pragma mark-  关联weak对象

- (void)rw_weaklyAssociateValue:(__autoreleasing id)value key:(const void *)key {
    RWWeakAssociatedHelper *assoc = objc_getAssociatedObject(self, key);
    if (!assoc) {
        assoc = [RWWeakAssociatedHelper new];
        [self rw_associateValue:assoc key:key];
    }
    assoc.value = value;
}

+ (void)rw_weaklyAssociateValue:(__autoreleasing id)value key:(const void *)key{
    RWWeakAssociatedHelper *assoc = objc_getAssociatedObject(self, key);
    if (!assoc) {
        assoc = [RWWeakAssociatedHelper new];
        [self rw_associateValue:assoc key:key];
    }
    assoc.value = value;
}

#pragma mark-  获取关联对象

- (id)rw_associatedValueForKey:(const void *)key {
    id value = objc_getAssociatedObject(self, key);
    if (value && [value isKindOfClass:[RWWeakAssociatedHelper class]]) {
        return [(RWWeakAssociatedHelper *)value value];
    }
    return value;
}

+ (id)rw_associatedValueForKey:(const void *)key {
    id value = objc_getAssociatedObject(self, key);
    if (value && [value isKindOfClass:[RWWeakAssociatedHelper class]]) {
        return [(RWWeakAssociatedHelper *)value value];
    }
    return value;
}

#pragma mark-  remove 关联

- (void)rw_removeAllAssociatedObjects {
    objc_removeAssociatedObjects(self);
}

+ (void)rw_removeAllAssociatedObjects {
    objc_removeAssociatedObjects(self);
}

@end
