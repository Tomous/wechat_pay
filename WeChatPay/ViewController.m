//
//  ViewController.m
//  WeChatPay
//
//  Created by 大橙子 on 2019/6/1.
//  Copyright © 2019 Tomous. All rights reserved.
//

#import "ViewController.h"
#import "WXApiRequestHandler.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(btnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
-(void)btnDidClick {
    /**  微信支付 */
    [WXApiRequestHandler jumpToBizPay];
}

@end
