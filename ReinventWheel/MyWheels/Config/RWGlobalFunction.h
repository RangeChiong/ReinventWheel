//
//  RWGlobalFunction.h
//  ReinventWheel
//
//  Created by 常小哲 on 16/5/12.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/** 主线程运行 */
FOUNDATION_EXTERN void Run_Main(dispatch_block_t RunMain);

/** 异步加载 回到主线程 */
FOUNDATION_EXTERN void Run_Async(dispatch_block_t RunAsync, dispatch_block_t RunMain);

/** 延迟加载 */
FOUNDATION_EXTERN void Run_Delay(CGFloat Seconds ,dispatch_block_t RunDelay);

/** 使用GCD加线程锁  操作完成后加上 dispatch_semaphore_signal(sema) */
FOUNDATION_EXTERN void Run_Lock_GCD(void (^RunLock)(dispatch_semaphore_t sema));

/** 使用OSSpinLock加线程锁 */
FOUNDATION_EXTERN void Run_Lock_OSSpin(dispatch_block_t RunLock);

/** block内代码块执行所花费的时间 */
FOUNDATION_EXTERN void Run_TakeTime (dispatch_block_t block, NSString *message);
