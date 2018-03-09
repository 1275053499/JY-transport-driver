//
//  JYHomeRequestDateDelegate.h
//  JY-transport
//
//  Created by 闫振 on 2017/9/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JYHomeRequestDateDelegate <NSObject>

@optional

//专线下单
- (void)requestGetListToLogisticsSuccess:(NSDictionary *)resultDic;

- (void)requestGetListToLogisticsFailed:(NSError *)error;



//抢单
- (void)requestGrabOrderSuccess:(NSDictionary *)resultDic;

- (void)requestGrabOrderFailed:(NSError *)error;

//发送估价
- (void)requestSendEvaluationSuccess:(NSDictionary *)resultDic;

- (void)requestSendEvaluationFailed:(NSError *)error;


@end
