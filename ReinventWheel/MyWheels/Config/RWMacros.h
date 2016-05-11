//
//  RWMacros.h
//  ReinventWheel
//
//  Created by Ranger on 16/5/11.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#ifndef RWMacros_h
#define RWMacros_h

//----------------------------------常用----------------------------------
#pragma mark-   常用UI

// 从xib中load view
#define LoadXibWithClass(__class__) [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([__class__ class]) owner:self options:nil] firstObject];

// 获取屏幕大小
#define Screen_Bounds   [UIScreen mainScreen].bounds
#define Screen_Size     Screen_Bounds.size
#define Screen_Width    Screen_Size.width
#define Screen_Height   Screen_Size.height

// 常用系统的高度
#define Height_KeyBoard         216.0f
#define Height_TabBar           49.0f
#define Height_NavigationBar    44.0f
#define Height_StatusBar        20.0f
#define Height_TopBar   Height_NavigationBar + Height_StatusBar

// 线条的高度
#define kCommonLineHeight (1.0/[UIScreen mainScreen].scale)
#define kCommonLineHeight_offset   ((1.0f / [UIScreen mainScreen].scale) / 2.0f)

// 字体
#define Font_System(size) [UIFont systemFontOfSize:size]

// 16进制颜色转UIColor  ColorHex(0x000000)
#define ColorHex(hexValue)   [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0]
// RGB颜色
#define ColorRGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define ColorRGB(r,g,b)      ColorRGBA(r,g,b,1.0f)

// 常用色
#define Color_Main  ColorHex(0x915cd2)
#define Color_Mask [UIColor colorWithWhite:0.0 alpha:0.6]
#define Color_Clear [UIColor clearColor]
#define Color_White [UIColor whiteColor]
#define Color_Black [UIColor blackColor]
#define Color_Orange [UIColor orangeColor]
#define Color_Red [UIColor redColor]
#define Color_Green [UIColor greenColor]

//读取图片
#define Image_Named(name) [UIImage imageNamed:name]
#define Image_File(file, ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:ext]]
#define Image_FileFullName(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

// alertView
#define ALERT_ONE(_msg_)    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_msg_ delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles:nil, nil]; \
[alert show]

// 沙盒路径
#define SandBox_Documents [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define SandBox_Caches    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define SandBox_Temporary NSTemporaryDirectory()
#define SandBox_Root      NSHomeDirectory()

//----------------------------------单例----------------------------------
#pragma mark-   单例
// 创建单例
// h文件
#define AS_SINGLETON \
+ (instancetype)shareInstance;

// m文件
#define DEF_SINGLETON \
+ (instancetype)shareInstance { \
static id instance; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[self alloc] init]; \
}); \
return instance; \
}

//----------------------------------调试----------------------------------
#pragma mark-   打印日志

#ifdef DEBUG
#   define DLog(format, ...) do {                                             \
fprintf(stderr, "<File:[%s] ~~ Line:[%d]> %s\n",                            \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)
#else
#   define DLog(...)
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

// 异常判断和处理
#define isNullObj(x)             (!x || [x isKindOfClass:[NSNull class]]) ? YES : NO
#define isEmptyString(x)      (isNullObj(x) || [x isEqual:@""]) ? YES : NO

#define SafeRun_Delegate(name, selector)   (name && [name respondsToSelector:selector]) ? YES : NO
#define SafeRun_Delegate_Default(selector)  (_delegate && [_delegate respondsToSelector:selector]) ? YES : NO
#define SafeRun_Block(block, ...) block ? block(__VA_ARGS__) : nil
#define SafeRun_Return(_obj_)if (_obj_) return _obj_

//----------------------------------系统版本和机型----------------------------------
#pragma mark-   系统版本和机型
// 系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS6_OR_UP (IOS_VERSION >= 6.0) ? YES : NO
#define IOS7_OR_UP (IOS_VERSION >= 7.0) ? YES : NO
#define IOS8_OR_UP (IOS_VERSION >= 8.0) ? YES : NO
#define IOS9_OR_UP (IOS_VERSION >= 9.0) ? YES : NO

#define IOS_VERSION_EQUAL_TO(f)                  (IOS_VERSION == f) ? YES : NO
#define IOS_VERSION_GREATER_THAN(f)              (IOS_VERSION > f) ? YES : NO
#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(f)  (IOS_VERSION >= f) ? YES : NO
#define IOS_VERSION_LESS_THAN(f)                 (IOS_VERSION < f) ? YES : NO
#define IOS_VERSION_LESS_THAN_OR_EQUAL_TO(f)     (IOS_VERSION <= f) ? YES : NO

// 设备类型, 2 >> ipad, 1 >> iphone
#define Device_Type (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 1 : 2
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? YES : NO

// 机型
#define IS_IPHONE4  (IS_IPHONE && Screen_Height == 480.0f) ? YES : NO
#define IS_IPHONE5  (IS_IPHONE && Screen_Height == 568.0f) ? YES : NO
#define IS_IPHONE6  (IS_IPHONE && Screen_Height == 667.0f) ? YES : NO
#define IS_IPHONE6P (IS_IPHONE && Screen_Height == 736.0f) ? YES : NO

// app版本号
#define Project_ShortVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//----------------------------------其他----------------------------------
#pragma mark-   其他
// 获取变量名     转换成NSString 用%s格式化
#define VariableName(type)  #type

#define Static_Const_Char_String(__string)               static const char * __string = #__string;


#endif /* RWMacros_h */
