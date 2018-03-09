//
//  MineRequestData.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MineRequestDataDelegate.h"

@interface MineRequestData : NSObject

@property (nonatomic,strong)id <MineRequestDataDelegate>delegate;

+ (id)shareInstance;

//把七牛云图片名称上传到服务器 
- (void)requsetDataUrl:(NSString *)url Id:(NSString *)Id icon:(NSString *)icon;

/**
 *  获取司机余额
 *@para
 *@para
 *@para
 */
- (void)requestDataGetWalletForDriver:(NSString*)url phone:(NSString*)tel idea:(NSString *)idea;



// 物流加盟
- (void)requestDataJoinLog:(NSString*)url phone:(NSString*)tel company:(NSString *)name businessLicense:(NSString*)businss;

@end
