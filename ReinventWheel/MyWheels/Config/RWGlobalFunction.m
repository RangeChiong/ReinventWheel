//
//  RWGlobalFunction.m
//  ReinventWheel
//
//  Created by 常小哲 on 16/5/12.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWGlobalFunction.h"
#import <mach/mach_time.h>
#import <libkern/OSAtomic.h>

#pragma mark-   在主线程加载

void Run_Main(dispatch_block_t RunMain) {
    dispatch_async(dispatch_get_main_queue(), ^{
        RunMain();
    });
}

#pragma mark-   异步加载 回到主线程刷新UI

void Run_Async(dispatch_block_t RunAsync, dispatch_block_t RunMain) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RunAsync();
        if (RunMain) Run_Main(RunMain);
    });
}

#pragma mark-   延迟加载

void Run_Delay(CGFloat Seconds ,dispatch_block_t RunDelay) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RunDelay();
    });
}

#pragma mark-   线程加锁

void Run_Lock_GCD(void (^RunLock)(dispatch_semaphore_t sema)) {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    RunLock(sema);
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

void Run_Lock_OSSpin(dispatch_block_t RunLock) {
    OSSpinLock spinLock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&spinLock);
    RunLock();
    OSSpinLockUnlock(&spinLock);
}

#pragma mark-   检查block内执行的代码块花费的时间 来判断是否需要优化

void Run_TakeTime (dispatch_block_t block, NSString *message) {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) {
        block();
        return;
    };
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    NSLog(@"%s: Took [%f] seconds to [%@]", __PRETTY_FUNCTION__, (CGFloat)nanos / NSEC_PER_SEC, message);
}
