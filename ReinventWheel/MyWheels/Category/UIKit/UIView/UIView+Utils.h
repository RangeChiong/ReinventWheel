//
//  UIView+Utils.h
//  CXZKit
//
//  Created by Ranger on 16/5/5.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Utils)

/** 遍历子视图 */
- (void)rw_eachSubview:(void (^)(UIView *subview))block;

/** 移除当前view的所有子视图 */
- (void)rw_removeAllSubviews;

@end

//---------------------------------- 手势 ----------------------------------

@interface UIView (Gesture)

/** 添加tap手势，手势触发后方法 */
- (UITapGestureRecognizer *)rw_tapWithTarget:(id)target action:(SEL)aSelector;

/** 添加tap手势， 触发后在block中执行处理 */
- (void)rw_tapWithHandler:(void (^)(UITapGestureRecognizer *tap))handler;

@end


NS_ASSUME_NONNULL_END