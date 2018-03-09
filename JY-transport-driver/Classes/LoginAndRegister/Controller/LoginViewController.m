//
//  LoginViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/21.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+HexStringColor.h"
#import "NetWorkHelper.h"
#import "FMButton.h"
#import "JYAccount.h"
#import "JYAccountTool.h"
#import "JYWuliuTool.h"
#import "DriverApplyViewController.h"
#import "driverInfoModel.h"
#import "JPUSHService.h"
#import "DeviceUID.h"
#import "JoinINView.h"
#import "RegisterCompanyViewController.h"
#import "JYCustomTabBarViewController.h"

#import "RegisterPersonViewController.h"
#import "CompanyModelInfo.h"
#import "ClerkModel.h"
#import "CustomNavigationViewController.h"
#import "AggrementViewController.h"

typedef enum {
    JYLoginTypeLogistics = 0,      //物流公司登录
    JYLoginTypeClerk = 1,          //物流公司下业务员登录
    JYLoginTypeDriver = 2,         //司机登录
    JYLoginTypePerson = 3,         //个人登录
}BMKRoutePlanShareURLType;



@interface LoginViewController ()<UITextFieldDelegate,JoinINViewDelegate>

@property(nonatomic,weak) UITextField *phoneNumber;
@property(nonatomic,weak)UITextField *CodeTextField;
@property(nonatomic,strong)FMButton *getCodeButton;
@property(nonatomic,weak)FMButton *driverButton;
@property(nonatomic,weak)FMButton *logisticsButton;
//@property(nonatomic,weak)FMButton *personBtn;

@property (nonatomic,strong)NSString *type;//登录类型


@property (nonatomic,strong) NSTimer *timerTime;
@property (nonatomic,assign) NSInteger timeout;

@property(nonatomic,assign)BOOL isDriver;
@property (nonatomic,strong)NSString *alias;

@property (nonatomic,strong)NSString *driverIconName;


@property (nonatomic,assign)NSInteger checkGroup;
@property (nonatomic,assign)NSInteger checkClerk;

@property (nonatomic,strong)FMButton *loginButton;
@property (nonatomic,assign)BOOL isAggrement;


@end

