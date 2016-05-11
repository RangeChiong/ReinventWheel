//
//  NSDictionary+Block.m
//  CXZKit
//
//  Created by Ranger on 16/5/5.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "NSDictionary+Block.h"

@implementation NSDictionary (Block)

- (void)cxz_each:(void (^)(id key, id obj))block {
    NSParameterAssert(block != nil);
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key, obj);
    }];
}

- (void)cxz_apply:(void (^)(id key, id obj))block {
    NSParameterAssert(block != nil);
    
    [self enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop) {
        block(key, obj);
    }];
}

- (id)cxz_match:(BOOL (^)(id key, id obj))block {
    NSParameterAssert(block != nil);
    
    return self[[[self keysOfEntriesPassingTest:^(id key, id obj, BOOL *stop) {
        if (block(key, obj)) {
            *stop = YES;
            return YES;
        }
        
        return NO;
    }] anyObject]];
}

- (NSDictionary *)cxz_select:(BOOL (^)(id key, id obj))block {
    NSParameterAssert(block != nil);
    
    NSArray *keys = [[self keysOfEntriesPassingTest:^(id key, id obj, BOOL *stop) {
        return block(key, obj);
    }] allObjects];
    
    NSArray *objects = [self objectsForKeys:keys notFoundMarker:[NSNull null]];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

- (NSDictionary *)cxz_map:(id (^)(id key, id obj))block {
    NSParameterAssert(block != nil);
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.count];
    
    [self cxz_each:^(id key, id obj) {
        id value = block(key, obj) ?: [NSNull null];
        result[key] = value;
    }];
    
    return result;
}


@end
