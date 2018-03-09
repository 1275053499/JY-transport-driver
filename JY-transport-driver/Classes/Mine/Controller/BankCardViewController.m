//
//  BankCardViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/16.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "BankCardViewController.h"

#import "BuyCarInfoTableViewCell.h"
#import "BankPickerView.h"
#import "driverInfoModel.h"
#import "RefundDepositView.h"
@interface BankCardViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSString *bankName;//银行名称
@property (nonatomic,strong)NSString *cardId;//银行卡账号
@property (nonatomic,strong)NSString *bankId;//银行ID
@property (nonatomic,strong)NSString *name;//值卡人姓名
@property (nonatomic,strong)NSString *bankCard;//银行卡 没有空格
@end

@implementation BankCardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    
    self.navigationItem.title = @"提现账户";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    _bankId = @"";
    _cardId = @"";
    _bankName = @"";
    _name = @"";
    _bankCard = @"";
    [self createTableView];
   
    
}

//- (void)creatDepositView{
//
//    RefundDepositView *view = [[RefundDepositView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    NSString *tipStr = @"请添加已绑定微信的银行卡";
//    NSString *titleStr = @"添加银行卡";
//
//    [view setModel:tipStr title:titleStr];
//    view.refundDepositBlock = ^{
//
//
//    };
//    [view showBankPickView];
//
//}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    [self creatDepositView];

}
- (void)returnAction{
    
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
-(void)createTableView
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    //    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (UIView *)creatTabHeardView{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, 0, ScreenWidth, 30);
    lab.text = @"请添加已绑定微信的银行卡";
    lab.textColor = RGB(153, 153, 153);
    v.backgroundColor = [UIColor colorWithHexString:@"#daefff"];
    lab.font = [UIFont fontWithName:Default_APP_Font_Reg size:13];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = RGB(153, 153, 153);
    [v addSubview:lab];
    
    return v;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 1;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            return 40;
        }else{
            return 50;
        }
    }else{
        
        return 50;
        
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyCarInfoTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BuyCarInfoTableViewCell class]) owner:nil options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineView.hidden =YES;
    cell.textField.delegate = self;
    cell.textField.returnKeyType = UIReturnKeyDone;
    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (indexPath.section == 0) {
        cell.typeLabel.text = @"姓名";
        cell.textField.tag = 3301;
        cell.textField.placeholder = @"请输入姓名";
        cell.textField.text = _name;
        return cell;
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            cell.lineView.hidden = NO;
            cell.typeLabel.text = @"开户行";
            cell.textField.placeholder = @"请选择开户行";
            cell.textField.text = _bankName;
            cell.textField.tag = 3302;
            return cell;
            
        }else{
            //            cell.btn.hidden = NO;
            //            cell.typeLabel.text = @"验证码";
            //            [cell.btn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
            //            cell.btn.layer.cornerRadius = 2;
            //            cell.btn.layer.masksToBounds = YES;
            //            [cell.btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            //            cell.btn.backgroundColor = BGBlue;
            //            cell.textField.placeholder = @"请输入您收到的验证码";
            
        }
        
        return cell;
        
    }else {
        
        cell.typeLabel.text = @"银行卡号";
        cell.textField.placeholder = @"请输入您的银行卡号码";
        cell.textField.tag = 3303;
        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.text = _cardId;
        
        return cell;
        
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    if (section == 0) {
      v =  [self creatTabHeardView];
    }
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 30;
    }else{
        return 5;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
    v.backgroundColor = BgColorOfUIView;
    if (section == 2) {
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(15, 80, ScreenWidth -30, 50);
        [btn setTitle:@"提交资料" forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        btn.backgroundColor = BGBlue;
        [btn addTarget:self action:@selector(finishClick:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:18];
        [v addSubview:btn];
    }
    
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 2) {
        return 140;
    }else{
        return 0.01;
    }
  
   
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)finishClick:(UIButton *)btn{
    if (_name.length > 0 && _cardId.length > 0 && _bankName.length > 0) {
        
        [self reauestCommit];
        
    }else{
        
        [MBProgressHUD showWarnMessage:@"信息没有填写完成"];
    }
    
}
- (void)reauestCommit{
    [self.view endEditing:YES];
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/truckerGroup/bindingBankCard"];
    NSString *phone = userPhone;
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":phone,@"openingBank":_bankId,@"bankCardName":_name,@"bankCard":_bankCard,} success:^(id responseObj) {
        
        NSString *code = [responseObj objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            
            driverInfoModel *model = [JYAccountTool getDriverInfoModelInfo];
            model.bankCard = _bankCard;
            [JYAccountTool saveDriverInfoModelInfo:model];
            [self returnClick];
            [MBProgressHUD showSuccessMessage:@"绑定成功"];
        }
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showErrorMessage:@"网络错误"];
        
        
    }];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 3302) {
        
        [self.view endEditing:YES];
        BankPickerView *bankView = [[BankPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        bankView.bankNameBlock = ^(NSString *name, NSString *nameID) {
            _bankName = name;
            _bankId = nameID;
            
            [self.tableView reloadData];
            
        };
        [bankView showBankPickView];
        
        
        
        return NO;
    }
    return YES;
    
}
- (void)textFieldDidChange:(UITextField *)textField{
    
    if (textField.tag == 3301){
        
        _name = textField.text;
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
- (void)aggrementBtnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 3303) {
        NSString *text = textField.text;
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        //        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        // 限制长度
        if (text.length >= 19) {
            return NO;
        }
        _bankCard = text;

        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
       
        
        [textField setText:newString];
        _cardId = newString;
        
        return NO;
        
    }
    return YES;
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

