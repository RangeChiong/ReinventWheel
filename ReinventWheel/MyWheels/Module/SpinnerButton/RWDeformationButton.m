//
//  RWDeformationButton.m
//  RWButton
//
//  Created by Ranger on 16/5/30.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWDeformationButton.h"

@interface RWDeformationButton () {
    CGFloat _defaultW;
    CGFloat _defaultH;
    CGFloat _defaultR;
    CGFloat _scale;
}

@property (nonatomic, strong) UIView *bgView;

@end

@implementation RWDeformationButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetting];
    }
    return self;
}

//
//- (CGRect)frame {
//    CGRect frame = [super frame];
////    CGRectMake((SELF_WIDTH-286)/2+146, SELF_HEIGHT-84, 140, 36)
////    self.forDisplayButton.frame = frame;
//    return frame;
//}

- (void)initSetting{
    _scale = 1.2;
    [self addSubview:self.bgView];
    
    _defaultW = _bgView.frame.size.width;
    _defaultH = _bgView.frame.size.height;
    _defaultR = _bgView.layer.cornerRadius;
    
    [self addSubview:self.spinnerView];
    [self addSubview:self.forDisplayButton];
    [self addTarget:self action:@selector(loadingAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark-   Setter & Getter

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor blueColor];
        _bgView.userInteractionEnabled = NO;
        _bgView.hidden = YES;
    }
    return _bgView;
}

- (RWSpinner *)spinnerView {
    if (!_spinnerView) {
        RWSpinner *spinnerView = [[RWSpinner alloc] initWithFrame:CGRectZero];
        _spinnerView = spinnerView;
        _spinnerView.bounds = CGRectMake(0, 0, _defaultH*0.8, _defaultH*0.8);
        _spinnerView.tintColor = [UIColor whiteColor];
        _spinnerView.lineWidth = 2;
        _spinnerView.center = CGPointMake(CGRectGetMidX(self.layer.bounds), CGRectGetMidY(self.layer.bounds));
        _spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
        _spinnerView.userInteractionEnabled = NO;
    }
    return _spinnerView;
}

- (UIButton *)forDisplayButton {
    if (!_forDisplayButton) {
        _forDisplayButton = [[UIButton alloc] initWithFrame:self.bounds];
        _forDisplayButton.userInteractionEnabled = NO;
    }
    return _forDisplayButton;
}

-(void)setContentColor:(UIColor *)contentColor{
    _contentColor = contentColor;
    _bgView.backgroundColor = contentColor;
}

-(void)setProgressColor:(UIColor *)progressColor{
    _progressColor = progressColor;
    _spinnerView.tintColor = progressColor;
}

-(void)setIsLoading:(BOOL)isLoading{
    _isLoading = isLoading;
    if (_isLoading) {
        [self startLoading];
    }else{
        [self stopLoading];
    }
}

- (void)loadingAction {
    if (self.isLoading) {
        [self stopLoading];
    }else{
        [self startLoading];
    }
}

- (void)startLoading {
    _isLoading = YES;
    
    _bgView.hidden = NO;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = @(_defaultR);
    animation.toValue = @(_defaultH * _scale * 0.5);
    animation.duration = 0.2;
    [_bgView.layer setCornerRadius:_defaultH * _scale * 0.5];
    [_bgView.layer addAnimation:animation forKey:@"cornerRadius"];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _bgView.layer.bounds = CGRectMake(0, 0, _defaultW * _scale, _defaultH * _scale);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _bgView.layer.bounds = CGRectMake(0, 0, _defaultH * _scale, _defaultH * _scale);
            _forDisplayButton.transform = CGAffineTransformMakeScale(0, 0);
            _forDisplayButton.alpha = 0;
        } completion:^(BOOL finished) {
            _forDisplayButton.hidden = YES;
            [_spinnerView startAnimating];
        }];
    }];
}

- (void)stopLoading {
    [_spinnerView stopAnimating];
    _forDisplayButton.hidden = NO;
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:
     UIViewAnimationOptionCurveLinear animations:^{
         _forDisplayButton.transform = CGAffineTransformMakeScale(1, 1);
         _forDisplayButton.alpha = 1;
     } completion:^(BOOL finished) {
     }];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _bgView.layer.bounds = CGRectMake(0, 0, _defaultW * _scale, _defaultH * _scale);
    } completion:^(BOOL finished) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.fromValue = @(_bgView.layer.cornerRadius);
        animation.toValue = @(_defaultR);
        animation.duration = 0.2;
        [_bgView.layer setCornerRadius:_defaultR];
        [_bgView.layer addAnimation:animation forKey:@"cornerRadius"];
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _bgView.layer.bounds = CGRectMake(0, 0, _defaultW, _defaultH);
        } completion:^(BOOL finished) {
            _bgView.hidden = YES;
            _isLoading = NO;
        }];
    }];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [_forDisplayButton setSelected:selected];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [_forDisplayButton setHighlighted:highlighted];
}

@end
