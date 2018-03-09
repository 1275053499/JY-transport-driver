//
//  JYPayStatusTableViewCell.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYPayStatusTableViewCell.h"
#import "JYOrderDetailModel.h"
@implementation JYPayStatusTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"JYPayStatusTableViewCell";
    JYPayStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
    
}

- (void)setModel:(JYOrderDetailModel *)model{
    
    _model = model;
    _statusName.text = @"订单状态:";
    
    if ([model.orderType isEqualToString:@"2"]) {
        [self orderStatusNameForHongKong:model];
    }else if ([model.orderType isEqualToString:@"1"]) {
        
        [self orderStatusName:model];
    }
    
}
- (void)orderStatusNameForHongKong:(JYOrderDetailModel *)messageModel{
    if ([messageModel.orderStatus isEqualToString:@"0"]) {
        _statusLabel.text = @"等待接单";
        
    }else if ([messageModel.orderStatus isEqualToString:@"1"] || [messageModel.orderStatus isEqualToString:@"2"] ||[messageModel.orderStatus isEqualToString:@"3"] || [messageModel.orderStatus isEqualToString:@"7"]){
        _statusLabel.text = @"等待揽件";
        
    }else if ([messageModel.orderStatus isEqualToString:@"4"]){
        
        _statusLabel.text = @"运输中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"5"]){
        
        _statusLabel.text = @"未评价";
        
    }else if ([messageModel.orderStatus isEqualToString:@"6"]){
        
        _statusLabel.text = @"已取消";
        
    }else if ([messageModel.orderStatus isEqualToString:@"8"]){
        
        _statusLabel.text = @"派件中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"9"]){
        
        _statusLabel.text = @"已评价";
        
    }else{
        _statusLabel.text = @"状态异常";
    }
    
}
- (void)orderStatusName:(JYOrderDetailModel *)messageModel{
    
    if ([messageModel.orderStatus isEqualToString:@"0"]) {
        _statusLabel.text = @"等待抢单";
        
    }else if ([messageModel.orderStatus isEqualToString:@"1"]){
        
        _statusLabel.text = @"等待估价";
        
    }else if ([messageModel.orderStatus isEqualToString:@"2"] || [messageModel.orderStatus isEqualToString:@"7"]){
        
        _statusLabel.text = @"等待确认";
        
    }else if ([messageModel.orderStatus isEqualToString:@"3"]){
        
        _statusLabel.text = @"等待揽件";
        
    }else if ([messageModel.orderStatus isEqualToString:@"4"]){
        
        _statusLabel.text = @"运输中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"5"]){
        
        _statusLabel.text = @"未评价";
        
    }else if ([messageModel.orderStatus isEqualToString:@"6"]){
        
        _statusLabel.text = @"已取消";
        
    }else if ([messageModel.orderStatus isEqualToString:@"8"]){
        
        _statusLabel.text = @"派件中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"9"]){
        
        _statusLabel.text = @"已评价";
        
    }else{
        _statusLabel.text = @"状态异常";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
