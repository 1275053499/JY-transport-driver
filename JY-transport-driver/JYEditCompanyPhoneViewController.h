//
//  JYEditCompanyPhoneViewController.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/30.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYEditCompanyPhoneViewControllerDelegate <NSObject>

-(void)changePhoneValue:(NSString *)value;

@end

@interface JYEditCompanyPhoneViewController : UIViewController

@property (nonatomic,strong)id <JYEditCompanyPhoneViewControllerDelegate>delegate;
@property (nonatomic,strong)NSString *phoneStr;

@end
