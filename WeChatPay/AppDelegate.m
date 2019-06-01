//
//  AppDelegate.m
//  WeChatPay
//
//  Created by 大橙子 on 2019/6/1.
//  Copyright © 2019 Tomous. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApiManager.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registApi];
    
    [self start];
    return YES;
}
-(void)registApi {
    
    /**  微信支付 */
    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
        NSLog(@"log : %@", log);
    }];
    //向微信注册,发起支付必须注册
    [WXApi registerApp:@"wxb4ba3c02aa476ea1" enableMTA:YES];
}

-(void)start {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *VC = [[ViewController alloc]init];
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return YES;
}
/**
 这里处理微信支付完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    /**  微信支付回调 */
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    /**  微信的支付回调 */
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
