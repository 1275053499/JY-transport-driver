//
//  commitSuccessViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/12/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "commitSuccessViewController.h"

@interface commitSuccessViewController ()

@end

@implementation commitSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    [self creatSubViews];
}

- (void)creatSubViews{
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_portrait"]];
    imgView.frame = CGRectMake((ScreenWidth -80)/2, 45, 80, 80);
    
    [self.view addSubview:imgView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 90 )/2, 150, 90, 20)];
    lab.text = @"申请已提交";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont fontWithName:Default_APP_Font_Reg size:18];
    lab.textColor = RGB(51, 51, 51);
    [self.view addSubview:lab];
    
    UILabel *linkLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 190 )/2, 180, 190, 20)];
    lab.text = @"工作人员将在1-3个工作日联系您";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont fontWithName:Default_APP_Font_Reg size:13];
    lab.textColor = RGB(153, 153, 153);
    [self.view addSubview:linkLabel];
    
    
    
    
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
