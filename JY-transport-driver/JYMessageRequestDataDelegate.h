//
//  JYMessageRequestDataDelegate.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/16.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JYMessageRequestDataDelegate <NSObject>
@optional

//专线下单
- (void)requestGetOrderToLogisticsSuccess:(NSDictionary *)resultDic;

- (void)requestGetOrderToLogisticsFailed:(NSError *)error;

//订单详情  
- (void)requsetgetDetailOrderInfoSuccess:(NSDictionary *)resultDic;

- (void)requsetgetDetailOrderInfoFailed:(NSError *)error;


//添加运输编号
- (void)requsetAddtransportNumberSuccess:(NSDictionary *)resultDic;

- (void)requsetAddtransportNumberFailed:(NSError *)error;

//提交操作 修改物流状态
- (void)requsetSubmitTrackingSuccess:(NSDictionary *)resultDic;

- (void)requsetSubmitTrackingFailed:(NSError *)error;

//查看物流
- (void)requestGetTrackingByNumberSuccess:(id )resultDic;

- (void)requestGetTrackingByNumberFailed:(NSError *)error;


@end