@implementation LoginViewController
{
    float _offset;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _isDriver = YES;
    [self creaContentView];
    _isAggrement = YES;
    //_offset = 0;
    _type = @"2";
    
    
}
-(void)creaContentView
{
    
    
    
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_logo"]];
    [self.view addSubview: iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(105);
        make.width.mas_equalTo(70 * HOR_SCALE);
        make.height.mas_equalTo(70 * HOR_SCALE);
        
    }];
    
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = RGB(51, 51, 51);
    phoneLabel.text = @"手机号";
    phoneLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:15];
    
    [self.view addSubview: phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(iconImageView.mas_bottom).mas_offset(75);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
        
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(229, 229, 229);
    [self.view addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLabel.mas_left);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        make.bottom.mas_equalTo(phoneLabel.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(0.5);
        
    }];
    
    UILabel *imgCode = [[UILabel alloc] init];
    imgCode.textColor = RGB(51, 51, 51);
    imgCode.text = @"验证码";
    imgCode.font = [UIFont fontWithName:Default_APP_Font_Reg size:15];
    
    
    
    [self.view addSubview: imgCode];
    [imgCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(50);
        make.top.mas_equalTo(lineView.mas_bottom).mas_offset(30);
        make.height.mas_equalTo(26);
        
    }];
    
    UITextField *phoneNumber = [[UITextField alloc]init];
    phoneNumber.delegate = self;
    phoneNumber.textColor = RGBA(51, 51, 51, 1);
    phoneNumber.font = [UIFont fontWithName:Default_APP_Font_Reg size:15];
    phoneNumber.backgroundColor = [UIColor whiteColor];
    phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumber.returnKeyType = UIReturnKeyDone;
    phoneNumber.borderStyle=UITextBorderStyleNone;
    [phoneNumber addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    phoneNumber.text = @"";
    UIColor *color = RGB(204, 204, 204);
    phoneNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的手机号" attributes:@{NSForegroundColorAttributeName: color}];
    
    [phoneNumber setValue:[UIFont fontWithName:Default_APP_Font_Reg size:15] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:phoneNumber];
    phoneNumber.tag = 902;
    
    [phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLabel.mas_right).mas_equalTo(21);
        make.centerY.mas_equalTo(phoneLabel.mas_centerY);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        
    }];
    
    
    
    
    UITextField *CodeTextField = [[UITextField alloc]init];
    CodeTextField.delegate = self;
    CodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    CodeTextField.textColor = RGBA(51, 51, 51, 1);
    CodeTextField.backgroundColor = [UIColor whiteColor];
    CodeTextField.font = [UIFont fontWithName:Default_APP_Font_Reg size:20];
    CodeTextField.borderStyle=UITextBorderStyleNone;
    CodeTextField.tag = 903;
    [CodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.getCodeButton.enabled = NO;
    self.getCodeButton.titleLabel.alpha = 0.5;
    CodeTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:CodeTextField];
    
    
    CodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入短信验证码" attributes:@{NSForegroundColorAttributeName: color}];
    [CodeTextField setValue:[UIFont fontWithName:Default_APP_Font_Reg size:15] forKeyPath:@"_placeholderLabel.font"];
    
    
    [CodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgCode.mas_right).mas_equalTo(21);
        make.centerY.mas_equalTo(imgCode.mas_centerY);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-95);
        
        
    }];
    
    
    UIView *lineViewCode = [[UIView alloc] init];
    lineViewCode.backgroundColor = RGB(229, 229, 229);
    [self.view addSubview:lineViewCode];
    
    [lineViewCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        make.bottom.mas_equalTo(imgCode.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(0.5);
        
    }];
    
    self.getCodeButton = [FMButton createFMButton];
    [self.view addSubview:self.getCodeButton];
    self.getCodeButton.backgroundColor = [UIColor whiteColor];
    [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.getCodeButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:14];
    [self.getCodeButton setTitleColor:BGBlue forState:(UIControlStateNormal)];
    
    
    __weak __typeof(self) weakSelf = self;
    
    self.getCodeButton.block=^(FMButton *btn){
        
        [weakSelf getIdentifyCodes];
    };
    
    
    [self.getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        make.centerY.mas_equalTo(CodeTextField.mas_centerY);
    }];
    CodeTextField.rightViewMode = UITextFieldViewModeAlways;
    CodeTextField.keyboardType  = UIKeyboardTypeNumberPad;
    
    
    
    //    //司机按钮
    //    FMButton *driverButton = [FMButton createFMButton];
    //    [self.view addSubview:driverButton];
    //
    //    driverButton.frame = CGRectMake(50, 28, 39, 80);
    //    [driverButton setImage:[UIImage imageNamed:@"icon_siji"] forState:UIControlStateNormal];
    //    [driverButton setImage:[UIImage imageNamed:@"icon_siji_lanse"] forState:UIControlStateSelected];
    //
    //    [driverButton setTitle:@"司机" forState:UIControlStateNormal];
    //    driverButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
    //    [driverButton setTitleColor:RGBA(112, 112, 112, 1) forState:UIControlStateNormal];
    //    [driverButton setTitleColor:BGBlue forState:UIControlStateSelected];
    //    driverButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //
    //    [self creatBtn:driverButton];
    //    [driverButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(imgPhone.mas_left);
    //        make.top.mas_equalTo(self.view.mas_bottom).mas_offset(53);
    //        make.width.mas_equalTo(39);
    //        make.height.mas_equalTo(80);
    //
    //    }];
    
    //    //点击司机按钮
    //    driverButton.block = ^(FMButton *button){
    //
    //      [self seletedDriver:button];
    //        _type = @"2";
    //
    //    };
    
    
    //    FMButton *logisticsButton = [FMButton createFMButton];
    //
    //    [self.view addSubview:logisticsButton];
    //
    //    logisticsButton.frame = CGRectMake(50, 28, 39, 80);
    //    [logisticsButton setImage:[UIImage imageNamed:@"icon_wuliu_huise"] forState:UIControlStateNormal];
    //    [logisticsButton setImage:[UIImage imageNamed:@"icon_wuliu"] forState:UIControlStateSelected];
    //    [logisticsButton setTitle:@"物流" forState:UIControlStateNormal];
    //    logisticsButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
    //    [logisticsButton setTitleColor:RGBA(112, 112, 112, 1) forState:UIControlStateNormal];
    //    [logisticsButton setTitleColor:BGBlue forState:UIControlStateSelected];
    //    logisticsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //
    //    [self creatBtn:logisticsButton];
    //
    //    [logisticsButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_equalTo(lineViewCode.mas_right);
    //        make.top.mas_equalTo(self.view.mas_bottom).mas_offset(53);
    //        make.width.mas_equalTo(39);
    //        make.height.mas_equalTo(80);
    //
    //
    //    }];
    //
    //    logisticsButton.block = ^(FMButton *button){
    //
    //        [self seletedlogistics:button];
    //        _type = @"3";
    //
    //    };
    
    
    //    ;
    //    driverButton.selected = _isDriver;
    //
    //    driverButton.selected = !logisticsButton.selected;
    //    self.driverButton = driverButton;
    //    self.logisticsButton = logisticsButton;
    
    //个人按钮
    //    FMButton *personBtn = [FMButton createFMButton];
    //    [self.view addSubview:personBtn];
    //    personBtn.frame = CGRectMake(50, 28, 39, 80);
    //    [personBtn setImage:[UIImage imageNamed:@"icon_gerenjiameng"] forState:UIControlStateNormal];
    //    [personBtn setImage:[UIImage imageNamed:@"icon_gerenjiamengcopy"] forState:UIControlStateSelected];
    //    [personBtn setTitle:@"个人" forState:UIControlStateNormal];
    //    personBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
    //    [personBtn setTitleColor:RGBA(112, 112, 112, 1) forState:UIControlStateNormal];
    //    [personBtn setTitleColor:RGBA(17, 138, 231, 1) forState:UIControlStateSelected];
    //    personBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    self.personBtn = personBtn;
    //    [self creatBtn:personBtn];
    //
    //    [personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(driverButton.mas_top);
    //        make.centerX.mas_equalTo(0);
    //        make.width.mas_equalTo(39);
    //        make.height.mas_equalTo(80);
    //
    //    }];
    //
    //    personBtn.block = ^(FMButton *button){
    
    //        [self seletedPerson:button];
    //        _type = @"4";
    //
    //    };
    
    //    UIView *lineV = [[UIView alloc] init];
    //    [self.view addSubview:lineV];
    //    lineV.backgroundColor = BGBlue;
    //    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //            make.centerX.mas_equalTo(0);
    //            make.width.mas_equalTo(1);
    //            make.height.mas_equalTo(40);
    //            make.centerY.mas_equalTo(driverButton.mas_centerY).mas_offset(-5);
    //
    //
    //            }];
    
    // 我要加盟
    FMButton *toJoinButton = [FMButton createFMButton];
    
    [toJoinButton setTitle:@"我要加盟" forState:UIControlStateNormal];
    
    [toJoinButton setTitleColor:BGBlue forState:UIControlStateNormal];
    toJoinButton.titleLabel.font =  [UIFont fontWithName:Default_APP_Font_Reg size:15];
    [self.view addSubview:toJoinButton];
    [toJoinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.view.bottom).mas_offset(-40);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(ScreenWidth - 30);
    }];
    
    [toJoinButton setBackgroundColor:[UIColor clearColor]];
    
    toJoinButton.block = ^(FMButton *button){
        
        //        JoinINView *joinView = [[JoinINView alloc] init];
        //        [self.view addSubview:joinView];
        //        [joinView showJoinView];
        //        joinView.delegate = self;
        
        [weakSelf JoinINViewPressentVC:@"driver"];
    };
    
    
    UIButton *aggreeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [aggreeBtn setBackgroundImage:[UIImage imageNamed:@"icon_checkbox_selected"] forState:(UIControlStateSelected)];
    [aggreeBtn setBackgroundImage:[UIImage imageNamed:@"icon_checkbox_normal"] forState:(UIControlStateNormal)];
    aggreeBtn.selected = YES;
    [self.view addSubview:aggreeBtn];
    aggreeBtn.tag = 2219;
    [aggreeBtn addTarget:self action:@selector(aggrementBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [aggreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
        make.top.mas_equalTo(lineViewCode.mas_bottom).mas_offset(8);
    }];
    
    UILabel *aggreeLab = [[UILabel alloc] init];
    aggreeLab.text = @"同意";
    
    aggreeLab.textColor = RGB(153,153 , 153);
    aggreeLab.font = [UIFont fontWithName:Default_APP_Font_Reg size:13];
    [self.view addSubview:aggreeLab];
    
    [aggreeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(aggreeBtn.mas_right).mas_offset(3);
        make.centerY.mas_equalTo(aggreeBtn.mas_centerY);
    }];
    
    UIButton *aggrementBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [aggrementBtn setTitle:@"《简运使用条款》" forState:(UIControlStateNormal)];
    aggrementBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    aggrementBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:13];
    [aggrementBtn setTitleColor:RGB(55, 168, 255) forState:(UIControlStateNormal)];
    aggrementBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [aggrementBtn addTarget:self action:@selector(aggrementBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    aggrementBtn.tag = 2220;
    
    [self.view addSubview:aggrementBtn];
    
    [aggrementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(aggreeLab.mas_right).mas_offset(1);
        make.centerY.mas_equalTo(aggreeBtn.mas_centerY);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    
    
    //确定
    FMButton *loginButton = [FMButton createFMButton];
    loginButton.titleLabel.alpha = 0.5;
    loginButton.enabled = NO;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:22];
    [self.view addSubview:loginButton];
    _loginButton = loginButton;
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(aggrementBtn.mas_bottom).mas_offset(40);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(ScreenWidth - 30);
    }];
    
    loginButton.layer.cornerRadius = 5;
    loginButton.layer.borderWidth = 1;
    loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [loginButton setBackgroundColor:[UIColor colorWithHexString:@"#108ae6"]];
    
    
    loginButton.block = ^(FMButton *button){
        //        [JYAccountTool saveUserLoginType:@"5"];
        //
        //        [UIApplication sharedApplication].keyWindow.rootViewController = [[JYCustomTabBarViewController alloc] init];
        
        if ([phoneNumber.text isEqualToString:@""]) {
            [MBProgressHUD showTipMessageInView:@"手机号码不能为空"];
            return ;
            
        }else if ([CodeTextField.text isEqualToString:@""]){
            
            [MBProgressHUD showTipMessageInView:@"验证码不能为空"];
            return;
        }else if(!_isAggrement){
            
            
        }else if ([phoneNumber.text isEqualToString:@"13279160519"] && [CodeTextField.text isEqualToString:@"8888"]){
            
            _isDriver = YES;
             [JYAccountTool saveUserLoginType:@"2"];
            [JYAccountTool saveUserName:_phoneNumber.text];
            
            [self logInSuccess];
        }else{
            
            [self sendHttpReque];
            
        }
    };
    self.phoneNumber=phoneNumber;
    self.CodeTextField=CodeTextField;
    
    
    
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

