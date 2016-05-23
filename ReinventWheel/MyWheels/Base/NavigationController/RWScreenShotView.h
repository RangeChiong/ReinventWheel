//
//  RWScreenShotView.h
//  ReinventWheel
//
//  Created by Ranger on 16/5/13.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWScreenShotView : UIView


+ (instancetype)addToWindow:(UIWindow *)window;

- (UIImage *)screenShot;
- (void)setContentImage:(UIImage *)image;

@end
