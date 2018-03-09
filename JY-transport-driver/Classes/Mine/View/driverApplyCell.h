//
//  driverApplyCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/23.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface driverApplyCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIImageView *textFieldIcon;

@property (weak, nonatomic) IBOutlet UITextField *textField;



@end
