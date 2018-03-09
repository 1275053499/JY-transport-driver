//
//  ClerkModel.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/11/10.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClerkModel : NSObject<NSCoding>

@property(nonatomic,copy)NSString *branchId;
@property(nonatomic,copy)NSString *name;//司机姓名
@property(nonatomic,copy)NSString* basicStatus;// 状态
@property(nonatomic,copy)NSString *icon;//头像
@property(nonatomic,copy)NSString *branchName;//车牌
@property(nonatomic,copy)NSString *phone;//电话
@property(nonatomic,copy)NSString *role;//性别
@property(nonatomic,copy)NSString *logisticsName;//车型
@property (nonatomic,strong)NSString *logisticsId;

@end
