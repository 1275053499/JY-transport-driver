 //
//  OrderMapRequestManager.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/10/19.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "OrderMapRequestManager.h"

@implementation OrderMapRequestManager
+ (id)shareInstance{
    
    static OrderMapRequestManager *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (helper == nil) {
            helper = [[OrderMapRequestManager alloc]init];
        }
    });
    return  helper;
}

// 开始服务
- (void)requestDataDriverOperation:(NSString*)url operationStatus:(NSString*)operationStatus orderNo:(NSString *)orderNo operationTime:(NSString*)operationTime{

    NSString *urls = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urls stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"operationStatus":operationStatus,@"orderNo":orderNo,@"operationTime":operationTime} success:^(id responseObj) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataDriverOperationSuccess:)]) {
            [self.delegate requestDataDriverOperationSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataDriverOperationFailed:)]) {
            
            [self.delegate requestDataDriverOperationFailed:error];
        }
        
    }];
    
    
}
@end
