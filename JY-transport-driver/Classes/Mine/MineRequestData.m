//
//  MineRequestData.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "MineRequestData.h"

@interface MineRequestData ()


@end
@implementation MineRequestData
+ (id)shareInstance{
    
    static MineRequestData *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (helper == nil) {
            helper = [[MineRequestData alloc]init];
        }
    });
    return  helper;
}


- (void)requsetDataUrl:(NSString *)url Id:(NSString *)Id icon:(NSString *)icon{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"id":Id,@"icon":icon} success:^(id responseObj) {

        if ([self.delegate respondsToSelector:@selector(requestDataInMineSuccess:)]) {
            [self.delegate requestDataInMineSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
       
        if ([self.delegate respondsToSelector:@selector(requestDataInMineFailed:)]) {
            [self.delegate requestDataInMineFailed:error];
        }
    }];

    
}
/**
 *  获取司机余额
 */
- (void)requestDataGetWalletForDriver:(NSString *)url phone:(NSString *)tel idea:(NSString *)idea{
    
    NSString *phoneNumber = userPhone;
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/wallet/getWalletByUser"];

    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":phoneNumber,@"idea":@"1"} success:^(id responseObj) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataGetWalletForDriverSuccess:)]) {
            [self.delegate requestDataGetWalletForDriverSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataGetWalletForDriverFailed:)]) {
            
            [self.delegate requestDataGetWalletForDriverFailed:error];
        }
        
    }];
}


// 物流加盟
- (void)requestDataJoinLog:(NSString*)url phone:(NSString*)tel company:(NSString *)name businessLicense:(NSString*)businss{
    
    
    NSString *urls = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urls stringByAppendingString:@"app/logisticsgroup/saveLogisticsGroup"];

    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":tel,@"companyname":name,@"businessLicense":businss} success:^(id responseObj) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataJoinInLogisticsForDriverSuccess:)]) {
            [self.delegate requestDataJoinInLogisticsForDriverSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataJoinInLogisticsForDriverFailed:)]) {
            
            [self.delegate requestDataJoinInLogisticsForDriverFailed:error];
        }
        
    }];

    
}
@end
