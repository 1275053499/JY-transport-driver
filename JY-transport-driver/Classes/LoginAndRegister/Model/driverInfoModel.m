//
//  driverInfoModel.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/6/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "driverInfoModel.h"

@implementation driverInfoModel
/**
 *  将某个对象写入文件时会调用
 *  在这个方法中说清楚哪些属性需要存储
 */

- (void)encodeWithCoder:(NSCoder *)encoder
{
//    [super encodeWithCoder:encoder];
    
    //[super mj_encode:encoder];
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.basicStatus forKey:@"basicStatus"];
    [encoder encodeObject:self.icon forKey:@"icon"];
    [encoder encodeObject:self.licensePlate forKey:@"licensePlate"];
    [encoder encodeObject:self.sexuality forKey:@"sexuality"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.vehicle forKey:@"vehicle"];
    [encoder encodeObject:self.wechatAccount forKey:@"wechatAccount"];
    [encoder encodeObject:self.ailpayAccount forKey:@"ailpayAccount"];
    [encoder encodeObject:@(self.isAuthentication) forKey:@"isAuthentication"];
    [encoder encodeObject:self.bankCard forKey:@"bankCard"];


    
}

/**
 *  从文件中解析对象时会调用
 *  在这个方法中说清楚哪些属性需要存储
 */
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        self.name = [decoder decodeObjectForKey:@"name"];
        self.id = [decoder decodeObjectForKey:@"id"];
        self.icon = [decoder decodeObjectForKey:@"icon"];
        self.basicStatus = [decoder decodeObjectForKey:@"basicStatus"];
        self.licensePlate = [decoder decodeObjectForKey:@"licensePlate"];
        self.vehicle = [decoder decodeObjectForKey:@"vehicle"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.sexuality = [decoder decodeObjectForKey:@"sexuality"];
        self.wechatAccount = [decoder decodeObjectForKey:@"wechatAccount"];
        self.ailpayAccount = [decoder decodeObjectForKey:@"ailpayAccount"];
        self.isAuthentication = [[decoder decodeObjectForKey:@"isAuthentication"] integerValue];
        self.bankCard = [decoder decodeObjectForKey:@"bankCard"];


    }
    return self;

}


@end
