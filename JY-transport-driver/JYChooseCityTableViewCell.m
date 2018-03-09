//
//  JYChooseCityTableViewCell.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/8.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYChooseCityTableViewCell.h"

@implementation JYChooseCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"JYChooseCityTableViewCell";
    JYChooseCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.name.highlightedTextColor = RGB(105, 181, 240);

    self.name.highlighted = selected;
    self.blueView.hidden = !selected;
    
}

@end
