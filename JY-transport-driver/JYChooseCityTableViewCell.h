//
//  JYChooseCityTableViewCell.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/8.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYChooseCityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIView *blueView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
