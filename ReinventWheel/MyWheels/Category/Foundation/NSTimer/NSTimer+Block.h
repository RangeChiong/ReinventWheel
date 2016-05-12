//
//  NSTimer+Block.h
//  RWKit
//
//  Created by Ranger on 16/5/5.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Block)

+ (instancetype)rw_scheduleTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)rep usingBlock:(void (^)(NSTimer *timer))block;
+ (instancetype)rw_timerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)rep usingBlock:(void (^)(NSTimer *t))block;

@end

NS_ASSUME_NONNULL_END