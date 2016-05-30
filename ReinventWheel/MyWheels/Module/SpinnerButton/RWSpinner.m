//
//  RWSpinner.m
//  RWButton
//
//  Created by Ranger on 16/5/30.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWSpinner.h"

static NSString *const kRWRingStrokeAnimationKey = @"RWSpinner.stroke";
static NSString *const kRWRingRotationAnimationKey = @"RWSpinner.rotation";


@interface RWSpinner () {
    BOOL _isAnimating;
}

@property (nonatomic, readonly) CAShapeLayer *progressLayer;

@end

@implementation RWSpinner

@synthesize progressLayer = _progressLayer;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.layer addSublayer:self.progressLayer];
    
    // See comment in resetAnimations on why this notification is used.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetAnimations) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)setAnimating:(BOOL)animate {
    (animate ? [self startAnimating] : [self stopAnimating]);
}

- (void)startAnimating {
    if (_isAnimating)
        return;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 4.f;
    animation.fromValue = @(0.f);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    [_progressLayer addAnimation:animation forKey:kRWRingRotationAnimationKey];
    
    CABasicAnimation *headAnimation = [CABasicAnimation animation];
    headAnimation.keyPath = @"strokeStart";
    headAnimation.duration = 1.f;
    headAnimation.fromValue = @(0.f);
    headAnimation.toValue = @(0.25f);
    headAnimation.timingFunction = _timingFunction;
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animation];
    tailAnimation.keyPath = @"strokeEnd";
    tailAnimation.duration = 1.f;
    tailAnimation.fromValue = @(0.f);
    tailAnimation.toValue = @(1.f);
    tailAnimation.timingFunction = _timingFunction;
    
    
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animation];
    endHeadAnimation.keyPath = @"strokeStart";
    endHeadAnimation.beginTime = 1.f;
    endHeadAnimation.duration = 0.5f;
    endHeadAnimation.fromValue = @(0.25f);
    endHeadAnimation.toValue = @(1.f);
    endHeadAnimation.timingFunction = _timingFunction;
    
    CABasicAnimation *endTailAnimation = [CABasicAnimation animation];
    endTailAnimation.keyPath = @"strokeEnd";
    endTailAnimation.beginTime = 1.f;
    endTailAnimation.duration = 0.5f;
    endTailAnimation.fromValue = @(1.f);
    endTailAnimation.toValue = @(1.f);
    endTailAnimation.timingFunction = _timingFunction;
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    [animations setDuration:1.5f];
    [animations setAnimations:@[headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]];
    animations.repeatCount = INFINITY;
    [_progressLayer addAnimation:animations forKey:kRWRingStrokeAnimationKey];
    
    
    _isAnimating = YES;
    
    if (_hidesWhenStopped) {
        self.hidden = NO;
    }
}

- (void)stopAnimating {
    if (!_isAnimating)
        return;
    
    [_progressLayer removeAnimationForKey:kRWRingRotationAnimationKey];
    [_progressLayer removeAnimationForKey:kRWRingStrokeAnimationKey];
    _isAnimating = NO;
    
    if (_hidesWhenStopped) {
        self.hidden = YES;
    }
}

#pragma mark - Private

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _progressLayer.frame = self.bounds;
    [self updatePath];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    
    _progressLayer.strokeColor = self.tintColor.CGColor;
}

- (void)resetAnimations {
    if (_isAnimating) {
        [self stopAnimating];
        [self startAnimating];
    }
}

- (void)updatePath {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - _progressLayer.lineWidth / 2;
    CGFloat startAngle = (CGFloat)(0);
    CGFloat endAngle = (CGFloat)(2*M_PI);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.progressLayer.path = path.CGPath;
    
    self.progressLayer.strokeStart = 0.f;
    self.progressLayer.strokeEnd = 0.f;
}

#pragma mark-   Setter & Getter

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = self.tintColor.CGColor;
        _progressLayer.fillColor = nil;
        _progressLayer.lineWidth = 1.5f;
    }
    return _progressLayer;
}

- (BOOL)isAnimating {
    return _isAnimating;
}

- (CGFloat)lineWidth {
    return _progressLayer.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _progressLayer.lineWidth = lineWidth;
    [self updatePath];
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
    _hidesWhenStopped = hidesWhenStopped;
    self.hidden = !self.isAnimating && hidesWhenStopped;
}

@end
