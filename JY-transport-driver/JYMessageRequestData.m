//
//  JYMessageRequestData.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/16.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYMessageRequestData.h"

@implementation JYMessageRequestData

+ (id)shareInstance{
    
    static JYMessageRequestData *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (helper == nil) {
            helper = [[JYMessageRequestData alloc]init];
        }
    });
    return  helper;
}


//订单列表
- (void)requsetGetOrderToLogistics:(NSString *)url phone:(NSString *)phone statusPage:(NSInteger )statusPage page:(NSInteger)page{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":phone,@"status":@(statusPage),@"page":@(page)} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestGetOrderToLogisticsSuccess:)]) {
            [self.delegate requestGetOrderToLogisticsSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestGetOrderToLogisticsFailed:)]) {
            [self.delegate requestGetOrderToLogisticsFailed:error];
        }
        
    }];
    

    
}
//订单详情
- (void)requsetgetDetailOrderInfo:(NSString *)url orderId:(NSString *)orderId{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"orderId":orderId} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requsetgetDetailOrderInfoSuccess:)]) {
            [self.delegate requsetgetDetailOrderInfoSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requsetgetDetailOrderInfoFailed:)]) {
            [self.delegate requsetgetDetailOrderInfoFailed:error];
        }
    }];
    
}

//添加运输单号
- (void)requsetAddtransportNumber:(NSString *)url orderId:(NSString *)orderId transportNumber:(NSString *)transportNumber{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"orderId":orderId,@"transportNumber":transportNumber} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requsetAddtransportNumberSuccess:)]) {
            [self.delegate requsetAddtransportNumberSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requsetAddtransportNumberFailed:)]) {
            [self.delegate requsetAddtransportNumberFailed:error];
        }
    }];

}


//提交操作 更改物流状态
- (void)requsetSubmitTracking:(NSString *)url content:(NSString *)content transportNumber:(NSString *)transportNumber transportTitle:(NSString *)transportTitle{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"content":content,@"transportNumber":transportNumber,@"transportTitle":transportTitle} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requsetSubmitTrackingSuccess:)]) {
            [self.delegate requsetSubmitTrackingSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requsetSubmitTrackingFailed:)]) {
            [self.delegate requsetSubmitTrackingFailed:error];
        }
    }];
    
}

//查看物流
- (void)requestGetTrackingByNumber:(NSString *)url transportNumber:(NSString *)transportNumber{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"transportNumber":transportNumber} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestGetTrackingByNumberSuccess:)]) {
            [self.delegate requestGetTrackingByNumberSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestGetTrackingByNumberFailed:)]) {
            [self.delegate requestGetTrackingByNumberFailed:error];
        }
    }];
    
}

@end
