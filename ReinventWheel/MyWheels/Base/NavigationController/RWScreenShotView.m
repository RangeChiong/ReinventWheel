//
//  RWScreenShotView.m
//  ReinventWheel
//
//  Created by Ranger on 16/5/13.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWScreenShotView.h"

static void *RWObserveTabBarViewMove = &RWObserveTabBarViewMove;

@interface RWScreenShotView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *imgView;  //!< 截屏的图片存放

@end

@implementation RWScreenShotView

- (void)dealloc {
    NSLog(@"---dealloc--");
}

+ (instancetype)addToWindow:(UIWindow *)window {
    return [[RWScreenShotView alloc] initWithWindow:window];
}

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.frame = [UIScreen mainScreen].bounds;
        self.hidden = YES;
        [self addSubview:self.imgView];
        [self addSubview:self.maskView];
        [window insertSubview:self atIndex:0];
        
        [window.rootViewController.view addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:RWObserveTabBarViewMove];
    }
    return self;
}

- (UIImage *)screenShot {
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, 0);
    [[UIApplication sharedApplication].delegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];
    _imgView.image = sendImage;
    _imgView.transform = CGAffineTransformMakeScale(0.95, 0.95);
//    你释放下你试试
//    CGImageRelease(imageRef);
    
    return sendImage;
}

- (void)setContentImage:(UIImage *)image {
    _imgView.image = image;
}

#pragma mark-  KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
        if (context == RWObserveTabBarViewMove) {
            NSValue *value  = [change objectForKey:NSKeyValueChangeNewKey];
            CGAffineTransform newTransform = [value CGAffineTransformValue];
            [self showEffectChange:CGPointMake(newTransform.tx, 0) ];
        }
}

- (void)showEffectChange:(CGPoint)pt {
    if (pt.x > 0) {
        _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:-pt.x / self.bounds.size.width * 0.4 + 0.4];
        _imgView.transform = CGAffineTransformMakeScale(0.95 + (pt.x / self.bounds.size.width * 0.05), 0.95 + (pt.x / self.bounds.size.width * 0.05));
    }
}

#pragma mark-   Setter & Getter

- (UIImageView *)imgView {
    if (_imgView) {
        return _imgView;
    }
    _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    return _imgView;
}

- (UIView *)maskView {
    if (_maskView) {
        return _maskView;
    }
    _maskView = [[UIView alloc] initWithFrame:self.bounds];
    _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.4];
    return _maskView;
}

@end
