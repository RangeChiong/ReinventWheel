//
//  RWSpinner.h
//  RWButton
//
//  Created by Ranger on 16/5/30.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWSpinner : UIView

/** 菊花的线条宽度 */
@property (nonatomic) CGFloat lineWidth;

/** 结束动画时隐藏 */
@property (nonatomic) BOOL hidesWhenStopped;

/** 动画执行方式 默认kCAMediaTimingFunctionEaseInEaseOut */
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

/** 是否正在执行动画 */
@property (nonatomic, readonly) BOOL isAnimating;

/*!
 *  直接传BOOL  根据YES(start animation) 和 NO(stop animation) 来选择开始或停止动画
 */
- (void)setAnimating:(BOOL)animate;

/**
 *  开始动画
 */
- (void)startAnimating;

/**
 *  停止动画
 */
- (void)stopAnimating;


@end
