//
//  DCServiceTool.m
//  carrier
//
//  Created by 大橙子 on 2019/5/31.
//  Copyright © 2019 Tomous. All rights reserved.
//

#import "DCServiceTool.h"
#import "AFNetworking.h"
@interface DCServiceTool ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end
@implementation DCServiceTool
/**
 *  单例
 *
 *  @return 网络请求类的实例，可在请求时直接调用方法，也是一个直接初始化的方式
 */
+ (instancetype)defaultManager {
    static DCServiceTool *networkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!networkManager) {
            networkManager = [[DCServiceTool alloc] init];
        }
    });
    return networkManager;
}

/**
 初始化，APP每次启动时会调用该方法，运行时不会调用
 @return 基本的请求设置
 */
- (instancetype)init {
    if (self = [super init]) {
        self.sessionManager = [AFHTTPSessionManager manager];
        // 设置请求以及相应的序列化器
        //        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置超时时间
        self.sessionManager.requestSerializer.timeoutInterval = 10.0;
        // 设置响应内容的类型
        //        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    }
    return self;
}

#pragma mark 常用网络请求
/**
 常用网络请求方式
 
 @param requestMethod 请求方试
 @param serverUrl 服务器地址
 @param parameters 参数
 @param progress 进度
 @param success 成功
 @param failure 失败
 @return return value description
 */
- (nullable NSURLSessionDataTask *)sendRequestMethod:(HTTPMethod)requestMethod
                                                 Url:(nonnull NSString *)serverUrl
                                          parameters:(nullable id)parameters
                                            progress:(nullable void (^)(NSProgress * _Nullable progress))progress
                                             success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success
                                             failure:(nullable void(^) (NSString * _Nullable errorMessage))failure {
    NSURLSessionDataTask * task = nil;
    switch (requestMethod) {
        case HTTPMethodGET:
        {
            task = [self.sessionManager GET:serverUrl parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([self failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodPOST:
        {
            task = [self.sessionManager POST:serverUrl parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([self failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodPUT:
        {
            task = [self.sessionManager PUT:serverUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([self failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodPATCH:
        {
            task = [self.sessionManager PATCH:serverUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([self failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodDELETE:
        {
            task = [self.sessionManager DELETE:serverUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (failure) {
                        failure([self failHandleWithErrorResponse:error task:task]);
                    }
                }];
        }
            break;
    }
    return task;
}


#pragma mark 报错信息
/**
 处理报错信息
 
 @param error AFN返回的错误信息
 @param task 任务
 @return description
 */
- (NSString *)failHandleWithErrorResponse:( NSError * _Nullable )error task:( NSURLSessionDataTask * _Nullable )task {
    __block NSString *message = nil;
    // 这里可以直接设定错误反馈，也可以利用AFN 的error信息直接解析展示
    NSData *afNetworking_errorMsg = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
    DCLog(@"afNetworking_errorMsg == %@",[[NSString alloc]initWithData:afNetworking_errorMsg encoding:NSUTF8StringEncoding]);
    if (!afNetworking_errorMsg) {
        message = @"网络连接失败";
    }
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSInteger responseStatue = response.statusCode;
    if (responseStatue >= 500) {  // 网络错误
        message = @"服务器维护升级中,请耐心等待";
    } else if (responseStatue >= 400) {
        // 错误信息
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:afNetworking_errorMsg options:NSJSONReadingAllowFragments error:nil];
        message = responseObject[@"error"];
    }
    DCLog(@"error == %@",error);
    return message;
}

+(void)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.securityPolicy = securityPolicy;
    
    /**  拼接token到请求头上去 */
//    if ([UserInfo shareInstance].token.length != 0) {
//        [manager.requestSerializer setValue:[UserInfo shareInstance].token forHTTPHeaderField:@"token"];
//    }
    
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 960001){//token失效
            
            [SVProgressHUD showWithStatus:@"用户token过期，请重新登录"];
            [SVProgressHUD dismissWithDelay:1.0 completion:^{
                
//                [DCTool loginOut];
            }];
        }else {
            
            !success?:success(responseObject);
            
            [SVProgressHUD dismiss];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        [SVProgressHUD showWithStatus:error.localizedDescription];
        [SVProgressHUD dismissWithDelay:1.5];
    }];
    
}
@end
