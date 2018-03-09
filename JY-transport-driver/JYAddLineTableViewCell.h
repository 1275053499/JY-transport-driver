//
//  JYAddLineTableViewCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/22.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYAddLineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *lineTextField;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeHeighConstr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeImgWidthConstr;
@property (weak, nonatomic) IBOutlet UIButton *selectAddressBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
