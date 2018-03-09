//
//  ZZMaskView.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ZZMaskView.h"

@interface ZZMaskView ()

@property (nonatomic, strong) CALayer *lineLayer;

@end

@implementation ZZMaskView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
    
}

-(void)setupUI{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    self.lineLayer = [CALayer layer];
    self.lineLayer.contents = (id)[UIImage imageNamed:@"scanningLine"].CGImage;
    [self.layer addSublayer:self.lineLayer];
    [self repetitionAnimation];
    
    CGFloat bottom = -25;
    
    UIButton *lightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    lightBtn.backgroundColor = [UIColor clearColor];
    [lightBtn setImage:[UIImage imageNamed:@"icon_nochaxun"] forState:UIControlStateNormal];
    [lightBtn setImage:[UIImage imageNamed:@"icon_chaxun"] forState:UIControlStateSelected];

    [lightBtn setTitle:@"手动输入" forState:(UIControlStateNormal)];
    lightBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:14];
    [lightBtn setTitleColor:BGBlue forState:(UIControlStateSelected)];
    [lightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

    [self addSubview:lightBtn];
    
    UIButton *imgBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    imgBtn.backgroundColor = [UIColor clearColor];

    [imgBtn setTitle:@"查询" forState:(UIControlStateNormal)];
    imgBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:14];
    [imgBtn setTitleColor:BGBlue forState:(UIControlStateSelected)];

    [imgBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

    [imgBtn setImage:[UIImage imageNamed:@"icon_noshoudongsuru"] forState:UIControlStateNormal];
    [imgBtn setImage:[UIImage imageNamed:@"icon_shoudongsuru"] forState:UIControlStateSelected];

    [self addSubview:imgBtn];
    
    
    UIButton *createBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];

    createBtn.backgroundColor = [UIColor clearColor];
    [createBtn setTitle:@"操作" forState:(UIControlStateNormal)];
    createBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:14];
    [createBtn setTitleColor:BGBlue forState:(UIControlStateSelected)];
    [createBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

    [createBtn setImage:[UIImage imageNamed:@"icon_nocaozuo"] forState:UIControlStateNormal];
    [createBtn setImage:[UIImage imageNamed:@"icon_caozuo"] forState:UIControlStateSelected];

    [self addSubview:createBtn];
    
    [imgBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.offset(44);
        make.bottom.offset(bottom);
        make.height.width.offset(80);
        

    }];
    
    [lightBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.bottom.offset(bottom);
        make.height.width.offset(80);
    }];
    
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.offset(-44);
        make.bottom.offset(bottom);
        make.height.width.offset(80);
    }];
    
    [self creatBtn:lightBtn];
    [self creatBtn:imgBtn];
    [self creatBtn:createBtn];
    

    self.imgBtn = imgBtn;
    self.createBtn = createBtn;
    self.lightBtn = lightBtn;

    
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat pickingFieldWidth = 304;
    CGFloat pickingFieldHeight = 304;
    CGRect pickingFieldRect = CGRectMake((width - pickingFieldWidth) / 2 , (height - pickingFieldHeight) / 2, pickingFieldWidth, pickingFieldHeight);
    
    UIImageView *centerView = [[UIImageView alloc]initWithFrame:pickingFieldRect];
    //扫描框图片的拉伸，拉伸中间一块区域
    UIImage *scanImage = [UIImage imageNamed:@"icon_QR"];
    CGFloat top = 264 *0.5-1; // 顶端盖高度
    CGFloat bottom2 = top ; // 底端盖高度
    CGFloat left = 264*0.5-1; // 左端盖宽度
    CGFloat right = left; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom2, right);
    scanImage = [scanImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    centerView.image = scanImage;
    centerView.contentMode = UIViewContentModeScaleAspectFit;
    centerView.backgroundColor = [UIColor clearColor];
    [self addSubview:centerView];
    
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

- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat pickingFieldWidth = 300;
    CGFloat pickingFieldHeight = 300;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.35);
    CGContextSetLineWidth(contextRef, 3);
    
    CGRect pickingFieldRect = CGRectMake((width - pickingFieldWidth) / 2 , (height - pickingFieldHeight) / 2, pickingFieldWidth, pickingFieldHeight);
    
    UIBezierPath *pickingFieldPath = [UIBezierPath bezierPathWithRect:pickingFieldRect];
    UIBezierPath *bezierPathRect = [UIBezierPath bezierPathWithRect:rect];
    [bezierPathRect appendPath:pickingFieldPath];
    //填充使用奇偶法则
    bezierPathRect.usesEvenOddFillRule = YES;
    [bezierPathRect fill];
    CGContextSetLineWidth(contextRef, 2);
//    CGContextSetRGBStrokeColor(contextRef, 27/255.0, 181/255.0, 254/255.0, 1);
    CGContextSetRGBStrokeColor(contextRef, 255/255.0, 255/255.0, 255/255.0, 1);

    [pickingFieldPath stroke];
    
    CGContextRestoreGState(contextRef);
    self.layer.contentsGravity = kCAGravityCenter;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
    
    self.lineLayer.frame = CGRectMake((self.frame.size.width - 300) / 2, (self.frame.size.height - 300) / 2, 300, 2);
}

- (void)stopAnimation
{
    [self.lineLayer removeAnimationForKey:@"translationY"];
}

- (void)repetitionAnimation
{
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    basic.fromValue = @(0);
    basic.toValue = @(300);
    basic.duration = 2.2;
    
    basic.repeatCount = NSIntegerMax;
    basic.removedOnCompletion = NO;
    
    [self.lineLayer addAnimation:basic forKey:@"translationY"];
}




@end
