//
//  JYORderNumberTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYORderNumberTableViewCell.h"
#import "JYOrderDetailModel.h"
@implementation JYORderNumberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(JYOrderDetailModel *)model{
    
    _model = model;
    _orderTime.text = model.orderTime;
    _orderNum.text = model.orderNo;
    if ([model.orderStatus isEqualToString:@"0"]) {
        _orderStatus.text = @"等待抢单";
        
    }else if ([model.orderStatus isEqualToString:@"1"]){
        
        _orderStatus.text = @"等待估价";
        
    }else if ([model.orderStatus isEqualToString:@"2"] || [model.orderStatus isEqualToString:@"7"]){
        
        _orderStatus.text = @"等待确认";
        
    }else if ([model.orderStatus isEqualToString:@"3"]){
        
        _orderStatus.text = @"等待揽件";
        
    }else if ([model.orderStatus isEqualToString:@"4"]){
        
        _orderStatus.text = @"运输中";
        
    }else if ([model.orderStatus isEqualToString:@"5"]){
        
        _orderStatus.text = @"未评价";
        
    }else if ([model.orderStatus isEqualToString:@"6"]){
        
        _orderStatus.text = @"已取消";
        
    }else if ([model.orderStatus isEqualToString:@"8"]){
        
        _orderStatus.text = @"派件中";
        
    }else if ([model.orderStatus isEqualToString:@"9"]){
        
        _orderStatus.text = @"已评价";
        
    }else{
        _orderStatus.text = @"状态异常";
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
