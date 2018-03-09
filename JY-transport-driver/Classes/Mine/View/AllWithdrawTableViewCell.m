//
//  AllWithdrawTableViewCell.m
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/11.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "AllWithdrawTableViewCell.h"

@interface AllWithdrawTableViewCell ()
@property (nonatomic,strong)UILabel *nameLabel;
@end
@implementation AllWithdrawTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = RGB(102, 102, 102);
    _nameLabel.text = @"零钱余额¥0";
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:14];
    [self.contentView addSubview:_nameLabel];
    
    _withdrawBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_withdrawBtn setTitleColor:BGBlue forState:(UIControlStateNormal)];
    _withdrawBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:14];

    [_withdrawBtn setTitle:@"全部提现" forState:(UIControlStateNormal)];
    [self.contentView addSubview:_withdrawBtn];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo (self.mas_left).mas_offset(15);
        make.centerY.equalTo (self.mas_centerY);
        make.height.mas_equalTo(40);
        
    }];
    
    [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo (_nameLabel.mas_right).mas_offset(-2);
        make.centerY.equalTo (_nameLabel.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        
    }];
    
}

- (void)setBalance:(NSString *)balance{
    
    _balance = balance;
    _nameLabel.text = [NSString stringWithFormat:@"零钱余额¥%@",balance];

}
- (void)cellWithDate:(NSString *)str{
   
    if ([str floatValue] > [_balance floatValue]) {
        _nameLabel.text = @"输入金额超过零钱余额";
        _nameLabel.textColor = RGB(247, 94, 94);
        _withdrawBtn.hidden = YES;
    }else{
        _nameLabel.textColor = RGB(102, 102, 102);
        _nameLabel.text = [NSString stringWithFormat:@"零钱余额¥%@",_balance];
        _withdrawBtn.hidden = NO;
    }
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
