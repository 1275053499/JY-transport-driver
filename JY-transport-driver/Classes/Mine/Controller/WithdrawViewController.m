//
//  WithdrawViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/10/17.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "WithdrawViewController.h"
#import "WithdrawTableViewCell.h"
#import "WithdrawTypeCell.h"
#import "ChoosePayAccountViewController.h"
#import "AllWithdrawTableViewCell.h"
#import "driverInfoModel.h"
#import "PopPasswordView.h"
#import "NSString+Hash.h"
@interface WithdrawViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TMTextFieldViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSString *moneyText;
@property (nonatomic,strong)driverInfoModel *model;
@property (nonatomic,strong)NSString *bankNum;
@property (nonatomic,strong)NSString *aliAccout;
@property (nonatomic,strong)NSString *wechatAccout;
@property (nonatomic,assign)ChooseAccountType chooseType;

@property (nonatomic,strong)PopPasswordView *passwordView;
@end

@implementation WithdrawViewController
static NSString *cellId = @"AllWithdrawTableViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.navigationItem.title = @"零钱提现";
    _moneyText = @"";
    _bankNum = @"";
    _wechatAccout = @"";
    _aliAccout = @"";
    _chooseType = 0;
    [self createTableView];
}


-(void)returnAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[AllWithdrawTableViewCell class] forCellReuseIdentifier:cellId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UITextField *field = [self.view viewWithTag:565];
    [field becomeFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _model = [JYAccountTool getDriverInfoModelInfo];
    
    if (![_model.bankCard isEqual:[NSNull null]]) {
        if (_model.bankCard != nil && _model.bankCard.length > 0 ) {
            
            _wechatAccout = _model.bankCard;
            
        }
    }
    
    if (![_model.ailpayAccount isEqual:[NSNull null]]) {
        if (_model.ailpayAccount != nil && _model.ailpayAccount.length > 0 ) {
            
            _aliAccout = _model.ailpayAccount;
            
        }
    }
    
    [self.tableView reloadData];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return 50;
    }else{
        if (indexPath.row == 0) {
            return 90;
        }else{
            
            return 44;
            
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        WithdrawTypeCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WithdrawTypeCell class]) owner:nil options:0][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imgType.image = [UIImage imageNamed:@"icon_ipay"];
        cell.accessImg.image = [UIImage imageNamed:@"icon_jiantou2"];
        
        
        if (_aliAccout.length > 0) {
            cell.contentlabel.text = _aliAccout;
            cell.imgType.image = [UIImage imageNamed:@"icon_ipay"];
            
        }else if (_wechatAccout.length > 0){
            cell.imgType.image = [UIImage imageNamed:@"icon_bankcard"];
            
            cell.contentlabel.text = _wechatAccout;
            
        }else{
              cell.contentlabel.text = @"未绑定";
        }
        if (_bankNum.length > 0 ){
            if (_chooseType == WechatAccount) {
                cell.imgType.image = [UIImage imageNamed:@"icon_bankcard"];
                
            }else{
                cell.imgType.image = [UIImage imageNamed:@"icon_ipay"];
                
            }
            
            cell.contentlabel.text = _bankNum;
            
        }
        
        return cell;
    }else{
        if (indexPath.row == 0) {
            WithdrawTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WithdrawTableViewCell class]) owner:nil options:0][0];
            [cell.moneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.moneyTextField.tag = 565;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.moneyTextField.returnKeyType = UIReturnKeyDone;
            cell.moneyTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.moneyTextField.delegate = self;
            cell.moneyTextField.text = _moneyText;
            
            return cell;
        }else{
            AllWithdrawTableViewCell *WithdrawCell = [tableView dequeueReusableCellWithIdentifier:cellId];
            WithdrawCell.tag = 569;
            WithdrawCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [WithdrawCell.withdrawBtn  addTarget:self action:@selector(withdrawBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [WithdrawCell setBalance:_balance];
            
            
            
            return WithdrawCell;
        }
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        return 120;
    }else{
        return 0.001;
        
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    v.backgroundColor = BgColorOfUIView;
    if (section == 1) {
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(15, 90, ScreenWidth -30, 50);
        [btn setTitle:@"完成" forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        btn.backgroundColor = RGB(105, 181, 240);
        btn.enabled = NO;
        btn.tag = 566;
        
        if (_aliAccout.length > 0 || _wechatAccout.length > 0 || _bankNum.length > 0) {
            if (_moneyText.length > 0) {
                
                btn.backgroundColor =  BGBlue;
                btn.enabled = YES;
            }
        }
        
        [btn addTarget:self action:@selector(finishClick:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:18];
        [v addSubview:btn];
    }
    
    return v;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self.view endEditing:YES];
        ChoosePayAccountViewController *vc = [[ChoosePayAccountViewController alloc] init];
        vc.choosePayAccount = ^(NSString *phoneNum, ChooseAccountType type) {
            
            _bankNum = phoneNum;
            _chooseType = type;
            [self.tableView reloadData];
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)finishClick:(UIButton *)btn{
    
    self.passwordView = [[PopPasswordView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.passwordView.tmPasswordView.delegate = self;
    self.passwordView.money = _moneyText;
    [self.passwordView.tmPasswordView.pwdTextField becomeFirstResponder];
    [[UIApplication sharedApplication].keyWindow addSubview:self.passwordView];


}
/**
 *  输入密码回调
 */
#pragma mark ======== delegate =========
- (void)passWordCompleteInput:(TMTextFieldView *)passWord{

    NSString *pwd =  [self encrybtion:passWord.pwdPassword];
    [self checkThePassword:pwd];
    
}


- (NSString *)encrybtion:(NSString *)code{
    
    NSString * pwdStr = [code stringByAppendingString:salt];
    NSString *pwdStrCode = pwdStr.md5String;
    return pwdStrCode;
}
//校验密码
- (void)checkThePassword:(NSString *)str{
    //idea（0用户1司机2物流）
    NSString *urls = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urls stringByAppendingString:@"app/wallet/checkThePassword"];
    NSString *phone = userPhone;
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":phone,@"pwd":str,@"idea":@"1"} success:^(id responseObj) {
        
        NSString *code = [responseObj objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            
              [self sendPostWithdraw];
             [self.passwordView removeFromSuperview];
            
        }else{
            [MBProgressHUD showErrorMessage:@"密码错误"];
            [self.passwordView.tmPasswordView deleteAllPassWord];

        }
        
        
    } failure:^(NSError *error) {
        
       
        [MBProgressHUD showErrorMessage:@"失败"];
        
    }];
}


- (void)sendPostWithdraw{
    
    NSString *accountType = @"";
    NSString *account = @"";
    
    if (_aliAccout.length > 0 ){
        
        accountType =@"支付宝";
        account = _aliAccout;
    }else if(_wechatAccout.length > 0){
        
        accountType =@"银行卡";
        account = _wechatAccout;
    }
    if(_bankNum.length > 0 ){
        if (_chooseType == WechatAccount) {
            accountType =@"银行卡";
            
        }else if (_chooseType == AliAccount){
            accountType =@"支付宝";
        }
        account = _bankNum;
    }
    
    NSString *phone = userPhone;
    NSDictionary *dic = @{@"phone":phone,@"amount":self.moneyText,@"account":account,@"accountType":accountType};
    NSLog(@"%@",dic);
    
    NSString *base = base_url;//提现账户类型（aliPay,wechat,bank）
    NSString *url = [base stringByAppendingString:@"app/cash/cashApplication"];
    
    [[NetWorkHelper shareInstance] Post:url parameter:dic success:^(id responseObj) {
        
        
        [MBProgressHUD showInfoMessage:@"提现成功"];
        [self returnAction];
    } failure:^(NSError *error) {
        
        [MBProgressHUD showInfoMessage:@"失败"];
    }];
}
-(void)withdrawBtnClick:(UIButton *)button
{
    UIButton *btn = [self.view viewWithTag:566];
    
    [self.view endEditing:YES];
    _moneyText =  _balance;
    
    if ([_moneyText floatValue] > 0) {
        btn.enabled = YES;
        
        btn.backgroundColor = BGBlue;
    }else{
        btn.enabled = YES;
        btn.backgroundColor = RGB(105, 181, 240); ;
    }
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
}


-(void)textFieldDidChange:(UITextField *)theTextField{
    
    _moneyText = theTextField.text;
    
    UIButton *btn = [self.view viewWithTag:566];
    AllWithdrawTableViewCell *cell = [self.view viewWithTag:569];
    btn.backgroundColor = RGB(105, 181, 240);
    btn.enabled = NO;
    
    
    if (_aliAccout.length > 0 || _wechatAccout.length > 0 || _bankNum.length > 0) {
        if (_moneyText.length > 0 && [_moneyText floatValue] > 0 && ([_moneyText floatValue] <= [_balance floatValue])) {
            
            btn.backgroundColor =  BGBlue;
            btn.enabled = YES;
        }else{
            btn.backgroundColor = RGB(105, 181, 240);
            btn.enabled = NO;
        }
    }
    
    [cell cellWithDate:theTextField.text];
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 565) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (textField.text.length >=8 ) {
            return NO;
        }
        //首位不能为.号
        if (range.location == 0 && [string isEqualToString:@"."] ) {
            return NO;
        }
        
        return [self isRightInPutOfString:textField.text withInputString:string range:range];
        return NO;
        
    }else{
        return YES;
    }
    
}
- (BOOL)isRightInPutOfString:(NSString *) string withInputString:(NSString *) inputString range:(NSRange) range{
    //判断只输出数字和.号
    NSString *passWordRegex = @"[0-9\\.]";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    if (![passWordPredicate evaluateWithObject:inputString]) {
        return NO;
    }
    //逻辑处理
    if ([string containsString:@"."]) {
        if ([inputString isEqualToString:@"."]) {
            return NO;
        }
        NSRange subRange = [string rangeOfString:@"."];
        if (range.location - subRange.location > 2) {
            return NO;
        }
    }
    return YES;
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
