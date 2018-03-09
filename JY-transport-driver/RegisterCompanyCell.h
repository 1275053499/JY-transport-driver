//
//  RegisterCompanyCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/14.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterCompanyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITextField *textfield;



+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
