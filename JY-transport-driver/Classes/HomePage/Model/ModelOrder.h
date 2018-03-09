//
//  ModelOrder.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "driverModel.h"
@interface ModelOrder : NSObject
//到达地方
@property(nonatomic,copy)NSString *arrivePlace;
//出发时间
@property(nonatomic,copy)NSString *basicStatus;
//出价
@property(nonatomic,assign)double bid;
//出发城市的街道
@property(nonatomic,copy)NSString *city;
//
@property(nonatomic,copy)NSString *createDate;
//服务天数
@property(nonatomic,copy)NSString *days;
//出发地方
@property(nonatomic,copy)NSString *departPlace;
//出发时间
@property(nonatomic,strong)NSString *departTime;
//
@property(nonatomic,copy)NSString *district;
//
@property(nonatomic,copy)NSString *endLatitude;
//
@property(nonatomic,copy)NSString *endLongitude;
//
@property(nonatomic,copy)NSString *reqApplicant;
//创建人
@property(nonatomic,copy)NSString *reqName;
//服务
@property(nonatomic,copy)NSString *service;
//估价
@property(nonatomic,copy)NSString *serviceStaff;
//出价
@property(nonatomic,copy)NSString *updateDate;
//出价
@property(nonatomic,copy)NSString *id;

//估价
@property(nonatomic,copy)NSString *vehicle;
//车型
@property(nonatomic,copy)NSString *vehicleType;
@property(nonatomic,copy)NSString *longitude;
@property(nonatomic,copy)NSString *latitude;
//估价
@property(nonatomic,assign)double  evaluate;
@property(nonatomic,copy)NSString *isNewRecord;
//单号
@property(nonatomic,copy)NSString *orderNo;
//联系人
@property(nonatomic,copy)NSString *contacts;
//手机
@property(nonatomic,copy)NSString *phone;
//省
@property(nonatomic,copy)NSString *province;
//创建人
@property(nonatomic,copy)NSString *createBy;
//备注
@property(nonatomic,copy)NSString *remark;

@property(nonatomic,strong)driverModel *jyTruckergroup;

@property (nonatomic,assign)int timeType;

@property (nonatomic,strong)NSString *isLieu;//是否代收货款
@property (nonatomic,strong)NSString *lieuAmount;//代收金额

@property (nonatomic,strong)NSString *annexDescription;//单据描述
@property (nonatomic,strong)NSString *enclosure;//单据图片
@end
