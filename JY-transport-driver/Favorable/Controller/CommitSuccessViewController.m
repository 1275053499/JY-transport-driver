//
//  commitSuccessViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/12/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "CommitSuccessViewController.h"

@interface CommitSuccessViewController ()

@end

@implementation CommitSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"提交成功";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    
    [self creatSubViews];

}

- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatSubViews{
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_threadsuccess"]];
    imgView.frame = CGRectMake((ScreenWidth -80)/2, 45, 80, 80);
    
    [self.view addSubview:imgView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 200 )/2, 150, 200, 25)];
    lab.text = @"申请已提交";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont fontWithName:Default_APP_Font_Reg size:18];
    lab.textColor = RGB(51, 51, 51);
    [self.view addSubview:lab];
    
    UILabel *linkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, ScreenWidth, 20)];
    linkLabel.text = @"工作人员将在1-3个工作日联系您";
    linkLabel.textAlignment = NSTextAlignmentCenter;
    linkLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:13];
    linkLabel.textColor = RGB(153, 153, 153);
    [self.view addSubview:linkLabel];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(15, 250, ScreenWidth -30, 50);
    [btn setTitle:@"完成" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(finishClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btn.backgroundColor = BGBlue;
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:18];
    
    [self.view addSubview:btn];
    
    if (_pushType == PushVCFromJYWalletRechargeVC) {
        linkLabel.text = @"认证成功";

    }else if(_pushType == PushVCFromWithdrawVC){
        linkLabel.text = @"1-3个工作日会到您的账户";

    }else if(_pushType == PushVCFromBuyCarWriteInfoVC){
        linkLabel.text = @"工作人员将在1-3个工作日联系您";

    }else if(_pushType == PushVCFromRefundDepositView){
        
        linkLabel.text = @"1-3个工作日会到您的账户";
        
    }
    
}
- (void)finishClick:(UIButton *)btn{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
