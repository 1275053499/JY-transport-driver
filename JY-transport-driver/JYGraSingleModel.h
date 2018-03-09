//
//  JYGraSingleModel.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JYGraSingleModel : NSObject
@property (nonatomic,strong)NSString *deliveryTime;
@property (nonatomic,strong)NSString *describeContent;
@property (nonatomic,strong)NSString *describePhoto;
@property (nonatomic,strong)NSString *destinationCity;
@property (nonatomic,strong)NSString *destinationProvince;
@property (nonatomic,strong)NSString *destination;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *insuranceAmount;
@property (nonatomic,strong)NSString *isDistribution;
@property (nonatomic,strong)NSString *isInsure;
@property (nonatomic,strong)NSString *isLieu;
@property (nonatomic,strong)NSString *isWarehousing;
@property (nonatomic,strong)NSDictionary *jyCargoDetails;
@property (nonatomic,strong)NSString *lieuAmount;
@property (nonatomic,strong)NSString *orderStatus;
@property (nonatomic,strong)NSString *orderTime;
@property (nonatomic,strong)NSString *orderType;
@property (nonatomic,strong)NSString *serviceDetails;
@property (nonatomic,strong)NSString *remarks;
@property (nonatomic,strong)NSString *originatingCity;
@property (nonatomic,strong)NSString *originatingProvince;
@property (nonatomic,strong)NSString *originatingSite;
@property (nonatomic,strong)NSString *transportNumber;
@property (nonatomic,strong)NSString *valueofGoods;
@property (nonatomic,strong)NSString *orderNo;

@property (nonatomic,assign)int timeType;
@end
