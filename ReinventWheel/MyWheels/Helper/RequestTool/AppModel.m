//
//  AppModel.m
//  centanet
//
//  Created by Ranger on 16/5/12.
//  Copyright © 2016年 Vocinno Mac Mini 1. All rights reserved.
//

#import "AppModel.h"

@implementation SearchHouseReq

- (NSString *)urlSuffix {
    return SearchEstateName;
}

@end

@implementation SearchHouseModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"uid",
                                                       }];
}

@end

@implementation SearchHouseRes

@end