//
//  RWScreenShotView.m
//  ReinventWheel
//
//  Created by Ranger on 16/5/13.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWScreenShotView.h"
#import "AppDelegate.h"

@interface RWScreenShotView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) NSMutableArray *arrayImage;

@end

@implementation RWScreenShotView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];

        _arrayImage = [NSMutableArray array];
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.4];
        
        [self addSubview:_imgView];
        [self addSubview:_maskView];
    }
    return self;
}
- (void)showEffectChange:(CGPoint)pt {
    if (pt.x > 0) {
        _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:-pt.x / 320.0 * 0.4 + 0.4];
        _imgView.transform = CGAffineTransformMakeScale(0.95 + (pt.x / 320.0 * 0.05), 0.95 + (pt.x / 320.0 * 0.05));
    }
}

- (void)restore {
    if (_maskView && _imgView) {
        _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.4];
        _imgView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
}

- (void)screenShot {
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(Screen_Width, Screen_Height), YES, 0);
    [appdelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];
    _imgView.image = sendImage;
    _imgView.transform = CGAffineTransformMakeScale(0.95, 0.95);
}
                                           
@end
