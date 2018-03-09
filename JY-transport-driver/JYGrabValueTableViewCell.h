//
//  JYGrabValueTableViewCell.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYGrabValueTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sendType;
@property (weak, nonatomic) IBOutlet UIImageView *orderTypeImg;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setDateFromString:(NSString *)str;
@end
