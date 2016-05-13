//
//  RWTabBarController.m
//  ReinventWheel
//
//  Created by Ranger on 16/5/13.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWTabBarController.h"
#import "RWTabBarPageModel.h"

@interface RWTabBarController ()

@end

@implementation RWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self __initSelf];
}

- (void)__initSelf {
    RWTabBarPageModel *model = [[RWTabBarPageModel alloc] init];
    self.viewControllers = model.controllers;
    self.tabBar.tintColor = Color_Main;
}

@end
