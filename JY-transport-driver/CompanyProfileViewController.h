//
//  CompanyProfileViewController.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/18.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CompanyProfileViewControllerDelegate <NSObject>

- (void)changeIntroductionsValue:(NSString *)value;

@end


@interface CompanyProfileViewController : BaseViewController

@property (nonatomic,strong)NSString *profileStr;
@property (nonatomic,strong)id <CompanyProfileViewControllerDelegate> delegate;

@end
