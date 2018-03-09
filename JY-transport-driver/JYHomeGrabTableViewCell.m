//
//  JYHomeGrabTableViewCell.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/16.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYHomeGrabTableViewCell.h"



#define kimageEdge  10

#define kimageHeight  35
@interface JYHomeGrabTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statrImgView;
@property (weak, nonatomic) IBOutlet UIImageView *endImgView;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zoneImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;

@property (weak, nonatomic) IBOutlet UIView *serviceTypeBigView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigViewConstraint;//高度约束

@property (nonatomic,assign)CGFloat bigViewHeight;//计算出承载serviceType  view的height
@end

@implementation JYHomeGrabTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithOrderTableView:(UITableView *)tableView
{
    static NSString *ID = @"JYHomeGrabTableViewCell";
    JYHomeGrabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
        
    }
    return cell;
}


- (void)setSingleModel:(JYGraSingleModel *)singleModel{
    
    
    _graSingleBtn.layer.cornerRadius = 40;
    _graSingleBtn.layer.masksToBounds = YES;
    _startLabel.text = @"深圳市宝安区民治街道";

    _endLabel.text = @"深圳市宝安区龙华新区民治";
    NSArray *arr = @[@"货到付款",@"同城",@"送货上门"];

    int line = 1;
    CGFloat ViewX = 0;
    for (int i = 0; i < arr.count; i++) {
  
        UIFont *font = [UIFont fontWithName:Default_APP_Font size:12];
        CGFloat kStrWidth = [self measureSinglelineStringWidth:arr[i] andFont:font];
        
        ViewX = (ViewX + kimageEdge);
        
        if ((ViewX  + kStrWidth + kimageEdge) > ScreenWidth ) {
            line ++;
            ViewX = kimageEdge;
        }
        CGFloat ViewY =  line  * kimageEdge + (line -1) * kimageHeight;
        
        _bigViewHeight = (line +1 ) * kimageEdge + line *kimageHeight;
        _bigViewConstraint.constant = _bigViewHeight;
        [self layoutIfNeeded];
        NSLog(@"%f",_bigViewHeight);
        FMButton *button = [FMButton createFMButton];
       
        button.titleLabel.font = font;
        button.backgroundColor = RGB(237,244,250);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.layer.cornerRadius = 5;
        button.frame = CGRectMake(ViewX, ViewY, kStrWidth, kimageHeight);
        ViewX = kStrWidth + ViewX;
        NSLog(@"%@",button);
        
        [self.serviceTypeBigView addSubview:button];
    }
 
}

- (float)measureSinglelineStringWidth:(NSString*)str andFont:(UIFont*)wordFont{
    
    if (str == nil){
        return 0;
    }
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize size = [str boundingRectWithSize:CGSizeMake(ScreenWidth-20, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : wordFont,NSParagraphStyleAttributeName:style} context:nil].size;
    return size.width + 20;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

