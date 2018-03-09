//
//  ClerkModel.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/11/10.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "ClerkModel.h"

@implementation ClerkModel

/**
 *  将某个对象写入文件时会调用
 *  在这个方法中说清楚哪些属性需要存储
 */

- (void)encodeWithCoder:(NSCoder *)encoder
{
    // [super encodeWithCoder:encoder];
    //[super mj_encode:encoder];
    [encoder encodeObject:self.branchId forKey:@"branchId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.basicStatus forKey:@"basicStatus"];
    [encoder encodeObject:self.icon forKey:@"icon"];
    [encoder encodeObject:self.branchName forKey:@"branchName"];
    [encoder encodeObject:self.logisticsName forKey:@"logisticsName"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.role forKey:@"role"];
    [encoder encodeObject:self.logisticsId forKey:@"logisticsId"];

    
    
    
}
/**
 *  从文件中解析对象时会调用
 *  在这个方法中说清楚哪些属性需要存储
 */
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        self.name = [decoder decodeObjectForKey:@"name"];
        self.branchId = [decoder decodeObjectForKey:@"branchId"];
        self.icon = [decoder decodeObjectForKey:@"icon"];
        self.basicStatus = [decoder decodeObjectForKey:@"basicStatus"];
        self.branchName = [decoder decodeObjectForKey:@"branchName"];
        self.logisticsName = [decoder decodeObjectForKey:@"logisticsName"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.role = [decoder decodeObjectForKey:@"role"];
        self.logisticsId = [decoder decodeObjectForKey:@"logisticsId"];

    }
    return self;
    
}


@end
