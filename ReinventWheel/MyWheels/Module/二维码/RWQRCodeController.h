//
//  RWQRCodeController.h
//  Centaline
//
//  Created by Ranger on 16/5/12.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RWQRCodeControllerDelegate <NSObject>

@optional

/*!
 *  获取扫描到的metaObject中的信息
 */
- (void)hadScanedCodeString:(NSString *)string;

/*!
 *  扫描带有二维码的照片，获取扫描信息
 */
- (void)hadScanedCodeStringFromPhoto:(NSString *)string;

@end

@interface RWQRCodeController : UIViewController

@property (nonatomic, weak) id<RWQRCodeControllerDelegate> delegate;

@property (nonatomic, assign) BOOL canScanBarCode; //!< 支持扫描条形码  默认NO
@property (nonatomic, assign) CGRect scanRect;  //!< 扫描的有效区域  默认屏幕中间220宽高的区域
/*!
 *  是否显示默认的扫描界面 不显示就自定义界面 然后add到RWQRCodeController的view上   default YES
 */
@property (nonatomic, assign) BOOL showsDefaultMaskView;

/*!
 *  block返回扫描到的信息
 */
+ (instancetype)showWithController:(UIViewController *)controller
                  takeQRCodeString:(void(^)(NSString *metaString))block;

- (void)addToController:(UIViewController *)controller;
- (void)removeFromController;

/*!
 *  打开相册 扫描带有二维码的图片 !!!!>> 仅8.0+支持
 */
- (void)openPhoto:(void(^)(NSString *metaString))block;

/*!
 *  打开闪光灯
 */
- (void)openLight:(BOOL)opened;

/*!
 *  打开震动
 */
- (void)openShake:(BOOL)shaked;

/*!
 *  使用系统的铃声
 */
- (void)openSystemSound:(BOOL)sounding name:(NSString *)name;

/*!
 *  打开扫描的铃声  自定义的铃声路径
 */
- (void)openCustomSound:(BOOL)sounding name:(NSString *)name;

@end
