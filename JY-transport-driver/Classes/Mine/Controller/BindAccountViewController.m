//
//  BindAccountViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/10/24.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "BindAccountViewController.h"
#import "driverInfoModel.h"
@interface BindAccountViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)NSString *accountName;
@property (nonatomic,strong)NSString *phoneNum;
@end

@implementation BindAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnBackAction)];
    self.navigationItem.title = @"账户绑定";
    _accountName = @"";
    _phoneNum = @"";
    [self creatTextField];
}
- (void)returnBackAction{
    
   
    [self.navigationController popViewControllerAnimated:YES];
  

}
- (void)returnClick{
    
    NSArray *arrController =self.navigationController.viewControllers;
    BOOL isPushWhicthVC = NO;
    UIViewController *lastVC;
    for (UIViewController *vc in arrController) {
        
        if ([vc isKindOfClass:[NSClassFromString(@"WithdrawViewController") class]]) {
            lastVC = vc;
            isPushWhicthVC = YES;
        }
        
    }
    
    if (isPushWhicthVC) {
        [self.navigationController popToViewController:lastVC animated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)creatTextField{
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 70)/2,25, 70, 70)];
    imgView.image = [UIImage imageNamed:@"ipay"];
    [self.view addSubview:imgView];
    
    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 120, ScreenWidth, 50)];
    nameField.delegate = self;
    nameField.tag = 22;
    [nameField addTarget:self action:@selector(editingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    nameField.backgroundColor =  [UIColor whiteColor];
    nameField.returnKeyType = UIReturnKeyDone;
    [nameField round:2.0 RectCorners:(UIRectCornerAllCorners)];
    nameField.placeholder = @"";
    nameField.font = [UIFont fontWithName:Default_APP_Font_Reg size:15];
    
    //以下代码为了让光标右移
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    leftView.text = @"  姓名";
    leftView.font = [UIFont fontWithName:Default_APP_Font_Reg size:15];
    leftView.textColor = RGB(51, 51, 51);
    leftView.backgroundColor = [UIColor clearColor];
    nameField.leftView = leftView;
    nameField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:nameField];
    [nameField becomeFirstResponder];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(15, 260, ScreenWidth - 30, 50);
    nextBtn.layer.cornerRadius = 5;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn setBackgroundColor:BGBlue];
    [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:18];
    [nextBtn addTarget:self action:@selector(nextbtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:nextBtn];
    
    
    UITextField *phoneField = [[UITextField alloc] initWithFrame:CGRectMake(0, 170, ScreenWidth , 50)];
    phoneField.delegate = self;
    phoneField.backgroundColor =  [UIColor whiteColor];
    [phoneField addTarget:self action:@selector(editingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    phoneField.tag = 23;
    phoneField.returnKeyType = UIReturnKeyDone;
    [phoneField round:2.0 RectCorners:(UIRectCornerAllCorners)];
    phoneField.placeholder = @"";
    phoneField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    phoneField.font = [UIFont fontWithName:Default_APP_Font_Reg size:15];
    
    //以下代码为了让光标右移
    UILabel *nameView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    nameView.text = @"  支付宝账户";
    nameView.font = [UIFont fontWithName:Default_APP_Font_Reg size:15];
    nameView.textColor = RGB(51, 51, 51);
    nameView.backgroundColor = [UIColor clearColor];
    phoneField.leftView = nameView;
    
    phoneField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:phoneField];
    [phoneField becomeFirstResponder];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineView.backgroundColor = RGB(204, 204, 204);
    [phoneField addSubview:lineView];
    
    switch (self.type) {
        case BindAccountForWeChat:
            imgView.image = [UIImage imageNamed:@"icon_bankcard"];
             nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入微信姓名" attributes:@{NSForegroundColorAttributeName:RGB(153, 153, 153)}];
            phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入微信账户" attributes:@{NSForegroundColorAttributeName:RGB(153, 153, 153)}];
            break;
        case BindAccountForAli:
            imgView.image = [UIImage imageNamed:@"ipay"];
             nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入支付宝姓名" attributes:@{NSForegroundColorAttributeName:RGB(153, 153, 153)}];
            phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入支付宝账户" attributes:@{NSForegroundColorAttributeName:RGB(153, 153, 153)}];
            break;
        default:
            break;
    }
}

- (void)nextbtnClick:(UIButton *)btn{
    
    if (_accountName.length <= 0 ||  _phoneNum.length < 5) {
        
        [MBProgressHUD  showInfoMessage:@"请填写完整信息"];

    }else{
        [self.view endEditing:YES];
        if (self.type == BindAccountForAli) {
            [self commitBindInfo:@"alipay"];
            
        }else if(self.type == BindAccountForWeChat){
            
            [self commitBindInfo:@"wechat"];
            
        }
    }
   
}
- (void)commitBindInfo:(NSString *)type{
   
    
    NSString *baseUrl = base_url;
    NSString *phone = userPhone;
    NSString *urlStr = [baseUrl stringByAppendingString:@"app/truckerGroup/bindingCount"];
    NSDictionary *dicInfo = @{@"account":_phoneNum,
                              @"phone":phone,
                              @"type":type};
    [[NetWorkHelper shareInstance] Post:urlStr parameter:dicInfo success:^(id responseObj) {
        
        NSString *message = [responseObj objectForKey:@"message"];
        
        if ([message isEqualToString:@"0"]) {
            
            
            driverInfoModel *model = [JYAccountTool getDriverInfoModelInfo];
            if (self.type == BindAccountForAli) {
                model.ailpayAccount = _phoneNum;

            }else if(self.type == BindAccountForWeChat){
                model.bankCard = _phoneNum;
            }
            [JYAccountTool saveDriverInfoModelInfo:model];
            
            [self returnClick];
            [MBProgressHUD showSuccessMessage:@"绑定成功"];
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"绑定失败"];
    }];
}
- (void)editingChanged:(UITextField *)textField{
    
    if (textField.tag  == 22) {
        _accountName = textField.text;
    }else if (textField.tag == 23){
        _phoneNum = textField.text;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
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
