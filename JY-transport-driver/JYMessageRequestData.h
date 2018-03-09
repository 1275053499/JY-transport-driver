//
//  JYMessageRequestData.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/16.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYMessageRequestDataDelegate.h"
@interface JYMessageRequestData : NSObject

@property (nonatomic,strong)id <JYMessageRequestDataDelegate>delegate;


+ (id)shareInstance;

//订单列表
- (void)requsetGetOrderToLogistics:(NSString *)url phone:(NSString *)phone statusPage:(NSInteger )statusPage page:(NSInteger)page;

//订单详情
- (void)requsetgetDetailOrderInfo:(NSString *)url orderId:(NSString *)orderId;



//添加运输单号
- (void)requsetAddtransportNumber:(NSString *)url orderId:(NSString *)orderId transportNumber:(NSString *)transportNumber;

//添加运输单号
- (void)requsetSubmitTracking:(NSString *)url content:(NSString *)content transportNumber:(NSString *)transportNumber transportTitle:(NSString *)transportTitle;



//查看物流
- (void)requestGetTrackingByNumber:(NSString *)url transportNumber:(NSString *)transportNumber;


@end
