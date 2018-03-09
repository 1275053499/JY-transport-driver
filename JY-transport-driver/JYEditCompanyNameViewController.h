//
//  JYEditCompanyNameViewController.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/30.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JYEditCompanyNameViewControllerDelegate <NSObject>

-(void)changeNameValue:(NSString *)value;

@end

@interface JYEditCompanyNameViewController : UIViewController
@property (nonatomic,strong)id <JYEditCompanyNameViewControllerDelegate>delegate;
@property (nonatomic,strong)NSString *nameStr;


@end
