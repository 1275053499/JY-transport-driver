//
//  JYLookLogisticsViewController.h
//  JY-transport
//
//  Created by 闫振 on 2017/9/5.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYOrderDetailModel;
@interface JYLookLogisticsViewController : UIViewController
@property (nonatomic,strong)NSString *transportNumber;
@property (nonatomic,strong)JYOrderDetailModel *orderDetailModel;

@end
