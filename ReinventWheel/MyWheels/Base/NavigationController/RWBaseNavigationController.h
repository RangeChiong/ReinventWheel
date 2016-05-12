//
//  RWBaseNavigationController.h
//  ReinventWheel
//
//  Created by Ranger on 16/5/12.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NavigationControllerPopStyle) {
    NavigationControllerPopStyle_None = 0,   //!< 默认系统的侧滑 自定义leftButton会失效
    NavigationControllerPopStyle_ForceEdgePan,    //!< 强制侧滑，自定义leftButton后仍有效
    NavigationControllerPopStyle_FullScreenPan, //!< 全屏手势侧滑 附带景深效果
};

@interface RWBaseNavigationController : UINavigationController

@property (nonatomic, assign) NavigationControllerPopStyle popStyle;

@end
