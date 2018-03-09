//
//  MyiconImageView.h
//  JY-transport
//
//  Created by 闫振 on 2017/12/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompanyModelInfo;
@class ClerkModel;
@class driverInfoModel;
@interface MyiconImageView : UIImageView

@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *phoneLabel;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UIButton *chooseIconBtn;

@property (nonatomic,strong)CompanyModelInfo *companyModel;
@property (nonatomic,strong)ClerkModel *clerkModel;
@property (nonatomic,strong)driverInfoModel *drivModel;

@end
