//
//  AppDelegate.m
//  ReinventWheel
//
//  Created by Ranger on 16/5/11.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "AppDelegate.h"

static void *RWObserveTabBarViewMove = &RWObserveTabBarViewMove;

@interface AppDelegate () {
    NavigationControllerPopStyle _popStyle;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.rootViewController = self.tabBarController;
    
    return YES;
}

- (void)prepareForPop {
    if (_popStyle == NavigationControllerPopStyle_FullScreenPan) {
        _screenshotView = [[RWScreenShotView alloc] initWithFrame:CGRectMake(0, 0, _window.size.width, _window.size.height)];
        [_window insertSubview:_screenshotView atIndex:0];
        
        [_window.rootViewController.view addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:RWObserveTabBarViewMove];
        
        _screenshotView.hidden = YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == RWObserveTabBarViewMove) {
        NSValue *value  = [change objectForKey:NSKeyValueChangeNewKey];
        CGAffineTransform newTransform = [value CGAffineTransformValue];
        [_screenshotView showEffectChange:CGPointMake(newTransform.tx, 0) ];
    }
}

#pragma mark-   Setter & Getter

- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    return _window;
}

- (RWTabBarController *)tabBarController {
    if (_tabBarController) {
        return _tabBarController;
    }
    // 创建好Navigation 设置是否需要FullScreenStyle 然后赋值
    _tabBarController = [[RWTabBarController alloc] init];
    if ([_tabBarController.viewControllers[0] isKindOfClass:[RWNavigationController class]]) {
        RWNavigationController *nav = _tabBarController.viewControllers[0];
        _popStyle = nav.popStyle;
        [self prepareForPop];
    }
    
    return _tabBarController;
}

#pragma mark-  app delegate

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
