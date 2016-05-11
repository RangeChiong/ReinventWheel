//
//  UIView+EasyShow.m
//  RPAntus
//
//  Created by Crz on 15/11/21.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import "UIView+EasyShow.h"

@implementation UIView (EasyShow)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    [self setX:x];
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setMaxX:(CGFloat)maxX {
    self.x = maxX - self.width;
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setRight:(CGFloat)maxX {
    [self setMaxX:maxX];
}

- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxY:(CGFloat)maxY {
    self.y = maxY - self.height;
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)maxY {
    [self setBottom:maxY];
}

- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    [self setY:y];
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)round {
    [self setCornerRadius:self.frame.size.height/2];
}

@end

#pragma mark-  XibHelper

@implementation UIView (XibHelper)

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}



- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}



- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}


@end

