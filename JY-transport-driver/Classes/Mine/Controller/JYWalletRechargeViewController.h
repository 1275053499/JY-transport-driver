//
//  JYWalletRechargeViewController.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
  
    ///押金
    WalletOperationDeposit = 1,
    /// 充值
    WalletOperationRecharge = 2,

}WalletOperation;


@interface JYWalletRechargeViewController : UIViewController

@property (nonatomic,assign)WalletOperation type;
@end
