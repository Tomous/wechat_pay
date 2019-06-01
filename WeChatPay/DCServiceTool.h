//
//  DCServiceTool.h
//  carrier
//
//  Created by 大橙子 on 2019/5/31.
//  Copyright © 2019 Tomous. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * GET：获取资源，不会改动资源
 * POST：创建记录
 * PATCH：改变资源状态或更新部分属性
 * PUT：更新全部属性
 * DELETE：删除资源
 */
typedef NS_ENUM(NSUInteger, HTTPMethod) {
    
    HTTPMethodGET,
    HTTPMethodPOST,
    HTTPMethodPUT,
    HTTPMethodPATCH,
    HTTPMethodDELETE,
};
@interface DCServiceTool : NSObject
/**
 *  单例
 *
 *  @return 网络请求类的实例
 */
+ (nonnull instancetype)defaultManager ;
#pragma mark 常用网络请求方式
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
                                             failure:(nullable void(^) (NSString * _Nullable errorMessage))failure ;

+(void)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
