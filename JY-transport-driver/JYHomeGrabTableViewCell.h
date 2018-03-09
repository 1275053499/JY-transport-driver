//
//  JYHomeGrabTableViewCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/16.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYGraSingleModel.h"
@interface JYHomeGrabTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *graSingleBtn;
@property (nonatomic,strong)JYGraSingleModel *singleModel;

+ (instancetype)cellWithOrderTableView:(UITableView *)tableView;

@end
