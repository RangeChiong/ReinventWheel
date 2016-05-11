//
//  NSTimer+Block.m
//  CXZKit
//
//  Created by Ranger on 16/5/5.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "NSTimer+Block.h"

@implementation NSTimer (Block)

+ (instancetype)cxz_scheduleTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)rep usingBlock:(void (^)(NSTimer *timer))block {
    NSTimer *timer = [self cxz_timerWithTimeInterval:ti repeats:rep usingBlock:block];
    [NSRunLoop.currentRunLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    return timer;
}

+ (instancetype)cxz_timerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)rep usingBlock:(void (^)(NSTimer *t))block {
    
    NSParameterAssert(block != nil);
    CFAbsoluteTime seconds = fmax(ti, 0.0001);
    CFAbsoluteTime interval = rep ? seconds : 0;
    CFAbsoluteTime fireDate = CFAbsoluteTimeGetCurrent() + seconds;
    return (__bridge_transfer NSTimer *)CFRunLoopTimerCreateWithHandler(NULL, fireDate, interval, 0, 0, (void(^)(CFRunLoopTimerRef))block);
    
}

@end
