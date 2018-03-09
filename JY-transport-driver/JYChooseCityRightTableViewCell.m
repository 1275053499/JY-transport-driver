//
//  JYChooseCityRightTableViewCell.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/8.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYChooseCityRightTableViewCell.h"

@implementation JYChooseCityRightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"JYChooseCityRightTableViewCell";
    JYChooseCityRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
