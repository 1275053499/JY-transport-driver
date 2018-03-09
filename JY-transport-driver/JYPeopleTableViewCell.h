//
//  JYPeopleTableViewCell.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/29.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYPeopleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *supView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *outlets;
@property (weak, nonatomic) IBOutlet UIButton *idetorBtn;
@property (weak, nonatomic) IBOutlet UILabel *role;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
