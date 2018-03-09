//
//  CompanyModelInfo.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/6.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyModelInfo : NSObject<NSCoding>


@property (nonatomic,strong)NSString *basicStatus;
@property (nonatomic,strong)NSString *businessLicense;
@property (nonatomic,strong)NSString *companyname;
@property (nonatomic,strong)NSString *createDate;
@property (nonatomic,strong)NSString *icon;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *introductions;
@property (nonatomic,strong)NSString *landline;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *remark;
@property (nonatomic,strong)NSString *updateDate;
@end
