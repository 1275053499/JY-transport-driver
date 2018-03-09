//
//  CompanyModelInfo.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/6.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "CompanyModelInfo.h"

@implementation CompanyModelInfo
/**
 *  将某个对象写入文件时会调用
 *  在这个方法中说清楚哪些属性需要存储
 */

- (void)encodeWithCoder:(NSCoder *)encoder
{
    // [super encodeWithCoder:encoder];
    //[super mj_encode:encoder];
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.companyname forKey:@"companyname"];
    [encoder encodeObject:self.basicStatus forKey:@"basicStatus"];
    [encoder encodeObject:self.icon forKey:@"icon"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.landline forKey:@"landline"];
    [encoder encodeObject:self.introductions forKey:@"introductions"];

    
    
    
}
/**
 *  从文件中解析对象时会调用
 *  在这个方法中说清楚哪些属性需要存储
 */
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        self.companyname = [decoder decodeObjectForKey:@"companyname"];
        self.id = [decoder decodeObjectForKey:@"id"];
        self.icon = [decoder decodeObjectForKey:@"icon"];
        self.basicStatus = [decoder decodeObjectForKey:@"basicStatus"];
        self.landline = [decoder decodeObjectForKey:@"landline"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.introductions = [decoder decodeObjectForKey:@"introductions"];

        
    }
    return self;
    
}

@end
