//
//  ZYRequest.m
//  centanet
//
//  Created by Ranger on 16/5/12.
//  Copyright © 2016年 Vocinno Mac Mini 1. All rights reserved.
//

#import "ZYRequest.h"
#import "MBProgressHUD.h"
#import <UIKit+AFNetworking.h>
#import "AppRequestConstant.h"

@implementation NSString (utils)

- (NSDictionary *)parseJson
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableLeaves
                                                           error:&error];
    return dict;
}
@end

static NSTimeInterval const MaxTimeOut = 20;
static NSString *const TimeOutKeyPath = @"timeoutInterval";

@implementation ZYRequest

#pragma mark-  开启请求缓存

+ (void)openRequsetCache {
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}

//TODO: 待完善
#pragma mark- 检测网络连接
+ (void)startReachabilityStatusChangeMonitoring {
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%d", status);
    }];
}

//TODO: 待完善
#pragma mark - Session 下载
- (void)startDownloadSession:(NSString *)downloadURL {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString *urlString = [downloadURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        //        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
        NSURL *fileWebURL = [NSURL URLWithString:path];
        NSURL *fileLocationURL = [NSURL fileURLWithPath:path];
        
        NSLog(@"== %@ |||| %@", fileWebURL, fileLocationURL);
        
        return fileLocationURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@ %@", filePath, error);
    }];
    
    [task resume];
}

#pragma mark-  请求

+ (void)request:(NSString *)url
           type:(RequestNormalType)type
         params:(NSDictionary *)params
        success:(void (^)(NSDictionary *dict))success
        failure:(void (^)(NSError *error))failure
        showHud:(BOOL)isShow {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:TimeOutKeyPath];
    manager.requestSerializer.timeoutInterval = MaxTimeOut;
    [manager.requestSerializer didChangeValueForKey:TimeOutKeyPath];
    
    MBProgressHUD *hud;
    if (isShow) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    }
    
    // 请求成功的回调
    void (^SuccessfulRequestCallBack) (AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSDictionary *dict = [operation.responseString parseJson];
            success(dict);
        }
        
        if (isShow) {
            [hud hide:YES];
        }
    };
    
    // 请求失败的回调
    void (^FailedRequestCallBack) (AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
        
        if (isShow) {
            hud.labelText = @"加载失败";
            [hud hide:YES afterDelay:1.0f];
        }
    };
    
    // 拼接url
    NSString *completeURL = [AppRequestURL stringByAppendingString:url];
    
    switch (type) {
        case RequestNormalType_get: {
            [manager GET:completeURL parameters:params success:SuccessfulRequestCallBack failure:FailedRequestCallBack];
        }
            break;
            
        case RequestNormalType_post: {
            [manager POST:completeURL parameters:params success:SuccessfulRequestCallBack failure:FailedRequestCallBack];
        }
            break;
            
        case RequestNormalType_put: {
            [manager PUT:completeURL parameters:params success:SuccessfulRequestCallBack failure:FailedRequestCallBack];
        }
            break;
            
        case RequestNormalType_delete: {
            [manager DELETE:completeURL parameters:params success:SuccessfulRequestCallBack failure:FailedRequestCallBack];
        }
            break;
            
        default:
            break;
    }
}

+ (void)post:(NSString *)url
      params:(NSDictionary *)params
        body:(void (^)(id<AFMultipartFormData> formData))body
     success:(void (^)(NSDictionary* dic))success
     failure:(void (^)(NSError *error))failure
     showHud:(BOOL)isShow {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:TimeOutKeyPath];
    manager.requestSerializer.timeoutInterval = MaxTimeOut;
    [manager.requestSerializer didChangeValueForKey:TimeOutKeyPath];
    
    MBProgressHUD *hud;
    if (isShow) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    }
    
    // 拼接url
    NSString *completeURL = [AppRequestURL stringByAppendingString:url];

    
    [manager POST:completeURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (body) {
            body(formData);
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSDictionary *dict = [operation.responseString parseJson];
            success(dict);
        }
        
        if (isShow) {
            [hud hide:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
        
        if (isShow) {
            hud.labelText = @"加载失败";
            [hud hide:YES afterDelay:1.0f];
        }
    }];
}

@end
