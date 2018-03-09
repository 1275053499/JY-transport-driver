//
//  BuyCarView.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/12/14.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "BuyCarView.h"


#define kimageEdge  12
#define kimageHeight  35

@interface  BuyCarView()


@property (nonatomic,strong)UIView *imgBackView;

@property (nonatomic,strong)UIImageView *bgImageView;

//@property (nonatomic,strong)UIView *bubbleView;
@property (nonatomic,assign)CGFloat bubbleViewHeight;

//@property (nonatomic,strong)UIView *lineViewFirst;
//@property (nonatomic,strong)UIView *lineViewSecond;

@property (nonatomic,strong)UILabel *infoLabel;
@property (nonatomic,strong)UIButton *finishBtn;

@end
@implementation BuyCarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        

       
        [self commonInit];
    }
    return self;
}

- (void)creatCarNameAndMoney{
    _carLabel = [[UILabel alloc] init];
    _carLabel.textAlignment = NSTextAlignmentCenter;
    _carLabel.text = @"";
    [_bgImageView addSubview:_carLabel];

    
    [_carLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgImageView.top).mas_offset(40 * HOR_SCALE);
        make.centerX.mas_equalTo(_bgImageView.centerX);
        make.height.mas_equalTo(20);
    }];
    
  
    _currentImageView = [[UIImageView alloc] init];
    [_bgImageView addSubview:_currentImageView];
    
    [_currentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_carLabel.mas_bottom).mas_offset(90 * HOR_SCALE);
        make.centerX.mas_equalTo(_bgImageView.centerX);
        make.width.mas_equalTo(275 * HOR_SCALE);
        make.height.mas_equalTo(180 * HOR_SCALE);
    }];
}
- (void)commonInit{
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.userInteractionEnabled = YES;
    _bgImageView.image = [UIImage imageNamed:@"driver_modelcar_bg"];
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        
    }];
    
    [self creatCarNameAndMoney];

//    [self creatBubbleView];
    [self creatLinView];
    [self creatFinishBtn];

}
- (void)creatLinView{

    _infoLabel = [[UILabel alloc] init];
    _infoLabel.attributedText= [self setTextString: @"免息买车活动开始啦!首付只需总金额50%即可立即提车，三年内无利息还款，你还不快来？"];
    _infoLabel.textColor = RGB(51, 51, 51);
    _infoLabel.numberOfLines = 0;
    _infoLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:14];
    [self addSubview:_infoLabel];
    
//    [_bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_bgImageView.mas_left).mas_offset(15);
//        make.top.mas_equalTo(_currentImageView.mas_bottom).mas_offset(0);
//        make.width.mas_equalTo(ScreenWidth - 30);
//        make.height.mas_equalTo(_bubbleViewHeight);
//
//    }];

    
}
- (void)creatFinishBtn{
    
    UIButton *finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [finishBtn setTitle:@"我要买" forState:(UIControlStateNormal)];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    finishBtn.backgroundColor = BGBlue;
    finishBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:18];
    [self addSubview:finishBtn];
    finishBtn.layer.cornerRadius = 22;
    finishBtn.layer.masksToBounds = YES;
    [finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    _finishBtn = finishBtn;
    
    [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_bgImageView.mas_left).mas_offset(30 );
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset( - 30 *HOR_SCALE);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(ScreenWidth - 60);
        
    }];
    
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_bgImageView.mas_left).mas_offset(30);
        make.bottom.mas_equalTo(_finishBtn.mas_top).mas_offset(-12 * HOR_SCALE);
        make.width.mas_equalTo(ScreenWidth - 60);
        
    }];
}
- (void)finishBtnClick:(UIButton *)btn{
    
    if (_BuyCarBlock) {
        
        _BuyCarBlock(_carLabel.text);
    }
        
}
-(NSAttributedString *)setTextString:(NSString *)text
{  NSMutableAttributedString *mAbStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *npgStyle = [[NSMutableParagraphStyle alloc] init];
    npgStyle.alignment = NSTextAlignmentJustified;
    npgStyle.paragraphSpacing = 11.0;
    npgStyle.paragraphSpacingBefore = 10.0;
    npgStyle.firstLineHeadIndent = 0.0;
    npgStyle.headIndent = 0.0;
    npgStyle.lineSpacing = 4;
    

    NSDictionary *dic = @{
                          NSForegroundColorAttributeName:[UIColor blackColor],
                          NSFontAttributeName      :[UIFont fontWithName:Default_APP_Font_Reg size:15],
                          NSParagraphStyleAttributeName :npgStyle,
                          NSUnderlineStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleNone]
                          };
    [mAbStr setAttributes:dic range:NSMakeRange(0, mAbStr.length)];
    NSAttributedString *attrString = [mAbStr copy];
    return attrString;
}
- (void)creatBubbleView{
//    _bubbleView = [[UIView alloc] initWithFrame:CGRectMake(15, 300, ScreenWidth - 30, 50)];
//    [_bgImageView addSubview:_bubbleView];
//    NSArray *arr = @[@"免息买车",@"首付一半",@"三年期限",@"获取积分",@"积分奖品兑换",@"获取积分",@"接单还贷"];
//
//    int line = 1;
//    CGFloat ViewX = 0;
//    for (int i = 0; i < arr.count; i++) {
//
//        UIFont *font = [UIFont fontWithName:Default_APP_Font size:12];
//        CGFloat kStrWidth = [self measureSinglelineStringWidth:arr[i] andFont:font];
//
//        ViewX = (ViewX + kimageEdge);
//
//        if ((ViewX  + kStrWidth + kimageEdge) >= ScreenWidth -30) {
//            line ++;
//            ViewX = kimageEdge;
//        }
//        CGFloat ViewY =  line  * kimageEdge + (line -1) * kimageHeight;
//        _bubbleViewHeight = (line +1 ) * kimageEdge + line *kimageHeight;
//
//        NSLog(@"%f",_bubbleViewHeight);
//        FMButton *button = [FMButton createFMButton];
//        button.titleLabel.font = font;
//        button.backgroundColor = RGB(242,242,242);
//        button.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:13];
//        [button setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
//        [button setTitle:arr[i] forState:UIControlStateNormal];
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;
//        button.layer.cornerRadius = 3;
//        button.frame = CGRectMake(ViewX, ViewY, kStrWidth, kimageHeight);
//        ViewX = kStrWidth + ViewX;
//        NSLog(@"%@",button);
//
//        [self.bubbleView addSubview:button];
//    }
    
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

@end
