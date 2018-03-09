//
//  DriverApplyImgTableViewCell.m
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/9.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "DriverApplyImgTableViewCell.h"

@interface DriverApplyImgTableViewCell ()

@end
@implementation DriverApplyImgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self commonInit];
    }
    
    return self;
    
}
- (void)commonInit{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180 * HOR_SCALE)];
    
    _imgBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_imgBtn setBackgroundImage:[UIImage imageNamed:@"img_add"] forState:(UIControlStateNormal)];
    [backView addSubview:_imgBtn];
    
    [[_imgBtn imageView] setContentMode:UIViewContentModeScaleAspectFill];
    _imgBtn.clipsToBounds = YES;

    [self.contentView addSubview:backView];
  
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = RGB(102, 102, 102);
    _nameLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:14];
    [self.contentView addSubview:_nameLabel];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);

    }];
    
    [_imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).mas_offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(300 * HOR_SCALE);
        make.height.mas_equalTo(130 * HOR_SCALE);

    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_imgBtn.mas_bottom).mas_offset(8);
        make.centerX.equalTo(_imgBtn.mas_centerX);
       
    }];
    
   
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
