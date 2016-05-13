//
//  AppModel.h
//  centanet
//
//  Created by Ranger on 16/5/12.
//  Copyright © 2016年 Vocinno Mac Mini 1. All rights reserved.
//

#import "ZYBaseReq.h"
#import "AppRequestConstant.h"

@interface SearcHouseReq: ZYBaseReq<Get>

@property (nonatomic, copy) NSString *empId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;

@end

@interface SearcHouseRes : ZYBaseRes

@property (nonatomic, strong) NSArray *content;

@end

