//
//  JYAccountTool.h
//  JY-transport
//
//  Created by 王政的电脑 on 17/4/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ClerkModel;
@class ModelOfUserInfo;
@class driverInfoModel;
@class CompanyModelInfo;
@interface JYAccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 需要存储的账号
 */
+ (void)saveAccount:(ModelOfUserInfo *)account;

/**
 *  返回存储的账号信息
 */
+ (ModelOfUserInfo *)account;

+(void)saveUserName:(NSString *)userName;

+(NSString *)userName;

+ (void)deleteJYAccount;


+ (driverInfoModel*)getDriverInfoModelInfo;

+ (void)saveDriverInfoModelInfo:(driverInfoModel *)model;


+(void)saveUserNameForLogistics:(NSString *)userName;

+(NSString *)userNameForLogistics;

/**
 *  获得存储公司信息
 */

+ (CompanyModelInfo*)getLogisticsModelInfo;

/**
 *  存储公司信息
 */
+ (void)saveLogisticsModelInfo:(CompanyModelInfo *)model;

+(void)saveUserLoginType:(NSString *)loginType;

/**
 *  存储业务员信息
 */
+ (void)saveLogisticsclerkModelInfo:(ClerkModel *)model;

/**
 *  获取业务员信息
 */
+ (ClerkModel*)getLogisticsclerkModelInfo;


+(NSString *)loginType;
@end
