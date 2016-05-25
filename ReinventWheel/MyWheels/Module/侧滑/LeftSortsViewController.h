//
//  LeftSortsViewController.h
//  Test0422
//
//  Created by Ranger on 16/4/22.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSortsViewController : UIViewController

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat showRightViewWidth; //!< tableView x坐标 同时也是右视图露出的宽度

@end
