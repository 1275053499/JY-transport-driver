//
//  JYMineRequestData.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/7.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYMineRequestDataDelegate.h"
#import <CoreLocation/CoreLocation.h>

@class JYPeopleModel;
@class JYOutletsModel;
@interface JYMineRequestData : NSObject

@property (nonatomic,strong)id <JYMineRequestDataDelegate>delegate;

+ (id)shareInstance;

/**
 *  保存网点
 */
- (void)requsetSaveLogisticsbaranchUrl:(NSString *)url ID:(NSString *)ID name:(NSString *)name address:(NSString *)address landline:(NSString *)landline province:(NSString *)province  city:(NSString *)city district:(NSString *)district location:(CLLocationCoordinate2D)location;

/**
 *  获取网点列表  获取员工列表路线列表
 */
- (void)requsetgetLogisticsbaranchListUrl:(NSString *)url ID:(NSString *)ID;



/**
 *  修改网点信息
 */
- (void)requsetUpdateLogisticsbaranchUrl:(NSString *)url OutletsModel:(JYOutletsModel*)model name:(NSString *)name address:(NSString *)address landline:(NSString *)landline;
;


/**
 *  新增业务员
 */
- (void)requsetAddPeopleUrl:(NSString *)url branchid:(NSString *)ID phone:(NSString *)phone name:(NSString *)name role:(NSString *)role;

/**
 *  物流公司 修改业务员信息
 */

- (void)requsetUpdatePeopleUrl:(NSString *)url JYPeopleModel:(JYPeopleModel *)model name:(NSString *)name phone:(NSString *)phone role:(NSString *)role outletes:(NSString *)outletes;


/**
 *  物流公司 设置服务路线
 */

- (void)requsetsaveLogisticslineUrl:(NSString *)url logisticsId:(NSString *)logisticsId name:(NSString *)name originProvince:(NSString *)originProvince endProvince:(NSString *)endProvince originCity:(NSString *)originCity endCity:(NSString *)endCity;

@end
