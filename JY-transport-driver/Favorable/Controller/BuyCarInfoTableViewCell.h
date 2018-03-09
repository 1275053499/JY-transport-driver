//
//  BuyCarInfoTableViewCell.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/12/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyCarInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@end
