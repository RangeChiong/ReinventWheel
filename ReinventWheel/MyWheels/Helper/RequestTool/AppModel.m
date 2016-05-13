//
//  AppModel.m
//  centanet
//
//  Created by Ranger on 16/5/12.
//  Copyright © 2016年 Vocinno Mac Mini 1. All rights reserved.
//

#import "AppModel.h"

@implementation SearcHouseReq

- (NSString *)urlSuffix {
    return SearchEstateName;
}

@end

@implementation SearcHouseModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"uid",
                                                       }];
}

@end

@implementation SearcHouseRes

@end