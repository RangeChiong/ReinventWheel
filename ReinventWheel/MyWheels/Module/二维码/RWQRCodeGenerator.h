//
//  RWQRCodeGenerator.h
//  ReinventWheel
//
//  Created by Ranger on 16/5/12.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWQRCodeGenerator : NSObject

/*!
 *  生成二维码  按照指定的宽度width
 */
- (UIImage *)createQRCodeFromString:(NSString *)qrString QRCodeWidth:(CGFloat)width;

/*!
 *  用来处理生成的二维码image (改变颜色 透明之类的)
 */
- (UIImage*)imageBlackToTransparent:(UIImage*)image red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end
