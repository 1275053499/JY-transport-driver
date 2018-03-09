//
//  driverApplyCell.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/23.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "driverApplyCell.h"

@implementation driverApplyCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"driverApplyCell";
    driverApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}

@end
