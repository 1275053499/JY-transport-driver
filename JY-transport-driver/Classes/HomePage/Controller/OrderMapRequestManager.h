//
//  OrderMapRequestManager.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/10/19.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderMapRequestDataDelegate.h"
@interface OrderMapRequestManager : NSObject

@property (nonatomic,strong)id <OrderMapRequestDataDelegate>delegate;

+ (id)shareInstance;

//开始服务
- (void)requestDataDriverOperation:(NSString*)url operationStatus:(NSString*)operationStatus orderNo:(NSString *)orderNo operationTime:(NSString*)operationTime;

@end
