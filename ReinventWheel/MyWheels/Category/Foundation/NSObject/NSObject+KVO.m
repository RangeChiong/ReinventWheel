//
//  NSObject+KVO.m
//  RWKit
//
//  Created by Ranger on 16/5/6.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "NSObject+KVO.h"
@import ObjectiveC.runtime;

#pragma mark-  KVO helper

@interface RWKVOHelper : NSObject {
    @package
    id               _target;       ///< 被观察的对象的值改变时后, target会调用响应方法
    id               _sourceObject; ///< 被观察的对象
    SEL                     _selector;     ///< 被观察的对象的值改变时后的响应方法
    NSString                *_keyPath;     ///< 被观察的对象的keyPath

    void (^_block)(id newValue, id oldValue);        ///< 值改变时执行的block
}

@end

@implementation RWKVOHelper

- (instancetype)initWithObject:(id)anObject keyPath:(NSString *)keyPath target:(id)target selector:(SEL)aSelector {
    if (self == [super init]) {
        _sourceObject = anObject;
        _keyPath      = keyPath;
        _target       = target;
        _selector     = aSelector;
        [_sourceObject addObserver:self
                        forKeyPath:keyPath
                           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                           context:nil];
    }
    return self;
}

- (instancetype)initWithObject:(id)anObject keyPath:(NSString *)keyPath block:(void(^)(id newValue, id oldValue))block {
    if (self = [super init]) {
        _sourceObject = anObject;
        _keyPath      = keyPath;
        _block        = block;
        [_sourceObject addObserver:self
                        forKeyPath:keyPath
                           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                           context:nil];
    }
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (_block)
        _block(change[NSKeyValueChangeNewKey], change[NSKeyValueChangeOldKey]);
        
    if ([_target respondsToSelector:_selector])
        [_target performSelector:_selector withObject:_sourceObject withObject:change];
}

#pragma clang diagnostic pop

@end


#pragma mark-  core part

static const void *NSObject_Observers = &NSObject_Observers;

@interface NSObject (KVOPrivate)

@property (nonatomic, strong) NSMutableDictionary *kvoContainer;

@end

@implementation NSObject (KVO)

- (NSMutableDictionary *)kvoContainer {
    return objc_getAssociatedObject(self, NSObject_Observers) ?: ({
        NSMutableDictionary *dic = [NSMutableDictionary new];
        objc_setAssociatedObject(self, NSObject_Observers, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        dic;
    });
}

#pragma mark-  建立监听

- (void)rw_observe:(id)anObject keyPath:(NSString *)keyPath target:(id)target selector:(SEL)aSelector {
    NSAssert([target respondsToSelector:aSelector], @"selector & target 必须存在");
    NSAssert(keyPath.length > 0, @"keyPath 不能为@\"\"");
    NSAssert(anObject, @"被观察的对象object不能为nil 必须存在");
    
    RWKVOHelper *observer = [[RWKVOHelper alloc] initWithObject:anObject
                                                          keyPath:keyPath
                                                           target:target
                                                         selector:aSelector];
    NSString *key = [NSString stringWithFormat:@"%@_%@", anObject, keyPath];
    self.kvoContainer[key] = observer;
}

- (void)rw_observe:(id)anObject keyPath:(NSString *)keyPath block:(void(^)(id newValue, id oldValue))block {
    NSAssert(block, @"block 不能为nil");
    NSAssert(keyPath.length > 0, @"keyPath 不能为@\"\"");
    NSAssert(anObject, @"被观察的对象object 不能为nil 必须存在");
    
    RWKVOHelper *observer = [[RWKVOHelper alloc] initWithObject:anObject
                                                          keyPath:keyPath
                                                            block:block];
    
    NSString *key = [NSString stringWithFormat:@"%@_%@", anObject, keyPath];
    self.kvoContainer[key] = observer;
}

#pragma mark-  移除监听

- (void)rw_removeObserver:(id)anObject keyPath:(NSString *)keyPath {
    NSString *key = [NSString stringWithFormat:@"%@_%@", anObject, keyPath];
    [self.kvoContainer removeObjectForKey:key];
}

- (void)rw_removeObserver:(id)anObject {
    if (!anObject) {
        [self rw_removeAllObserver];
        return;
    }
    NSString *prefix = [NSString stringWithFormat:@"%@", anObject];
    [self.kvoContainer enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ([key hasPrefix:prefix]) {
            [self.kvoContainer removeObjectForKey:key];
        }
    }];
}

- (void)rw_removeAllObserver {
    [self.kvoContainer removeAllObjects];
}


@end
