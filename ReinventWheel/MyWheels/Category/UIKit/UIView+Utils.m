//
//  UIView+Utils.m
//  CXZKit
//
//  Created by Ranger on 16/5/5.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "UIView+Utils.h"
@import ObjectiveC.runtime;

@implementation UIView (Utils)

- (void)rw_eachSubview:(void (^)(UIView *subview))block {
    NSParameterAssert(block != nil);
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        block(subview);
    }];
}

- (void)rw_removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end

#pragma mark-  Gesture

static const void *GestureRecognizerHandler = &GestureRecognizerHandler;

@interface UIView (GesturePrivate)

@property (nonatomic, copy) void (^handler)(UITapGestureRecognizer *tap);

@end

@implementation UIView (Gesture)

#pragma mark-  添加 tap 手势

- (UITapGestureRecognizer *)rw_tapWithTarget:(id)target action:(SEL)aSelector {
    NSAssert([target respondsToSelector:aSelector], @"selector & target 必须存在");
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:aSelector];
    [self addGestureRecognizer:tap];
    return tap;
}

- (void)rw_tapWithHandler:(void (^)(UITapGestureRecognizer *tap))handler {
    NSAssert(handler, @"handler 不能为nil");
    self.handler = handler;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerTapAction:)];
    [self addGestureRecognizer:tap];
}

#pragma mark-  handlerAction

- (void)handlerTapAction:(UITapGestureRecognizer *)sender {
    self.handler(sender);
}

#pragma mark-  setter && getter

- (void)setHandler:(void (^)(UITapGestureRecognizer *tap))handler {
    objc_setAssociatedObject(self, GestureRecognizerHandler, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITapGestureRecognizer *tap))handler {
    return objc_getAssociatedObject(self, GestureRecognizerHandler);
}

@end