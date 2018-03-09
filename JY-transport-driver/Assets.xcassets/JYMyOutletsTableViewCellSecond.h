//
//  JYMyOutletsTableViewCellSecond.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/29.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYMyOutletsTableViewCellSecond : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telPhoneLabel;


@property (weak, nonatomic) IBOutlet UIButton *idetorBtn;
@property (weak, nonatomic) IBOutlet UILabel *outletsName;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
