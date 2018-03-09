//
//  commitSuccessViewController.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/12/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  enum {
    
    PushVCFromJYWalletRechargeVC = 1 , ///交押金
    PushVCFromWithdrawVC ,          ///零钱提现
    PushVCFromBuyCarWriteInfoVC , ///买车
    PushVCFromRefundDepositView ///退押金
    

}PushVCFromWhere;
@interface CommitSuccessViewController : UIViewController

@property (nonatomic,assign)PushVCFromWhere pushType;
@end
