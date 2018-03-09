//
//  BuyCarWriteInfoViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/12/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "BuyCarWriteInfoViewController.h"
#import "BuyCarInfoTableViewCell.h"
#import "BuyCarWriteInfoTableViewCell.h"
#import "CommitSuccessViewController.h"
@interface BuyCarWriteInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *code;
@end

@implementation BuyCarWriteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    
    self.navigationItem.title = @"基本信息";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    _phone = @"";
    _name = @"";
    _code = @"";
    [self createTableView];
    
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTableView
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    //    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    cell.codeBtn.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineView.hidden =YES;
    cell.textField.returnKeyType = UIReturnKeyDone;
    cell.textField.delegate = self;
    if (indexPath.section == 0) {
        BuyCarWriteInfoTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BuyCarWriteInfoTableViewCell class]) owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessimgView.image = [UIImage imageNamed:@"jiantou2"];
        cell.typeLabel.text = @"车型";
        cell.nameLabel.text = _carName;
        return cell;
    }else if (indexPath.section == 1){
        
        cell.typeLabel.text = @"姓名";
        cell.textField.placeholder = @"请输入您本人的姓名";
        cell.textField.tag = 3303;
        cell.textField.text = _name;
        cell.textField.keyboardType = UIKeyboardTypeDefault;

        [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
        
    }else if (indexPath.section == 2){
        
        
        cell.lineView.hidden = NO;
        cell.typeLabel.text = @"手机号";
        cell.textField.text = _phone;
        cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

        cell.textField.placeholder = @"请输入您本人的手机号";
        cell.textField.tag = 3304;
        [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
        
    }else  {
        
        cell.codeBtn.hidden = NO;
        cell.typeLabel.text = @"验证码";
        cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [cell.codeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        cell.codeBtn.layer.cornerRadius = 2;
        cell.codeBtn.layer.masksToBounds = YES;
        cell.textField.tag = 3305;
        
        cell.textField.text = _code;
        [cell.codeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        cell.codeBtn.backgroundColor = BGBlue;
        cell.textField.placeholder = @"请输入您收到的验证码";
        return cell;
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
    
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
    
    if (_phone.length > 0  && _name.length > 0 ) {
        
        [self reauestCommit];
        
    }else{
        
        [MBProgressHUD showWarnMessage:@"信息没有填写完成"];
    }
    
}
- (void)reauestCommit{
    
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/purchase/commitPurchaseApplication"];
    
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"vehicleType":@"IVECO",@"phone":_phone,@"idCardNo":_name} success:^(id responseObj) {
        
        NSString *message = [responseObj objectForKey:@"message"];
        if ([message isEqualToString:@"0"]) {
            CommitSuccessViewController *vc = [[CommitSuccessViewController alloc] init];
            vc.pushType = PushVCFromBuyCarWriteInfoVC;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showErrorMessage:@"网络错误"];
        
        
    }];
    
}

- (void)textFieldDidChange:(UITextField *)textField{
    
    if (textField.tag == 3303) {
        
        _name = textField.text;
    }else if (textField.tag == 3304){
        
        _phone = textField.text;
    }else if (textField.tag == 3305){
        
        _code = textField.text;
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
