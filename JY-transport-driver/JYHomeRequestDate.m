//
//  JYHomeRequestDate.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYHomeRequestDate.h"

@implementation JYHomeRequestDate

+ (id)shareInstance{
    
    static JYHomeRequestDate *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (helper == nil) {
            helper = [[JYHomeRequestDate alloc]init];
        }
    });
    return  helper;
}

/**
 *  抢单广场列表
 */
- (void)requsetGetListToLogistics:(NSString *)url phone:(NSString *)phone page:(NSInteger)page{

    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":phone,@"page":@(page)} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestGetListToLogisticsSuccess:)]) {
            [self.delegate requestGetListToLogisticsSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestGetListToLogisticsFailed:)]) {
            [self.delegate requestGetListToLogisticsFailed:error];
        }
        
    }];
    
}

/**
 *  抢单
 */

- (void)requsetGrabOrders:(NSString *)url phone:(NSString *)phone orderId:(NSString *)orderId{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":phone,@"orderId":orderId} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestGrabOrderSuccess:)]) {
            [self.delegate requestGrabOrderSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestGrabOrderFailed:)]) {
            [self.delegate requestGrabOrderFailed:error];
        }
        
    }];

}
/**
 *  物流公司发送估价
 */
- (void)requestSendEvaluation:(NSString *)url evaluation:(NSString *)evaluation orderId:(NSString *)orderId relationId:(NSString *)relationId{


    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"evaluation":evaluation,@"orderId":orderId,@"relationId":relationId} success:^(id responseObj) {
        
        if ([self.delegate respondsToSelector:@selector(requestSendEvaluationSuccess:)]) {
            [self.delegate requestSendEvaluationSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestSendEvaluationFailed:)]) {
            [self.delegate requestSendEvaluationFailed:error];
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
