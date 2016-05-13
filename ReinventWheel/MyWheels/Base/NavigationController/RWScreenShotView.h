//
//  RWScreenShotView.h
//  ReinventWheel
//
//  Created by Ranger on 16/5/13.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWScreenShotView : UIView

@property (nonatomic, strong) UIImageView *imgView;  //!< 截屏的图片存放

- (void)showEffectChange:(CGPoint)pt;
//- (void)restore;
//- (void)screenShot;

@end