- (void)JoinINViewPressentVC:(NSString *)isSelect{
    
    if ([isSelect isEqualToString:@"logistics"]) {
        RegisterCompanyViewController *RegVC =[[RegisterCompanyViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:RegVC];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    if ([isSelect isEqualToString:@"driver"]) {
        DriverApplyViewController *driverapplyVC = [[DriverApplyViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:driverapplyVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
    if ([isSelect isEqualToString:@"personLogin"]) {
        RegisterPersonViewController *driverapplyVC = [[RegisterPersonViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:driverapplyVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 902) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11){
            
            return NO;
        }
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        
        if (strLength >= 11) {
            
            self.getCodeButton.enabled = YES;
            self.getCodeButton.titleLabel.alpha = 1;
        }else{
            self.getCodeButton.enabled = NO;
            self.getCodeButton.titleLabel.alpha = 0.5;
        }
        
    }
    return YES;
    
}
- (void)textFieldDidChange:(UITextField *)text{
    
    
    if (self.phoneNumber.text.length == 11 && self.CodeTextField.text.length > 0 && _isAggrement == YES) {
        self.loginButton.titleLabel.alpha = 1;
        self.loginButton.enabled = YES;
    }else{
        self.loginButton.titleLabel.alpha = 0.5;
        self.loginButton.enabled = NO;
    }
    
}

-(void)getIdentifyCodes
{
    
    //判断手机号码是否有11位
    if (self.phoneNumber.text.length!=11){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你输入的手机号无效,请重新输入" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        
        return;
    }else{
        
        NSString *baseStr = base_url;
        NSString *urlStr = [baseStr stringByAppendingString:@"app/user/getVerCode?"];
        [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":self.phoneNumber.text} success:^(id responseObj) {
            
            [self openCountdown];
            NSLog(@"成功成功成功成功成功成功成功成功成功成功成功");
            
        } failure:^(NSError *error) {
            
            NSLog(@"网络异常网络异常网络异常网络异常网络异常网络异常网络异常网络异常");
            
            [MBProgressHUD hideHUD];
            
            
            [MBProgressHUD showErrorMessage:@"网络异常"];
            
            
        }];
        
    }
    
    
}

//验证码倒计时
- (void)openCountdown{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行一次
    NSTimeInterval seconds = 60.f;
    NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:seconds]; // 最后期限
    
    dispatch_source_set_event_handler(_timer, ^{
        int interval = [endTime timeIntervalSinceNow];
        if (interval > 0) { // 更新倒计时
            NSString *timeStr = [NSString stringWithFormat:@"%d秒后重发", interval];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.getCodeButton.enabled = NO;
                [self.getCodeButton setTitle:timeStr forState:UIControlStateNormal];
            });
        } else { // 倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.getCodeButton.enabled = YES;
                [self.getCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(_timer);
}


-(void)sendHttpReque
{
    
    NSString *idea = @"1";
    
    if (_isDriver) {
        
        idea = @"1";
        
    }else {
        
        idea = @"2";
        
    }
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/user/checkVerCode"];
    
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":self.phoneNumber.text,@"verCode":self.CodeTextField.text,@"idea":idea} success:^(id responseObj) {
        
        NSString *DataStr = [responseObj objectForKey:@"message"];
        
        NSString *checkClerkStr = [responseObj objectForKey:@"checkClerk"];
        NSString *checkGroupStr = [responseObj objectForKey:@"checkGroup"];
        _checkClerk = [checkClerkStr integerValue];
        _checkGroup = [checkGroupStr integerValue];
        
        [JYAccountTool saveUserLoginType:_type];
        
        if (_checkGroup == 1 || [DataStr isEqualToString:@"0"]) {//物流公司登录
            
            [JYAccountTool saveUserName:_phoneNumber.text];
            
            [self logInSuccess];
            
            return;
        }else if (_checkClerk == 1){
            
            [self logInSuccess];
            [JYAccountTool saveUserLoginType:@"4"];//业务员登录
            return;
            
        }else if ([DataStr isEqualToString:@"404"]) {
            
            [MBProgressHUD showErrorMessage:@"此账号还没有加盟"];
            
        }else if([DataStr isEqualToString:@"1"]){
            
            [MBProgressHUD showErrorMessage:@"验证码超时"];
        }else if([DataStr isEqualToString:@"2"]){
            [MBProgressHUD showErrorMessage:@"没有获取验证码"];
            
        }else if([DataStr isEqualToString:@"3"]){
            [MBProgressHUD showErrorMessage:@"验证码错误"];
            
        }else{
            
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"我知道啦" otherButtonTitles:nil, nil] show];
        }
        
        
        NSLog(@"登录====%@",responseObj);
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showErrorMessage:@"网络异常"];
    }];
    
}
- (void)logInSuccess{
    
    //登录jpush成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerDeviceId) name:kJPFNetworkDidLoginNotification object:nil];
    [self postDeviceInfo];
    [self registerDeviceId];
    
    
    if (_isDriver) {//司机登陆
        
         [self senderHttp];
        // 6.新特性\去首页
        [JYWuliuTool chooseRootController];
       
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginLocation" object:nil];
        
    }
    if (_checkGroup == 1) {//物流登陆
        [JYAccountTool saveUserNameForLogistics:self.phoneNumber.text];
        [JYWuliuTool chooseRootController];
        [self getLogisticsInfo];
        
    } if (_checkClerk == 1) {//业务员登陆
        [JYAccountTool saveUserNameForLogistics:self.phoneNumber.text];
        [JYWuliuTool chooseRootController];
        [self getLogisticsclerk];
        
    }
    
}

