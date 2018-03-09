//
//  RefundDepositView.m
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/18.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "RefundDepositView.h"
#import "driverInfoModel.h"
@interface RefundDepositView ()

@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)UIButton *confirmBtn;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIView *linView;

@end
@implementation RefundDepositView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {

        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
    UIButton *bottomBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    bottomBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:bottomBtn];
    _bottomBtn = bottomBtn;
    [self addSubview:_bottomBtn];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.layer.cornerRadius = 5;
    _bottomView.layer.masksToBounds = YES;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_bottomBtn addSubview:_bottomView];
    
    
    [_bottomView addSubview:self.titleLabel];
    [_bottomView addSubview:self.contentLabel];
    [_bottomView addSubview:self.cancelBtn];
    [_bottomView addSubview:self.confirmBtn];
    [_bottomView addSubview:self.linView];
    
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(220 * HOR_SCALE);
        make.width.mas_equalTo(310 * HOR_SCALE);
        make.centerX.mas_equalTo(_bottomBtn.mas_centerX);
        make.centerY.mas_equalTo(_bottomBtn.mas_centerY);

    }];
    
   
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_bottomView.top).mas_offset(15);
        make.centerX.mas_equalTo(_bottomView.mas_centerX);

    }];
    
    [self.linView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_bottomView.mas_top).mas_offset(50);
        make.left.mas_equalTo(_bottomView.mas_left).mas_offset(0);
        make.right.mas_equalTo(_bottomView.mas_right).mas_offset(0);
        make.height.mas_equalTo(0.5);
        
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_titleLabel.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(_bottomView.mas_left).mas_offset(15);
        make.right.mas_equalTo(_bottomView.mas_right).mas_offset(-15);

    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_contentLabel.mas_bottom).mas_offset(20);

        make.left.mas_equalTo(_bottomView.mas_left).mas_offset(15);
        make.right.mas_equalTo(_bottomView.mas_right).mas_offset(-15);
        make.height.mas_equalTo(44 * HOR_SCALE);
        
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_confirmBtn.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(_bottomView.mas_left).mas_offset(15);
        make.right.mas_equalTo(_bottomView.mas_right).mas_offset(-15);
        make.height.mas_equalTo(44 * HOR_SCALE);
        
    }];
   
}
- (void)setModel:(NSString *)tipContent title:(NSString *)title{
    
    self.titleLabel.text = title;
    self.contentLabel.text = tipContent;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:BGBlue forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_cancelBtn sizeToFit];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _confirmBtn.layer.cornerRadius = 5;
        _confirmBtn.layer.masksToBounds = YES;
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setBackgroundColor:BGBlue];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_confirmBtn sizeToFit];
        
    }
    return _confirmBtn;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = RGB(51, 51, 51);
        _titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:18];
    }
    
    return _titleLabel;
}
- (UIView *)linView{
    if (!_linView) {
        _linView = [[UIView alloc] init];
        _linView.backgroundColor = RGB(238, 238, 238);
       
    }
    
    return _linView;
}

- (UILabel *)contentLabel{
    
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"";
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = RGB(102, 102, 102);
        _contentLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:14];
    }
    
    return _contentLabel;
}
- (void)bottomBtnClick:(UIButton *)btn{
    
    [self disMissView];
    
}
- (void)confirmAction:(UIButton *)btn{
    
    if (_refundDepositBlock) {
        [self disMissView];
        _refundDepositBlock();
    }
   
}
- (void)disMissView{
    
    [self removeFromSuperview];
    
}
- (void)showBankPickView{
    
    UIWindow *wind = [UIApplication sharedApplication].keyWindow;
    [wind addSubview: self];
    
}
@end
