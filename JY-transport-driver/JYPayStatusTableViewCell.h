//
//  JYPayStatusTableViewCell.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYOrderDetailModel;

@interface JYPayStatusTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusName;

@property (nonatomic,strong)JYOrderDetailModel *model;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
