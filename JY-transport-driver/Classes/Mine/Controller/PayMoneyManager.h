//
//  PayMoneyManager.h
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/9.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayMoneyManager : NSObject

///支付宝
-(void)payMoneyAlipayHttp:(NSString *)pbone;

///微信
- (void)payMoneyForWechat;
@end
