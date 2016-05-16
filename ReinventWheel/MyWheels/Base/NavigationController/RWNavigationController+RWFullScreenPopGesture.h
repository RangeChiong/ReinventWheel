//
//  RWNavigationController+RWFullScreenPopGesture.h
//  ReinventWheel
//
//  Created by Ranger on 16/5/16.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWNavigationController.h"

@interface RWNavigationController (RWFullScreenPopGesture)

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *rw_fullscreenPopGestureRecognizer;

@property (nonatomic, assign) BOOL rw_viewControllerBasedNavigationBarAppearanceEnabled;

@end

@interface UIViewController (rwFullscreenPopGesture)

@property (nonatomic, assign) BOOL rw_interactivePopDisabled;

@property (nonatomic, assign) BOOL rw_prefersNavigationBarHidden;

@property (nonatomic, assign) CGFloat rw_interactivePopMaxAllowedInitialDistanceToLeftEdge;

@end
