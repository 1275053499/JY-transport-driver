//
//  BindAccountViewController.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/10/24.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    BindAccountForWeChat = 1,      ///物流公司登录
    BindAccountForAli = 2,         ///物流公司下业务员登录
   
}WhichccountToBind;


@interface BindAccountViewController : UIViewController
@property (nonatomic,assign)WhichccountToBind type;


@end
