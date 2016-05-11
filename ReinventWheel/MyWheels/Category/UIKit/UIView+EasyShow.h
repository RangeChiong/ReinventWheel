//
//  UIView+EasyShow.h
//  RPAntus
//
//  Created by Crz on 15/11/21.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EasyShow)

@property (nonatomic, assign, getter = left,   setter = setLeft:)  CGFloat x;
@property (nonatomic, assign, getter = top,    setter = setTop:)   CGFloat y;
@property (nonatomic, assign, getter = right,  setter = setRight:) CGFloat maxX;
@property (nonatomic, assign, getter = bottom, setter = setBottom:)CGFloat maxY;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat cornerRadius;     //!< 圆角半径

- (void)round;  //!< 圆形view

@end

//---------------------------------- XibHelper ----------------------------------

@interface UIView (XibHelper)

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;

@end