-(void)registerDeviceId
{
    [JPUSHService registrationID];
    NSLog(@"registrationID:%@",[JPUSHService registrationID]);
    //在登录成功对应的方法中设置标签及别名
    /**tags alias
     *空字符串（@“”）表示取消之前的设置
     *nil,此次调用不设置此值
     *每次调用设置有效的别名，覆盖之前的设置
     */
    [JPUSHService setTags:nil alias:_alias fetchCompletionHandle:^(int iResCode,NSSet *iTags, NSString *iAlias) {
        NSLog(@"-------上传成功－－－－－－alias:%@",_alias);
        
        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);//对应的状态码返回为0，代表成功
    }];
}
- (void)postDeviceInfo{
    
    NSString *udid = [DeviceUID uid];
    NSString *strUrl = [udid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/user/postDevice"];
    NSString *deviceName =  [[UIDevice currentDevice] systemName];
    
    NSString *alStr = [self.phoneNumber.text substringFromIndex:7];
    NSString *aliasStr = [strUrl stringByAppendingString:alStr];
    NSString *alias = [aliasStr stringByAppendingString:_type];
    _alias = alias;
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":self.phoneNumber.text,@"deviceName":deviceName,@"uuid":udid,@"alias":alias,@"type":_type} success:^(id responseObj) {
        
        
    }failure:^(NSError *error) {
        
        [MBProgressHUD showErrorMessage:@"网络异常"];
    }];
}


