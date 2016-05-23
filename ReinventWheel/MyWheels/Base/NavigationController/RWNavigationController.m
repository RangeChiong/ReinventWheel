//
//  RWNavigationController.m
//  ReinventWheel
//
//  Created by Ranger on 16/5/12.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWNavigationController.h"
#import "RWBaseViewController.h"
#import "AppDelegate.h"

static CGFloat const PopDistance = 80;

@interface RWNavigationController ()<
UIGestureRecognizerDelegate,
UINavigationControllerDelegate> {
    
}

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;  //!< 侧滑手势
@property (nonatomic ,strong) NSMutableArray *arrayScreenshot;


@end

@implementation RWNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _arrayScreenshot = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setPopStyle:(NavigationControllerPopStyle)popStyle {
    _popStyle = popStyle;
    
    switch (popStyle) {
        case NavigationControllerPopStyle_None:
            //TODO:
            break;
            
        case NavigationControllerPopStyle_ForceEdgePan: {
            __weak typeof(self) weakSelf = self;
            if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.interactivePopGestureRecognizer.delegate = weakSelf;
                self.delegate = weakSelf;
            }
            
            break;
        }
        case NavigationControllerPopStyle_FullScreenPan: {
            //屏蔽系统的手势
            self.interactivePopGestureRecognizer.enabled = NO;
            [self.view addGestureRecognizer:self.panGesture];

            break;
        }
        default:
            break;
    }
}

- (UIPanGestureRecognizer *)panGesture {
    if (_panGesture) {
        return _panGesture;
    }
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _panGesture.delegate = self;
    return _panGesture;
}

#pragma mark-   touch action

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootVC = appdelegate.window.rootViewController;
    UIViewController *presentedVC = rootVC.presentedViewController;
    if (self.viewControllers.count == 1) {
        return;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            appdelegate.screenshotView.hidden = NO;
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint point_inView = [pan translationInView:self.view];
            
            if (point_inView.x >= 10) {
                rootVC.view.transform = CGAffineTransformMakeTranslation(point_inView.x - 10, 0);
                presentedVC.view.transform = CGAffineTransformMakeTranslation(point_inView.x - 10, 0);
            }

            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            CGPoint point_inView = [pan translationInView:self.view];
            if (point_inView.x >= PopDistance) {
                [UIView animateWithDuration:0.3 animations:^{
                    rootVC.view.transform = CGAffineTransformMakeTranslation(320, 0);
                    presentedVC.view.transform = CGAffineTransformMakeTranslation(320, 0);
                } completion:^(BOOL finished) {
                    [self popViewControllerAnimated:NO];
                    rootVC.view.transform = CGAffineTransformIdentity;
                    presentedVC.view.transform = CGAffineTransformIdentity;
                    appdelegate.screenshotView.hidden = YES;
                }];
            }
            else {
                [UIView animateWithDuration:0.3 animations:^{
                    rootVC.view.transform = CGAffineTransformIdentity;
                    presentedVC.view.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    appdelegate.screenshotView.hidden = YES;
                }];
            }

            break;
        }
        default:
            break;
    }
}

#pragma mark-  UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.view == self.view) {
        if (_popStyle == NavigationControllerPopStyle_FullScreenPan) {
            RWBaseViewController *topView = (RWBaseViewController *)self.topViewController;
            
            if (!topView.enablePanGesture)
                return NO;
            else  {
                CGPoint translate = [gestureRecognizer translationInView:self.view];
                
                BOOL possible = translate.x != 0 && fabs(translate.y) == 0;
                return possible;
            }
        }
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (_popStyle == NavigationControllerPopStyle_FullScreenPan) {
        //设置该条件是避免跟tableview的删除，筛选界面展开的左滑事件有冲突
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]
            || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")] ) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark-  UINavigationControllerDelegate

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    switch (_popStyle) {
        case NavigationControllerPopStyle_None:
            //TODO:
            break;
            
        case NavigationControllerPopStyle_ForceEdgePan: {
            if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
                self.interactivePopGestureRecognizer.enabled = NO;
            break;
        }
        case NavigationControllerPopStyle_FullScreenPan: {

            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [self.arrayScreenshot addObject:[appdelegate.screenshotView screenShot]];
            break;
        }
        default:
            break;
    }
    // 隐藏二级页面的tabbar
    if (self.viewControllers.count > 0)
        viewController.hidesBottomBarWhenPushed = YES;
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (_popStyle == NavigationControllerPopStyle_FullScreenPan) {
        [_arrayScreenshot removeLastObject];
        UIImage *image = [_arrayScreenshot lastObject];
        
        if (image) {
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdelegate.screenshotView setContentImage:image];
        }
    }
    return [super popViewControllerAnimated:animated];
}


- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
    switch (_popStyle) {
        case NavigationControllerPopStyle_None:
            //TODO: 
            break;
            
        case NavigationControllerPopStyle_ForceEdgePan: {
            if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
                self.interactivePopGestureRecognizer.enabled = YES;
            break;
        }
        case NavigationControllerPopStyle_FullScreenPan:
            
            break;
            
        default:
            break;
    }
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    if (_popStyle == NavigationControllerPopStyle_FullScreenPan) {
        if (_arrayScreenshot.count > 2) {
            [_arrayScreenshot removeObjectsInRange:NSMakeRange(1, self.arrayScreenshot.count - 1)];
        }
        UIImage *image = [_arrayScreenshot lastObject];
        if (image) {
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdelegate.screenshotView setContentImage:image];
        }
    }

    return [super popToRootViewControllerAnimated:animated];
}


- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *arr = [super popToViewController:viewController animated:animated];

    if (_popStyle == NavigationControllerPopStyle_FullScreenPan) {
        if (_arrayScreenshot.count > arr.count) {
            for (int i = 0; i < arr.count; i++) {
                [_arrayScreenshot removeLastObject];
            }
        }
    }
    return arr;
}

@end
