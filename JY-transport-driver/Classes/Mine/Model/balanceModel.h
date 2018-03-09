//
//  balanceModel.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/23.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface balanceModel : NSObject
@property(nonatomic,copy)NSString *owner;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *idea;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *balance;//余额
@property(nonatomic,copy)NSString *updateDate;
@property(nonatomic,copy)NSString *remarks;
@property(nonatomic,copy)NSString *wallpw;
@property(nonatomic,copy)NSString *isNewRecord;

@end
