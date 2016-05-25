//
//  LeftSlideController.h
//  Test0422
//
//  Created by Ranger on 16/4/22.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LeftSortsViewController;

@interface LeftSlideController : UIViewController

@property (nonatomic, assign) BOOL panEnabled;
@property (nonatomic, assign) CGFloat speed; //!< 移动速率 0.5-1  默认0.7

- (instancetype)initWithLeftViewController:(LeftSortsViewController *)leftVC
                        mainViewController:(UIViewController *)mainVC;

- (void)openLeftView;
- (void)closeLeftView;

@end
