//
//  ChoosePayAccountViewController.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/10/24.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WechatAccount =1,   //／ 选择微信支付
    AliAccount = 2      //／ 选择支付宝支付
    
}ChooseAccountType;     //／ 选择什么支付类型


@interface ChoosePayAccountViewController : UIViewController

@property (nonatomic,copy) void(^choosePayAccount)(NSString *phoneNum ,ChooseAccountType  type);


@end
