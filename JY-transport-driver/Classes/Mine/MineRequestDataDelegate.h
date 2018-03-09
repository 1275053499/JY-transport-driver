//
//  MineRequestDataDelegate.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MineRequestDataDelegate <NSObject>

@optional

- (void)requestDataInMineSuccess:(NSDictionary *)resultDic;

- (void)requestDataInMineFailed:(NSError *)error;



//获取司机余额成功
- (void)requestDataGetWalletForDriverSuccess:(NSDictionary *)resultDic;
//获取司机余额失败
- (void)requestDataGetWalletForDriverFailed:(NSError *)error;




//加盟成功
- (void)requestDataJoinInLogisticsForDriverSuccess:(NSDictionary *)resultDic;
//加盟失败
- (void)requestDataJoinInLogisticsForDriverFailed:(NSError *)error;

@end
