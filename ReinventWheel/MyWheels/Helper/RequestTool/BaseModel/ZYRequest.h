//
//  ZYRequest.h
//  centanet
//
//  Created by Ranger on 16/5/12.
//  Copyright © 2016年 Vocinno Mac Mini 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSInteger, RequestNormalType) {
    RequestNormalType_get = 0,
    RequestNormalType_post,
    RequestNormalType_put,
    RequestNormalType_delete
};

@interface ZYRequest : NSObject

/** 开启请求缓存 */
+ (void)openRequsetCache;

/** 开启网络状态监测器 */
+ (void)startReachabilityStatusChangeMonitoring;

/** 开启一个下载任务 */
- (void)startDownloadSession:(NSString *)downloadURL;

/** 根据 RequestNormalType 请求 */
+ (void)request:(NSString *)url
           type:(RequestNormalType)type
         params:(NSDictionary *)params
        success:(void (^)(NSDictionary *dict))success
        failure:(void(^)(NSError *error))failure
        showHud:(BOOL)isShow;

/** 上传 */
+ (void)post:(NSString *)url
      params:(NSDictionary *)params
        body:(void (^)(id<AFMultipartFormData> formData))body
     success:(void (^)(NSDictionary *dict))success
     failure:(void (^)(NSError *error))failure
     showHud:(BOOL)isShow;

@end
