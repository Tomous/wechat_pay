//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import "WXApi.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"


@implementation WXApiRequestHandler

#pragma mark - Public Methods

/**  官方给的 */
//+ (NSString *)jumpToBizPay {
//
//    //============================================================
//    // V3&V4支付流程实现
//    // 注意:参数配置请查看服务器端Demo
//    // 更新时间：2015年11月20日
//    //============================================================
//    NSString *urlString   = @"https://wxpay.wxutil.com/pub_v2/app/app_pay.php?plat=ios";
//    //解析服务端返回json数据
//    NSError *error;
//    //加载一个NSURL对象
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    //将请求的url数据放到NSData对象中
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if ( response != nil) {
//        NSMutableDictionary *dict = NULL;
//        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
//        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//
//        NSLog(@"url:%@",urlString);
//        if(dict != nil){
//            NSMutableString *retcode = [dict objectForKey:@"retcode"];
//            if (retcode.intValue == 0){
//                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//
//                //调起微信支付
//                PayReq* req             = [[PayReq alloc] init];
//                req.partnerId           = [dict objectForKey:@"partnerid"];
//                req.prepayId            = [dict objectForKey:@"prepayid"];
//                req.nonceStr            = [dict objectForKey:@"noncestr"];
//                req.timeStamp           = stamp.intValue;
//                req.package             = [dict objectForKey:@"package"];
//                req.sign                = [dict objectForKey:@"sign"];
//                [WXApi sendReq:req];
//                //日志输出
//                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
//                return @"";
//            }else{
//                return [dict objectForKey:@"retmsg"];
//            }
//        }else{
//            return @"服务器返回错误，未获取到json对象";
//        }
//    }else{
//        return @"服务器返回错误";
//    }
//}

+ (void)jumpToBizPay {
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //--->实际项目代码
    NSString *urlString   = @"https://wxpay.wxutil.com/pub_v2/app/app_pay.php?plat=ios";
    NSString *url =[NSString stringWithFormat:@"%@%@", @"Base_URL",urlString];
    //    NSLog(@"微信支付___URL=== %@,%@", url,self.orderId);
    [DCServiceTool postWithUrl:url params:@{@"orderID":@"orderId"} success:^(id  _Nonnull responseObject) {
        
        if ([[responseObject objectForKey:@"code"] intValue] == 0) {
            
            // 调起微信支付
            PayReq *req = [[PayReq alloc] init];
            //            id dic = [responseObject objectForKey:@"data"];
            //            if ([dic isKindOfClass:[NSString class]]) {
            //                NSString *str = [NSString stringWithFormat:@"%@",dic];
            //                if ([str isEqualToString:@"PAY_SUCCESS"]) {
            //                    /**  支付成功  处理   */
            //                    //                            [weakself goToOrderDetailVC];
            //                    DCLog(@"支付成功  处理 ---");
            //                    return ;
            //                }
            //                return ;
            //            }
            /** 微信分配的公众账号ID -> APPID */
            req.openID = [responseObject objectForKey:@"appid"];
            /** 商家向财付通申请的商家id */
            req.partnerId = [responseObject objectForKey:@"partnerid"];
            /** 预支付订单 从服务器获取 */
            req.prepayId = [responseObject objectForKey:@"prepayid"];
            /** 随机串，防重发 */
            req.nonceStr = [responseObject objectForKey:@"noncestr"];
            /** 时间戳，防重发 */
            req.timeStamp = [[responseObject objectForKey:@"timestamp"] intValue];
            /** 商家根据财付通文档填写的数据和签名 <暂填写固定值Sign=WXPay>*/
            req.package = [responseObject objectForKey:@"package_"];
            /** 商家根据微信开放平台文档对数据做的签名, 可从服务器获取，也可本地生成*/
            req.sign = [responseObject objectForKey:@"sign"];
            //日志输出
            DCLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[responseObject objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            
            if ([WXApi isWXAppInstalled] == YES) {
                BOOL sss =   [WXApi sendReq:req];
                if (!sss ) {
                    [SVProgressHUD showWithStatus:@"微信sdk错误"];
                    [SVProgressHUD dismissWithDelay:1.0];
                }
            } else {
                //微信未安装
                [SVProgressHUD showWithStatus:@"您没有安装微信"];
                [SVProgressHUD dismissWithDelay:1.0];
            }
        }else {
            [SVProgressHUD showWithStatus:responseObject[@"msg"]];
            [SVProgressHUD dismissWithDelay:1.0];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
@end
