//
//  JYAccountTool.m
//  JY-transport
//
//  Created by 王政的电脑 on 17/4/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//
#define DF_userName @"userName"
#define DF_userName_log @"userNameLog"
#define IWAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]
#import "JYAccountTool.h"
#import "driverInfoModel.h"
#import "CompanyModelInfo.h"
#import "ClerkModel.h"
@implementation JYAccountTool




+ (void)deleteAccount
{
    NSError *error;
    BOOL isDelete = [[NSFileManager defaultManager] removeItemAtPath:IWAccountFile error:&error];
    if (isDelete) {
        NSLog(@"清除账号成功");
    }else{
        NSLog(@"清除账号失败");
    }
}

+ (void)saveAccount:(ModelOfUserInfo *)account
{
    if (account == nil) {
    
        return;
    }
    [NSKeyedArchiver archiveRootObject:account toFile:IWAccountFile];
}


+ (ModelOfUserInfo *)account
{
    // 取出账号
    ModelOfUserInfo *account = [NSKeyedUnarchiver unarchiveObjectWithFile:IWAccountFile];
    
    return account;
}

+(void)saveUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:DF_userName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)userName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:DF_userName];
}

+ (void)deleteJYAccount
{
      //BOOL isDelete = [[NSFileManager defaultManager] removeItemAtPath:IWAccountFile error:&error];
      [[NSUserDefaults standardUserDefaults]removeObjectForKey:DF_userName];
      [[NSUserDefaults standardUserDefaults]removeObjectForKey:DF_userName_log];

    
    
}

+ (driverInfoModel*)getDriverInfoModelInfo{
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:@"driverInfo.data"];
    
    driverInfoModel *driverModel = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    return driverModel;
}

+ (void)saveDriverInfoModelInfo:(driverInfoModel *)model{
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:@"driverInfo.data"];
    // 2.3.将对象归档
    [NSKeyedArchiver archiveRootObject:model toFile:path];
}



+(void)saveUserNameForLogistics:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:DF_userName_log];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)userNameForLogistics
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:DF_userName_log];
}

+ (CompanyModelInfo*)getLogisticsModelInfo{
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:@"LogisticsInfo.data"];
    
    CompanyModelInfo *driverModel = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    return driverModel;
}
+ (void)saveLogisticsModelInfo:(CompanyModelInfo *)model{
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:@"LogisticsInfo.data"];
    // 2.3.将对象归档
    [NSKeyedArchiver archiveRootObject:model toFile:path];

}


+ (ClerkModel *)getLogisticsclerkModelInfo{
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:@"Logisticsclerk.data"];
    
    ClerkModel *clerkModel = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    return clerkModel;
}
+ (void)saveLogisticsclerkModelInfo:(ClerkModel *)model{
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:@"Logisticsclerk.data"];
    // 2.3.将对象归档
    [NSKeyedArchiver archiveRootObject:model toFile:path];
    
}
+(void)saveUserLoginType:(NSString *)loginType{
    
    [[NSUserDefaults standardUserDefaults] setObject:loginType forKey:UserLoginType];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(NSString *)loginType{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserLoginType];

}
@end
