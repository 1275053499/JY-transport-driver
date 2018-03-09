//
//  BankPickerView.m
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/16.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "BankPickerView.h"

@interface BankPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIPickerView *bankPickView;
@property (nonatomic,strong)NSArray *bankArr;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *confirmBtn;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *nameId;

@end
@implementation BankPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        _name = @"";
        _nameId = @"";
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
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_bottomBtn addSubview:_bottomView];
    
    _bankPickView = [[UIPickerView alloc] init];
    _bankPickView.delegate = self;
    _bankPickView.dataSource = self;
    [_bottomView addSubview:_bankPickView];
    
    [_bottomView addSubview:self.cancelBtn];
    [_bottomView addSubview:self.confirmBtn];
    
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(240);
        make.right.mas_equalTo(_bottomBtn.mas_right);
        make.left.mas_equalTo(_bottomBtn.mas_left);
        make.bottom.mas_equalTo(_bottomBtn.mas_bottom).mas_offset(0);
        
    }];
    
    [_bankPickView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_bottomView.top).mas_offset(0);
        make.right.mas_equalTo(_bottomView.mas_right);
        make.left.mas_equalTo(_bottomView.mas_left);
        make.bottom.mas_equalTo(_bottomView.mas_bottom).mas_offset(0);
        
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_bankPickView.top).mas_offset(5);
        make.left.mas_equalTo(_bankPickView.mas_left).mas_offset(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(45);
        
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_bankPickView.top).mas_offset(5);
        make.right.mas_equalTo(_bankPickView.mas_right).mas_offset(0);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(45);
        
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"banklist" ofType:@"plist"];
    _bankArr = [[NSArray alloc] initWithContentsOfFile:path];
    
    
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:BGBlue forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn sizeToFit];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:BGBlue forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_confirmBtn sizeToFit];
        
    }
    return _confirmBtn;
}
- (void)bottomBtnClick:(UIButton *)btn{
    
    [self disMissView];
    
}
- (void)confirmAction:(UIButton *)btn{
    NSDictionary *bankDic =  _bankArr[0];
    NSString *name = [bankDic objectForKey:@"name"];
    NSString *nameId = [bankDic objectForKey:@"bankId"];
    
    if (_name == nil || _name.length <= 0) {
        _name = name;
        _nameId = nameId;
    }
    if (_bankNameBlock) {
        _bankNameBlock(_name,_nameId);
        
        [self disMissView];
    }
}
- (void)disMissView{
    
    
    [self removeFromSuperview];
    
}
- (void)showBankPickView{
    
    UIWindow *wind = [UIApplication sharedApplication].keyWindow;
    [wind addSubview: self];
    
}


- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _bankArr.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *titleLabel = (UILabel *)view;
    if (!titleLabel)
    {
        titleLabel = [self labelForPickerView];
    }
    
    NSDictionary *bankDic =  _bankArr[row];
    NSString *name = [bankDic objectForKey:@"name"];
    
    titleLabel.text = name;
    return titleLabel;
    
    
}
- (UILabel *)labelForPickerView{
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGB(102, 102, 102);
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}
//选择指定列、指定列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSDictionary *dic = _bankArr[row];
    _nameId = [dic objectForKey:@"bankId"];
    _name = [dic objectForKey:@"name"];
    
    
}
//指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    // 宽度
    return 200;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 40;
}




@end
