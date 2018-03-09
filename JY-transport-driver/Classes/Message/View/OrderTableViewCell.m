//
//  OrderTableViewCell.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "ModelOrder.h"
@interface OrderTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourcedownLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property(nonatomic,strong)NSMutableArray *arrivePlaceArray;
@property(nonatomic,strong)NSMutableArray *arrivePlaceAddressArray;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@end
@implementation OrderTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderTableViewCell";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}



- (void)setModel:(ModelOrder *)model
{

    _model = model;
    self.timeLabel.text = model.createDate;
    
    self.orderLabel.text = [NSString stringWithFormat:@"订单编号: %@",model.orderNo];
    //分割字符串
    
    self.arrivePlaceArray = [NSMutableArray array];
    self.arrivePlaceAddressArray = [NSMutableArray array];
    NSArray *arrivePlaceArray = [model.arrivePlace componentsSeparatedByString:@","];
    NSArray *arrivePlaceAddressArray = [model.district componentsSeparatedByString:@","];
    [self.arrivePlaceArray addObjectsFromArray:arrivePlaceArray];
    [self.arrivePlaceAddressArray addObjectsFromArray:arrivePlaceAddressArray];
    
    if ([model.arrivePlace  rangeOfString:@","].location != NSNotFound) {
        
            [self.arrivePlaceArray removeLastObject];
            [self.arrivePlaceAddressArray removeLastObject];
     }else{
         
    }
    self.sourceTopLabel.text = model.departPlace;
    self.sourcedownLabel.text = model.city;
   // NSRange range = [model.city rangeOfString:model.departPlace];
  //  self.sourcedownLabel.text = [model.city substringToIndex:range.location];
    
self.sourcedownLabel.text = model.city;
  
    
    self.destinationTopLabel.text = self.arrivePlaceArray.lastObject;
    
     //self.destinationTopLabel.text = self.arrivePlaceArray.firstObject;
    //NSRange DesRange = [model.district rangeOfString:model.arrivePlace];
    
    self.destinationDownLabel.text = self.arrivePlaceAddressArray.lastObject;
    self.moneyLabel.text = [@"¥" stringByAppendingString:[NSString stringWithFormat:@"%.0f",model.bid]];
    self.carTypeLabel.textColor = [UIColor colorWithHexString:@"#DD7C6D"];

    if ([model.basicStatus isEqualToString:@"0"]) {
        
        self.carTypeLabel.text = @"申请中";
    }else if ([model.basicStatus isEqualToString:@"1"]){
        self.carTypeLabel.text = @"已接单";
    }else if ([model.basicStatus isEqualToString:@"2"]){
        self.carTypeLabel.text = @"进行中";
    }else if ([model.basicStatus isEqualToString:@"3"]){
        self.carTypeLabel.text = @"未支付";
    }else if ([model.basicStatus isEqualToString:@"4"]){
        self.carTypeLabel.text = @"未评价";
    }else if ([model.basicStatus isEqualToString:@"9"]){
        self.carTypeLabel.text = @"已完成";
    }else if ([model.basicStatus isEqualToString:@"5"]){
        self.carTypeLabel.text = @"取消";
    }else if ([model.basicStatus isEqualToString:@"6"]){
        self.carTypeLabel.text = @"等待确认";
    }else if ([model.basicStatus isEqualToString:@"7"]){
        self.carTypeLabel.text = @"装货中";
    }else if ([model.basicStatus isEqualToString:@"8"]){
        self.carTypeLabel.text = @"卸货中";
    }else{
    
    
    }
    
//    NSMutableArray *serviseArr = [NSMutableArray array];
//    NSArray *serviseArray = [model.service componentsSeparatedByString:@","];
//    
//    for (NSString *str in serviseArray) {
//        
//       if ([str isEqualToString:@"7"]){
//           
//            self.carTypeLabel.text = @"专车";
//           
//        }else if ([str isEqualToString:@"8"]){
//            
//       self.carTypeLabel.text = @"回程车";
//            
//        }else{
//            
//            
//        }

    //}
        
    
    

    
    




}




@end
