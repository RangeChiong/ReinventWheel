//
//  RWSelectAvatarController.h
//  Test1208
//
//  Created by 常小哲 on 15/12/8.
//  Copyright © 2015年 常小哲. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RWSelectAvatarControllerDelegate <NSObject>

@optional

/*!
 *  获取原图
 */
- (void)takeOriginalSelectedPicture:(UIImage *)image;


/*!
 *  获取编辑后的图
 */
- (void)takeEditedSelectedPicture:(UIImage *)image;

@end


@interface RWSelectAvatarController : UIViewController

@property (nonatomic, weak) id<RWSelectAvatarControllerDelegate> delegate;

/*!
 *  block返回选取的图片
 */
+ (instancetype)showWithController:(UIViewController *)controller takePicture:(void(^)(UIImage *editedImage))block;

/*!
 *  需设置代理 写代理方法 
 */
+ (instancetype)showWithController:(UIViewController *)controller;

@end




NS_ASSUME_NONNULL_END