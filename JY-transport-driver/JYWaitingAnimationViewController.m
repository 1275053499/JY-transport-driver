//
//  JYWaitingAnimationViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/5.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYWaitingAnimationViewController.h"
#import "JYOrderDetailViewController.h"
@interface JYWaitingAnimationViewController ()

@property (nonatomic,strong)UIImageView *imgView;//动画view

@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIView *superView;//底视图

@end

@implementation JYWaitingAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    
    [self creatSuperView];
    [self startAnimation];
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(back)];
    self.navigationItem.title = @"等待确认";
    
    //用户确认订单 通知 停止动画
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmationProvider:) name:@"confirmationProvider" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    

}
- (void)willChangeStatusBarFrameNotification:(NSNotification *)nottfication{
   
    _superView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight -StateBarHeight -50);
    _cancelBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight -StateBarHeight ,ScreenWidth,50);

}
- (void)stopAnimation
{
    [self.imgView.layer removeAllAnimations];
}


- (void)confirmationProvider:(NSNotification *)noti{
    
    [self stopAnimation];
    [self conFirmOrder];

    
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)startAnimation
{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: 0.f];
    
    rotationAnimation.duration = 2.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.removedOnCompletion = NO;
    
    rotationAnimation.repeatCount = HUGE_VALF;
    // rotationAnimation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    
    [self.imgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)creatSuperView{
    
    _superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight -StateBarHeight -50)];
    _superView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_superView];
    
    UIImageView *imgview = [[UIImageView alloc] init];
    imgview.frame = CGRectMake((ScreenWidth -110)/2 ,150,110 ,104 );
    imgview.image = [UIImage imageNamed:@"animation"];
    [_superView addSubview:imgview];
    _imgView = imgview;
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = BGBlue;
    lab.frame = CGRectMake((ScreenWidth - 200)/2, 280, 300, 25);
    lab.text = @"稍等一会儿，客户正在确认";
    lab.font =  [UIFont fontWithName:Default_APP_Font_Reg size:18];
    [_superView addSubview:lab];
    
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight -StateBarHeight ,ScreenWidth,50);
    [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [_cancelBtn setBackgroundColor:BGBlue];
    
    _cancelBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:22];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    
    
    
    
    
}
- (void)conFirmOrder{
    
//    self.navigationItem.title = @"订单详情";
    [self stopAnimation];
    JYOrderDetailViewController *vc = [[JYOrderDetailViewController alloc] init];
//    vc.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 50);
//    [self addChildViewController:vc];
//    [_superView addSubview:vc.view];
//    _superView.backgroundColor = BgColorOfUIView;
//    _cancelBtn.hidden = YES;
    vc.orderID = self.orderID;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)cancelBtnClick:(UIButton *)btn{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
