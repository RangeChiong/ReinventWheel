//
//  RWPickerView.h
//  Test0606
//
//  Created by Ranger on 16/6/6.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWPickerView : UIView

/**
 *  dataSource内容的类型：NSArray或者NSString
 */
- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource;

/*!
 *  使用xib时  用该方法设置数据源
 */
- (void)setDataSource:(NSArray *)dataSource;

/*!
 *  所选信息的回调
 */
- (void)selectedInfo:(void (^) (NSString *info, NSInteger component))block;

@end
