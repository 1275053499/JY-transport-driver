//
//  JYMineRequestDataDelegate.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/7.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JYMineRequestDataDelegate <NSObject>

@optional

//新增网点
- (void)requestSaveLogisticsbaranchSuccess:(NSDictionary *)resultDic;

- (void)requestSaveLogisticsbaranchFailed:(NSError *)error;

//更新网点
- (void)requestUpdateLogisticsbaranchSuccess:(NSDictionary *)resultDic;

- (void)requestUpdateLogisticsbaranchFailed:(NSError *)error;


//查询网点
- (void)requestGetLogisticsbaranchListSuccess:(NSDictionary *)resultDic;

- (void)requestGetLogisticsbaranchListFailed:(NSError *)error;

//新增业务员
- (void)requestAddPeopleSuccess:(NSDictionary *)resultDic;

- (void)requestAddPeopleFailed:(NSError *)error;


// 更新 业务员信息
- (void)requestUpdatePeopleSuccess:(NSDictionary *)resultDic;

- (void)requestUpdatePeopleFailed:(NSError *)error;

// 更新 设置服务线路
- (void)requestSetServiceLineSuccess:(NSDictionary *)resultDic;

- (void)requestSetServiceLineFailed:(NSError *)error;


@end
