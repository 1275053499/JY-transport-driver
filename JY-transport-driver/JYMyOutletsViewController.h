//
//  JYMyOutletsViewController.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/29.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYOutletsModel;
@protocol JYMyOutletsViewControllerDelegate <NSObject>

- (void)chooseOurletsForAddPeople:(JYOutletsModel *)model;

@end

@interface JYMyOutletsViewController : UIViewController

@property (nonatomic,strong)NSString *whichVCPush;

@property (nonatomic,strong)id <JYMyOutletsViewControllerDelegate>delegate;
@end
