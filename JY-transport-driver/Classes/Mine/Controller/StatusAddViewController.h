//
//  StatusAddViewController.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/9.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StatusAddViewControllerDelegate <NSObject>

- (void)addLogStatus:(NSString *)str;

@end
@interface StatusAddViewController : UIViewController

@property (nonatomic,strong)id <StatusAddViewControllerDelegate> delegate;
@end