//
//  JYHomeRequestDate.h
//  JY-transport
//
//  Created by 闫振 on 2017/9/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYHomeRequestDateDelegate.h"
@interface JYHomeRequestDate : NSObject

@property (nonatomic,strong)id <JYHomeRequestDateDelegate>delegate;

+ (id)shareInstance;

//获得抢单列表
- (void)requsetGetListToLogistics:(NSString *)url phone:(NSString *)phone page:(NSInteger)page;

//抢单
- (void)requsetGrabOrders:(NSString *)url phone:(NSString *)phone orderId:(NSString *)orderId;


//物流公司发送估价
- (void)requestSendEvaluation:(NSString *)url evaluation:(NSString *)evaluation orderId:(NSString *)orderId relationId:(NSString *)relationId;


@end
