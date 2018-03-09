//
//  driverInfoModel.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/6/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface driverInfoModel : NSObject<NSCoding>
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *name;//司机姓名
@property(nonatomic,copy)NSString *basicStatus;// 状态
@property(nonatomic,copy)NSString *icon;//头像
@property(nonatomic,copy)NSString *licensePlate;//车牌
@property(nonatomic,copy)NSString *phone;//电话
@property(nonatomic,copy)NSString *sexuality;//性别
@property(nonatomic,copy)NSString *vehicle;//车型
@property (nonatomic,copy)NSString *wechatAccount;//微信
@property (nonatomic,copy)NSString *ailpayAccount;//支付宝
@property (nonatomic,assign)NSInteger isAuthentication;//是否认证
@property (nonatomic,copy)NSString *bankCard;//银行卡

@end

