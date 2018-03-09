//
//  DriverApplyDemo.m
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/9.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "DriverApplyDemo.h"

@interface DriverApplyDemo ()
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UILabel *titleLabel;

@end
@implementation DriverApplyDemo
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
        [self updateFrame];
    }
    return self;
}
- (void)commonInit{
    
    UIButton *bottomBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    bottomBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:bottomBtn];
    _bottomBtn = bottomBtn;
    
    _bottomView = [[UIView alloc] init];
    _bottomView.layer.cornerRadius = 5;
    _bottomView.layer.masksToBounds = YES;
    _bottomView.backgroundColor = RGB(255, 255, 255);
    [_bottomBtn addSubview:_bottomView];
    
    
    _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_add"]];
    _imgView.userInteractionEnabled = NO;
    [_imgView setContentMode: UIViewContentModeScaleAspectFit];
    //    _finishBtn.clipsToBounds = YES;
    [_bottomView addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"示例";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:15];
    _titleLabel.textColor = RGB(51, 51, 51);
    [_bottomView addSubview:_titleLabel];
    

    _finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _finishBtn.backgroundColor = BGBlue;
    [_finishBtn setTitle:@"上传图片" forState:(UIControlStateNormal)];
    _finishBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:18];
    [_finishBtn setTitleColor:RGB(255, 255, 255) forState:(UIControlStateNormal)];
//    _finishBtn.layer.cornerRadius = 22;
//    _finishBtn.layer.masksToBounds = YES;
    [_bottomView addSubview:_finishBtn];


    
}
- (void)updateFrame{
    
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(310 * HOR_SCALE);
        make.centerX.mas_equalTo(_bottomBtn.centerX);
        make.centerY.mas_equalTo(_bottomBtn.centerY).mas_offset(0);
        make.height.mas_equalTo(300 * HOR_SCALE);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_bottomView.mas_left).offset(15);
        make.top.equalTo(_bottomView.mas_top).offset(8 * HOR_SCALE);
        make.height.mas_equalTo(18);
    }];
    
   
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_titleLabel.mas_bottom).offset(10 * HOR_SCALE);
        make.centerX.equalTo(_bottomView.mas_centerX);
        make.width.mas_equalTo(_bottomView.mas_width);
        make.height.mas_equalTo(188 * HOR_SCALE);

    }];

    
   
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imgView.mas_bottom).mas_equalTo(10 * HOR_SCALE);
        make.height.mas_equalTo(50);
        make.left.equalTo(_bottomView.mas_left).offset(15);
        make.right.equalTo(_bottomView.mas_right).offset(-15);
    }];
}

- (void)showImgView:(NSString *)imgName{

    UIWindow *wind = [UIApplication sharedApplication].keyWindow;
    _imgView.image = [UIImage imageNamed:imgName];
    [wind addSubview: self];
    
}
- (void)updatHeight:(int)bottomheight imgHeight:(int)imgHeight{
    
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(bottomheight);
        
    }];
    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(imgHeight);
    }];
    
   
    [self layoutIfNeeded];
}
- (void)bottomBtnClick:(UIButton *)btn{
    
    [self disMissView];
    
}

- (void)disMissView{
    
    
    [self removeFromSuperview];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
