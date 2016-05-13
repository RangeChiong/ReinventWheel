//
//  RWSimpleTool.m
//  ReinventWheel
//
//  Created by 常小哲 on 16/5/11.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWSimpleTool.h"

@implementation RWSimpleTool

#pragma mark-   创建文件夹

+ (void)createDirectory:(NSString *)dirPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirector = NO;
    BOOL isExiting = [fileManager fileExistsAtPath:dirPath isDirectory:&isDirector];
    if (!(isExiting && isDirector)){
        BOOL createDirection = [fileManager createDirectoryAtPath:dirPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        if (!createDirection)
            NSLog(@"创建文件夹失败：%@", dirPath);
    }
}

#pragma mark-   生成随机UUID

+ (NSString *)makeUUID {
    // 生成随机不重复的uuid
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *str_uuid = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    
    // OC风格的创建 ：NSString *str_uuid = [[NSUUID UUID] UUIDString];
    // 将生成的uuid中的@"-"去掉
    NSString *str_name = [str_uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(puuid);
    CFRelease(uuidString);
    return str_name;
}

#pragma mark-   设置某个文件或文件夹不经过iCloud备份

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePath {
    assert([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    NSURL* URL = [NSURL fileURLWithPath:filePath];
    NSError *error = nil;
    BOOL success = [URL setResourceValue:@(YES)
                                  forKey:NSURLIsExcludedFromBackupKey error:&error];
    if(!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end
