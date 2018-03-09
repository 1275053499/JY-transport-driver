//
//  JYORderNumberTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/9/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYOrderDetailModel;
@interface JYORderNumberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (nonatomic,strong)JYOrderDetailModel *model;

@end
