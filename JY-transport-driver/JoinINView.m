


//
//  JoinINView.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/14.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JoinINView.h"

@interface JoinINView ()

@property (nonatomic,strong)UIButton *maskBtn;
@property (nonatomic,strong)NSString *isSelectStr;

@end
@implementation JoinINView


- (void)showJoinView{
    
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    UIButton *maskBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _maskBtn = maskBtn;
    _maskBtn.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _maskBtn.backgroundColor = RGBA(0, 0, 0, 0.5);
    [_maskBtn addTarget:self action:@selector(maskClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_maskBtn];
    
    UIView *superV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - (53 * 2), 180)];
    superV.userInteractionEnabled = YES;
    superV.layer.cornerRadius = 12;
    superV.layer.masksToBounds = YES;
    superV.backgroundColor = RGBA(252, 252, 252, 1);
    superV.center = _maskBtn.center;
    [_maskBtn addSubview:superV];

    
    FMButton *driverButton = [FMButton createFMButton];
    [superV addSubview:driverButton];
    
    driverButton.frame = CGRectMake(50, 28, 39, 80);
    [driverButton setImage:[UIImage imageNamed:@"icon_siji"] forState:UIControlStateNormal];
    [driverButton setImage:[UIImage imageNamed:@"icon_siji_lanse"] forState:UIControlStateSelected];

    [driverButton setTitle:@"司机" forState:UIControlStateNormal];
    driverButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
    [driverButton setTitleColor:RGBA(112, 112, 112, 1) forState:UIControlStateNormal];
    [driverButton setTitleColor:BGBlue forState:UIControlStateSelected];
    driverButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self creatBtn:driverButton];
    [driverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(47);
        make.top.mas_equalTo(superV.mas_top).mas_offset(28);
        make.width.mas_equalTo(39);
        make.height.mas_equalTo(80);
        
    }];
    //点击司机按钮
  
    
    //点击物流按钮
    FMButton *logisticsButton = [FMButton createFMButton];
   
    [superV addSubview:logisticsButton];
    
    logisticsButton.frame = CGRectMake(50, 28, 39, 80);
    [logisticsButton setImage:[UIImage imageNamed:@"icon_wuliu_huise"] forState:UIControlStateNormal];
     [logisticsButton setImage:[UIImage imageNamed:@"icon_wuliu"] forState:UIControlStateSelected];
    [logisticsButton setTitle:@"物流" forState:UIControlStateNormal];
    logisticsButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
    [logisticsButton setTitleColor:RGBA(112, 112, 112, 1) forState:UIControlStateNormal];
    [logisticsButton setTitleColor:BGBlue forState:UIControlStateSelected];
    logisticsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self creatBtn:logisticsButton];
    
    [logisticsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-47);
        make.top.mas_equalTo(superV.mas_top).mas_offset(28);
        //make.width.mas_equalTo(50);
        make.width.mas_equalTo(39);
        make.height.mas_equalTo(80);

        
    }];
    
    //个人按钮
    FMButton *personBtn = [FMButton createFMButton];
    [superV addSubview:personBtn];
    personBtn.frame = CGRectMake(50, 28, 39, 80);
    [personBtn setImage:[UIImage imageNamed:@"icon_gerenjiameng"] forState:UIControlStateNormal];
    [personBtn setImage:[UIImage imageNamed:@"icon_gerenjiamengcopy"] forState:UIControlStateSelected];
    [personBtn setTitle:@"同城" forState:UIControlStateNormal];
    personBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
    [personBtn setTitleColor:RGBA(112, 112, 112, 1) forState:UIControlStateNormal];
    [personBtn setTitleColor:BGBlue forState:UIControlStateSelected];
    personBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self creatBtn:personBtn];
    
    __weak typeof(driverButton) weakBtnDr = driverButton;
    __weak typeof(logisticsButton) weakBtnLog = logisticsButton;
    __weak typeof(personBtn) weakBtnPerson = personBtn;

    
    [personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(driverButton.mas_top);
        make.centerX.mas_equalTo(superV.mas_centerX);
        make.width.mas_equalTo(39);
        make.height.mas_equalTo(80);
        
    }];
    //个人按钮点击
    personBtn.block = ^(FMButton *button){
        
        _isSelectStr = @"personLogin";
        weakBtnLog.selected = NO;
        weakBtnDr.selected = NO;
        weakBtnPerson.selected = YES;
        
    };

    //司机按钮点击
    driverButton.block = ^(FMButton *button){
        
        _isSelectStr = @"driver";
        weakBtnLog.selected = NO;
        weakBtnPerson.selected = NO;
        weakBtnDr.selected = YES;
        
    };
    //物流按钮点击
       logisticsButton.block = ^(FMButton *button){

        _isSelectStr = @"logistics";
        weakBtnLog.selected = YES;
        weakBtnPerson.selected = NO;

        weakBtnDr.selected = NO;
        
    };

    
    
   
    
    UIView *lineTwo = [[UIView alloc] init];
    lineTwo.backgroundColor = RGBA(231, 231, 231, 1);
    [superV addSubview:lineTwo];
    
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:BGBlue forState:(UIControlStateNormal)];
    [sureBtn setBackgroundColor:RGBA(252, 252, 252, 1)];

    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [superV addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(superV.mas_bottom);
        make.height.mas_equalTo(43.5);
        
    }];
    
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(sureBtn.mas_top).mas_equalTo(-0.5);
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];

    
}
- (void)creatBtn:(UIButton *)driverButton{
    
    
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    CGFloat heightSpace = 5.0f;
    
    //设置按钮内边距
    imgViewSize = driverButton.imageView.bounds.size;
    titleSize = driverButton.titleLabel.bounds.size;
    btnSize = driverButton.bounds.size;
    
    
    imageViewEdge = UIEdgeInsetsMake(heightSpace,0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
    [driverButton setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(imgViewSize.height +heightSpace, - imgViewSize.width, 0.0, 0.0);
    [driverButton setTitleEdgeInsets:titleEdge];

}
- (void)maskClick:(UIButton *)btn{
    
    [self removeFromSuperview];
    
}

- (void)sureBtnClick:(UIButton *)btn{
    
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(JoinINViewPressentVC:)]) {
            [self.delegate JoinINViewPressentVC:_isSelectStr];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
