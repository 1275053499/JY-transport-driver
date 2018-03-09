//
//  OrderMapRequestDataDelegate.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/10/19.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OrderMapRequestDataDelegate <NSObject>

//开始服务
- (void)requestDataDriverOperationSuccess:(NSDictionary *)resultDic;

- (void)requestDataDriverOperationFailed:(NSError *)error;



@end
