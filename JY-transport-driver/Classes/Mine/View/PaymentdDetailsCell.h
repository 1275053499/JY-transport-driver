//
//  PaymentdDetailsCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/8.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentdDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *paymentType;
@property (weak, nonatomic) IBOutlet UILabel *paymentName;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
