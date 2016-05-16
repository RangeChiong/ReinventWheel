//
//  AppDelegate.h
//  ReinventWheel
//
//  Created by Ranger on 16/5/11.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWScreenShotView.h"
#import "RWTabBarController.h"
#import "RWNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) RWScreenShotView *screenshotView;
@property (nonatomic, strong) RWTabBarController *tabBarController;

@end

