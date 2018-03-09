//
//  JYChooseCityRightTableViewCell.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/8.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYChooseCityRightTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectImage;

@property (weak, nonatomic) IBOutlet UIButton *nameBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
