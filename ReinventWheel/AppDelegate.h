//
//  AppDelegate.h
//  Test0520
//
//  Created by Ranger on 16/5/20.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWScreenShotView.h"
@class RWTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong, readonly) RWScreenShotView *screenshotView;
@property (nonatomic, strong, readonly) RWTabBarController *tabBarController;

@end

