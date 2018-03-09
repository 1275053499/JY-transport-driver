//
//  PayMoneyManager.m
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/9.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "PayMoneyManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

@implementation PayMoneyManager

//支付宝
-(void)payMoneyAlipayHttp:(NSString *)phone{
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/truckerGroup/driverDeposit"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":phone} success:^(id responseObj) {
        
        NSLog(@"=======%@",responseObj);
        
        NSString *alipayScheme = @"JY-transport-driver";
        [[AlipaySDK defaultService] payOrder:responseObj fromScheme:alipayScheme callback:^(NSDictionary *resultDic) {
            
            
        }];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showErrorMessage:@"网络异常"];
    }];
    
}

//微信支付
- (void)payMoneyForWechat{
    NSString *phone = userPhone;
    if([WXApi isWXAppInstalled]) {
        // 监听一个通知
        NSString *urlStr = [base_url stringByAppendingString:@"app/wechat/truckDeposit"];
        [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":phone} success:^(id responseObj) {


            NSDictionary *payDic;
            NSLog(@"=======%@",responseObj);
            if ([[responseObj objectForKey:@"code"] isEqualToString:@"200"]) {
                payDic = [responseObj objectForKey:@"msg"];
            }

            PayReq *req  = [[PayReq alloc] init];
            req.partnerId = [payDic objectForKey:@"partnerid"];
            req.prepayId = [payDic objectForKey:@"prepayid"];
            req.package = [payDic objectForKey:@"package"];
            req.nonceStr = [payDic objectForKey:@"noncestr"];
            req.timeStamp = [[payDic objectForKey:@"timestamp"]intValue];
            req.sign = [payDic objectForKey:@"sign"];

            //调起微信支付
            if ([WXApi sendReq:req]) {
                NSLog(@"吊起成功");
            }
            
            
        } failure:^(NSError *error) {
            [MBProgressHUD showErrorMessage:@"网络异常"];
        }];
        
        
    }
    
}



@end
