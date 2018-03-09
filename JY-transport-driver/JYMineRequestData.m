//
//  JYMineRequestData.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/7.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYMineRequestData.h"
#import "JYOutletsModel.h"
#import "JYPeopleModel.h"
@implementation JYMineRequestData
+ (id)shareInstance{
    
    static JYMineRequestData *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (helper == nil) {
            helper = [[JYMineRequestData alloc]init];
        }
    });
    return  helper;
}


/**
 *  保存网点
 */
- (void)requsetSaveLogisticsbaranchUrl:(NSString *)url ID:(NSString *)ID name:(NSString *)name address:(NSString *)address landline:(NSString *)landline province:(NSString *)province  city:(NSString *)city district:(NSString *)district location:(CLLocationCoordinate2D)location{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    NSNumber *latitude = [NSNumber numberWithDouble:location.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:location.longitude];

    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"logisticsid":ID,@"name":name,@"address":address,@"landline":landline,@"province":province,@"city":city,@"district":district,@"latitude":latitude,@"longitude":longitude} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestSaveLogisticsbaranchSuccess:)]) {
            [self.delegate requestSaveLogisticsbaranchSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestSaveLogisticsbaranchFailed:)]) {
            [self.delegate requestSaveLogisticsbaranchFailed:error];
        }
    }];
    
}
/**
 *  获取网点列表  获取员工列表 路线列表
 */
- (void)requsetgetLogisticsbaranchListUrl:(NSString *)url ID:(NSString *)ID{
    
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"logisticsid":ID} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestGetLogisticsbaranchListSuccess:)]) {
            [self.delegate requestGetLogisticsbaranchListSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestGetLogisticsbaranchListFailed:)]) {
            [self.delegate requestGetLogisticsbaranchListFailed:error];
        }
    }];

    
}

/**
 *  更新网点
 */

- (void)requsetUpdateLogisticsbaranchUrl:(NSString *)url OutletsModel:(JYOutletsModel *)model name:(NSString *)name address:(NSString *)address landline:(NSString *)landline{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
       
    NSDictionary *dic = @{@"logisticsid":model.logisticsid,@"address":address,@"basicStatus":model.basicStatus,@"id":model.id,@"landline":landline,@"latitude":model.latitude,@"longitude":model.longitude,@"name":name,@"province":model.province,@"city":model.city,@"district":model.district};
    NSString *str = [self dictionaryToJson:dic];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"baranch":str} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestUpdateLogisticsbaranchSuccess:)]) {
            [self.delegate requestUpdateLogisticsbaranchSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestUpdateLogisticsbaranchFailed:)]) {
            [self.delegate requestUpdateLogisticsbaranchFailed:error];
        }
    }];

    
}

/**
 *  新增业务员
 */
- (void)requsetAddPeopleUrl:(NSString *)url branchid:(NSString *)ID phone:(NSString *)phone name:(NSString *)name role:(NSString *)role{
    
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"branchid":ID,@"phone":phone,@"name":name,@"role":role} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestAddPeopleSuccess:)]) {
            [self.delegate requestAddPeopleSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestAddPeopleFailed:)]) {
            [self.delegate requestAddPeopleFailed:error];
        }
    }];
    
    
}

/**
 *  物流公司 修改业务员信息
 */
- (void)requsetUpdatePeopleUrl:(NSString *)url JYPeopleModel:(JYPeopleModel *)model name:(NSString *)name phone:(NSString *)phone role:(NSString *)role outletes:(NSString *)outletes{


    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    NSString *icon = model.icon;
    if (icon == nil || [icon isEqual:[NSNull null]]) {
        
        icon = @"";
    }
    
    NSDictionary *dic = @{@"id":model.id,@"branchid":outletes,@"phone":phone,@"name":name,@"role":role,@"icon":icon};
    NSString *str = [self dictionaryToJson:dic];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"clerk":str} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestUpdatePeopleSuccess:)]) {
            [self.delegate requestUpdatePeopleSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestUpdatePeopleFailed:)]) {
            [self.delegate requestUpdatePeopleFailed:error];
        }
    }];

    
}


- (void)requsetsaveLogisticslineUrl:(NSString *)url logisticsId:(NSString *)logisticsId name:(NSString *)name originProvince:(NSString *)originProvince endProvince:(NSString *)endProvince originCity:(NSString *)originCity endCity:(NSString *)endCity{
    
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"logisticsId":logisticsId,@"endProvince":endProvince,@"name":name,@"originProvince":originProvince,@"originCity":originCity,@"endCity":endCity} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestSetServiceLineSuccess:)]) {
            [self.delegate requestSetServiceLineSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestSetServiceLineFailed:)]) {
            [self.delegate requestSetServiceLineFailed:error];
        }
    }];
    
    
    
    
}
//字典转json格式字符串：
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