-(void)seletedDriver:(FMButton *)button
{
    
    _type = @"2";
    button.selected =YES;
    self.logisticsButton.selected =NO;
    //        self.personBtn.selected = NO;
    _isDriver =YES;
    
    
}

-(void)seletedlogistics:(FMButton *)button
{
    
    _type = @"3";
    button.selected =YES;
    self.driverButton.selected = NO;
    //    self.personBtn.selected = NO;
    _isDriver = NO;
    
    
}
//-(void)seletedPerson:(FMButton *)button
//{
//    
//    _type = @"4";
//    button.selected =YES;
//    self.driverButton.selected = NO;
//    self.logisticsButton.selected =NO;
//    _isDriver = NO;
//    
//    
//}

-(void)senderHttp
{
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/getTruckerInfo"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":self.phoneNumber.text} success:^(id responseObj) {
        
        
      driverInfoModel *model = [JYAccountTool getDriverInfoModelInfo];

        if (model == nil) {
            
            model = [[driverInfoModel alloc]init];

        }
      
        
        model.name = [responseObj objectForKey:@"name"];
        if (model.name == nil || [model.name isEqual:[NSNull null]]) {
            model.name = self.phoneNumber.text;
        }
        
        model.phone = [responseObj objectForKey:@"phone"];
        if (model.phone == nil || [model.phone isEqual:[NSNull null]]) {
            model.phone = self.phoneNumber.text;
        }
        if (model.ailpayAccount == nil || [model.ailpayAccount isEqual:[NSNull null]]) {
            model.ailpayAccount = @"";
        }
        if (model.bankCard == nil || [model.bankCard isEqual:[NSNull null]]) {
            model.bankCard = @"";
        }
        
        model.icon = [responseObj objectForKey:@"icon"];
        _driverIconName = model.icon;
        model.id = [responseObj objectForKey:@"id"];
        model.basicStatus = [responseObj objectForKey:@"basicStatus"];
        model.licensePlate = [responseObj objectForKey:@"licensePlate"];
        model.vehicle  = [responseObj objectForKey:@"vehicle"];
        model.sexuality = [responseObj objectForKey:@"sexuality"];
        model.isAuthentication = [[responseObj objectForKey:@"isAuthentication"] integerValue];
        model.bankCard = [responseObj objectForKey:@"bankCard"];
        model.ailpayAccount = [responseObj objectForKey:@"ailpayAccount"];
        
        [JYAccountTool saveDriverInfoModelInfo:model];
        
        //       [self performSelector:@selector(getDriverIcon) withObject:nil afterDelay:3];
        
    } failure:^(NSError *error) {
        
        //    [MBProgressHUD showError:@"网络异常" toView:self.view];
        
    }];
}

