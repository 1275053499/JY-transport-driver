//
//  AllWithdrawTableViewCell.h
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/11.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllWithdrawTableViewCell : UITableViewCell

@property (nonatomic,strong)UIButton *withdrawBtn;
@property (nonatomic,strong)NSString *balance;


- (void)cellWithDate:(NSString *)str;
@end
