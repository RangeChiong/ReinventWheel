//
//  RWSimpleTool.h
//  ReinventWheel
//
//  Created by 常小哲 on 16/5/11.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWSimpleTool : NSObject

/** 创建文件夹 */
+ (void)createDirectory:(NSString *)dirPath;

/** 生成随机UUID */
+ (NSString *)makeUUID;

/** 设置某文件(夹)不备份到iCloud */
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePath;


@end