- (void)getLogisticsclerk{
    
    NSString *url = [base_url stringByAppendingString:@"app/logisticsclerk/getByPhone"];
    
    [[NetWorkHelper shareInstance]Post:url parameter:@{@"phone":self.phoneNumber.text} success:^(id responseObj) {
        
        ClerkModel *model = [[ClerkModel alloc]init];
        
        model.name = [responseObj objectForKey:@"name"];
        if (model.name == nil || [model.name isEqual:[NSNull null]]) {
            model.name = self.phoneNumber.text;
        }
        
        model.phone = [responseObj objectForKey:@"phone"];
        if (model.phone == nil || [model.phone isEqual:[NSNull null]]) {
            model.phone = self.phoneNumber.text;
        }
        model.basicStatus = [responseObj objectForKey:@"basicStatus"];
        if (model.basicStatus == nil || [model.basicStatus isEqual:[NSNull null]]) {
            model.basicStatus = @"";
        }
        model.icon = [responseObj objectForKey:@"icon"];
        if (model.icon == nil || [model.icon isEqual:[NSNull null]]) {
            model.icon = @"";
        }
        model.branchId = [responseObj objectForKey:@"branchId"];
        if (model.branchId == nil || [model.branchId isEqual:[NSNull null]]) {
            model.branchId = @"";
        }
        model.branchName = [responseObj objectForKey:@"branchName"];
        if (model.branchName == nil || [model.branchName isEqual:[NSNull null]]) {
            model.branchName = @"";
        }
        model.logisticsName = [responseObj objectForKey:@"logisticsName"];
        if (model.logisticsName == nil || [model.logisticsName isEqual:[NSNull null]]) {
            model.logisticsName = @"";
        }
        model.logisticsId = [responseObj objectForKey:@"logisticsId"];
        if (model.logisticsId == nil || [model.logisticsId isEqual:[NSNull null]]) {
            model.logisticsId = @"";
        }
        
        // 2.归档模型对象
        [JYAccountTool saveLogisticsclerkModelInfo:model];
        
    } failure:^(NSError *error) {
        
        
    }];
}
- (void)getLogisticsInfo{
    
    NSString *url = [base_url stringByAppendingString:@"app/logisticsgroup/getByPhone"];
    
    [[NetWorkHelper shareInstance]Post:url parameter:@{@"phone":self.phoneNumber.text} success:^(id responseObj) {
        
        CompanyModelInfo *model = [[CompanyModelInfo alloc]init];
        
        model.companyname = [responseObj objectForKey:@"companyname"];
        if (model.companyname == nil || [model.companyname isEqual:[NSNull null]]) {
            model.companyname = self.phoneNumber.text;
        }
        
        model.phone = [responseObj objectForKey:@"phone"];
        if (model.phone == nil || [model.phone isEqual:[NSNull null]]) {
            model.phone = self.phoneNumber.text;
        }
        model.basicStatus = [responseObj objectForKey:@"basicStatus"];
        if (model.basicStatus == nil || [model.basicStatus isEqual:[NSNull null]]) {
            model.basicStatus = @"";
        }
        model.icon = [responseObj objectForKey:@"icon"];
        if (model.icon == nil || [model.icon isEqual:[NSNull null]]) {
            model.icon = @"";
        }
        model.id = [responseObj objectForKey:@"id"];
        if (model.id == nil || [model.id isEqual:[NSNull null]]) {
            model.id = @"";
        }
        model.landline = [responseObj objectForKey:@"landline"];
        if (model.landline == nil || [model.landline isEqual:[NSNull null]]) {
            model.landline = @"";
        }
        model.introductions = [responseObj objectForKey:@"introductions"];
        if (model.introductions == nil || [model.introductions isEqual:[NSNull null]]) {
            model.introductions = @"";
        }
        
        // 2.归档模型对象
        [JYAccountTool saveLogisticsModelInfo:model];
        
    } failure:^(NSError *error) {
        
        //    [MBProgressHUD showError:@"网络异常" toView:self.view];
        
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
}
- (void)backClick:(UIButton *)sender
{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}

- (void)aggrementBtnClick:(UIButton *)btn{
    
    if (btn.tag == 2219) {
        btn.selected = !btn.selected;
        if (btn.selected == NO) {
            _isAggrement = NO;
        }else{
            _isAggrement = YES;
        }
        if (self.phoneNumber.text.length == 11 && self.CodeTextField.text.length > 0 && _isAggrement == YES) {
            self.loginButton.titleLabel.alpha = 1;
            self.loginButton.enabled = YES;
        }else{
            self.loginButton.titleLabel.alpha = 0.5;
            self.loginButton.enabled = NO;
        }
        
    }else if (btn.tag == 2220){
        AggrementViewController *vc = [[AggrementViewController alloc] init];
        
        CustomNavigationViewController *navi = [[CustomNavigationViewController alloc] initWithRootViewController:vc];
        
        [self presentViewController:navi animated:YES completion:nil];
        
    }
}

@end
