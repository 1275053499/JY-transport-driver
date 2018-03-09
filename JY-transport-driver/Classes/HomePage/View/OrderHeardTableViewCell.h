//
//  OrderHeardTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/10/11.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHeardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *heardName;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
