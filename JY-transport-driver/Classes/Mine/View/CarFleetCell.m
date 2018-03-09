//
//  CarFleetCell.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "CarFleetCell.h"

@interface CarFleetCell()
//车主头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
//车主名字
@property (weak, nonatomic) IBOutlet UILabel *name;
//车牌
@property (weak, nonatomic) IBOutlet UILabel *plateNumber;

@property (weak, nonatomic) IBOutlet UILabel *Cartype;

@property (weak, nonatomic) IBOutlet UIButton *telPhoneCallBUtton;

@property (weak, nonatomic) IBOutlet UIButton *starButton;

@end
@implementation CarFleetCell



- (IBAction)callPhoneButton:(id)sender {
    
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CarFleetCell";
    CarFleetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}

@end
