//
//  ZYBaseReq.h
//  centanet
//
//  Created by Ranger on 16/5/12.
//  Copyright © 2016年 Vocinno Mac Mini 1. All rights reserved.
//

#import "JSONModel.h"

@protocol Get
@end
@protocol Post
@end
@protocol Put
@end
@protocol Delete
@end

@interface ZYBaseReq : JSONModel

@property (nonatomic, copy) NSString *urlSuffix;
+ (void)request:(void (^)(id req))reqBlock response:(void (^)(id res))res showHud:(BOOL)isShow;

@end


@interface ZYBaseRes : JSONModel

@property (assign,nonatomic) BOOL  isSuccess;
@property (nonatomic, copy) NSString<Optional> *empId;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, copy) NSString<Optional> *token;


@end