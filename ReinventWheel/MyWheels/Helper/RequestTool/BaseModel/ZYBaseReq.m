//
//  ZYBaseReq.m
//  centanet
//
//  Created by Ranger on 16/5/12.
//  Copyright © 2016年 Vocinno Mac Mini 1. All rights reserved.
//

#import "ZYBaseReq.h"
#import "ZYRequest.h"
#import "CocoaCracker.h"
#import <MBProgressHUD.h>

static NSString *const ReqModelSuffix = @"Req";
static NSString *const ResModelSuffix = @"Res";

static NSString *const FileAppendName = @"#FileAppendName";
static NSString *const URLSuffix = @"urlSuffix";

#define RequestURL  [req valueForKey:URLSuffix]

@implementation ZYBaseReq

+ (void)request:(void (^)(id req))reqBlock response:(void (^)(id res))resBlock showHud:(BOOL)isShow {
    ZYBaseReq *req = [self new];
    if (reqBlock) reqBlock(req);
    
    NSString *clsName = [NSStringFromClass(req.class) stringByReplacingOccurrencesOfString:ReqModelSuffix
                                                                                withString:ResModelSuffix];

    NSDictionary *paramDict = [[self packageModel:req] mutableCopy];
    
    // 请求成功的回调block
    void (^SuccessfulRequestCallBack) (NSDictionary *) = ^(NSDictionary *resultDict) {
        Class cls = NSClassFromString(clsName);
        if (!cls) cls = [ZYBaseRes class];
        
        NSError *err;
        id resModel = [[cls alloc] initWithDictionary:resultDict error:&err];
        
        if (!resModel) {
            NSLog(@"错误 : %@", req.description);
            if (isShow) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
                hud.labelText = @"网络数据发生异常";
                [hud hide:YES afterDelay:1.0f];
            }
        }
        if (resBlock) resBlock(resModel);
    };
    
    // 请求失败的回调block
    void (^FailedRequestCallBack) (NSError *) = ^(NSError *error) {
        NSLog(@"错误 : %@", req.description);
        if (isShow) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
            hud.labelText = @"网络连接发生错误";
            [hud hide:YES afterDelay:1.0f];
        }
    };
    
    if ([req conformsToProtocol:@protocol(Post)]) {
        NSMutableArray *tmpArr = paramDict[FileAppendName];
        if (tmpArr) {
            [ZYRequest post:RequestURL params:paramDict body:^(id<AFMultipartFormData> formData) {
                for(NSString *key in tmpArr) {
                    NSData *data = [req valueForKey:key];
                    [formData appendPartWithFileData:data name:key fileName:key mimeType:@"image/png"];
                }
            }
                     success:SuccessfulRequestCallBack
                     failure:FailedRequestCallBack
                     showHud:isShow];
        }else {
            [ZYRequest request:RequestURL
                           type:RequestNormalType_post
                         params:paramDict
                        success:SuccessfulRequestCallBack
                        failure:FailedRequestCallBack
                        showHud:isShow];
        }
        
    }else {
        RequestNormalType reqType;
        if ([req conformsToProtocol:@protocol(Get)]) reqType = RequestNormalType_get;
        else if ([req conformsToProtocol:@protocol(Put)]) reqType = RequestNormalType_put;
        else if ([req conformsToProtocol:@protocol(Delete)]) reqType = RequestNormalType_delete;
        
        [ZYRequest request:RequestURL
                       type:reqType
                     params:paramDict
                    success:SuccessfulRequestCallBack
                    failure:FailedRequestCallBack
                    showHud:isShow];
    }
}

#pragma mark-  private methods

// 模型转字典
+ (NSDictionary *)packageModel:(id)model {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [[CocoaCracker handle:[model class]] copyModelPropertyName:^(NSString *pName) {
        id value = [model valueForKey:pName];
        if (value) {
            if ([value isKindOfClass:[NSData class]]) {
                NSMutableArray *arr = dict[FileAppendName];
                if (!arr) {
                    arr = [NSMutableArray new];
                    dict[FileAppendName] = arr;
                }
                [arr addObject:pName];
            }else {
                dict[pName] = value;
            }
        }
    }];
    
    [[CocoaCracker handle:[model superclass]] copyModelPropertyName:^(NSString *pName) {
        id value = [model valueForKey:pName];
        if (value) {
            if (![pName isEqualToString:URLSuffix]) {
                dict[pName] = value;
            }
        }
    }];
    
    return dict;
}

@end


@implementation ZYBaseRes
@end
