//
//  EntryScanViewController.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/23.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EntryScanViewControllerDelegate <NSObject>

- (void)chooseOrderNumber:(NSString *)str;

@end

@interface EntryScanViewController : UIViewController

@property (nonatomic,strong)id <EntryScanViewControllerDelegate> delegate;
@property (nonatomic,strong)NSString *whitchVCFrom;
@property (nonatomic,strong)NSString *orderId;

@end
