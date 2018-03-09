//
//  WalletViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "WalletViewController.h"
#import "MyBalanceCell.h"
#import "balanceModel.h"
#import "balanceDetailController.h"
#import "MineRequestDataDelegate.h"
#import "MineRequestData.h"
#import "JYwalletTableViewSecondCell.h"
#import "JYWalletRechargeViewController.h"
#import "WithdrawViewController.h"
#import "PasswordViewController.h"
#import "RefundDepositView.h"
#import "driverInfoModel.h"
#import "CommitSuccessViewController.h"
@interface WalletViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,MineRequestDataDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,copy)NSString *balance;
@property(nonatomic,copy)NSString *balanceId;
@property (nonatomic,strong)driverInfoModel *model;
@property (nonatomic,assign)BOOL isSetPassword;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.navigationItem.rightBarButtonItem =  [UIBarButtonItem addRight_ItemWithIcon:@"icon_gengduo" highIcon:@"icon_gengduo" target:self action:@selector(addmore)];
    _isSetPassword = NO;
    
    self.navigationItem.title = @"我的钱包";
    [self createTableView];
    [self creatBtnItem];
    
    //    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"balance_drive"]) {
    
    //        self.balance = [[NSUserDefaults standardUserDefaults]objectForKey:@"balance_drive"];
    
    //    }else{
    
    //    [self senderHttpReque];
    
    //   }
    _model = [JYAccountTool getDriverInfoModelInfo];
    _model.isAuthentication = 1;
    [JYAccountTool saveDriverInfoModelInfo:_model];
    
}
- (void)creatBtnItem{
    
    UIButton *rightItem = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightItem.frame = CGRectMake(ScreenWidth - 44 -8 , StateBarHeight + NavigationBarHeight / 2 - 44/2, 44, 44);
    [rightItem setImage:[UIImage imageNamed:@"icon_gengduo"] forState:(UIControlStateNormal)];
    [rightItem setImage:[UIImage imageNamed:@"icon_gengduo"] forState:(UIControlStateHighlighted)];
    
    [rightItem addTarget:self action:@selector(addmore) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rightItem];
    
    UIButton *leftItem = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftItem.frame = CGRectMake(5 , StateBarHeight + NavigationBarHeight / 2 - 44/2, 44, 44);
    [leftItem setImage:[UIImage imageNamed:@"return"] forState:(UIControlStateNormal)];
    [leftItem setImage:[UIImage imageNamed:@"return"] forState:(UIControlStateHighlighted)];
    
    [leftItem addTarget:self action:@selector(returnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftItem];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:Default_APP_Font size:20];
    titleLabel.text = @"我的钱包";
    titleLabel.frame = CGRectMake((ScreenWidth - 100)/2,StateBarHeight + NavigationBarHeight / 2 - 22/2 , 100, 22);
    
    [self.view addSubview:titleLabel];
    
}
- (void)addmore{
    
    if (_isSetPassword == NO) {
        
        [self ChangeInfoImag:@"设置密码"];
    }else{
        [self ChangeInfoImag:@"修改密码"];

    }
   
}

//修改密码
- (void)ChangeInfoImag:(NSString *)setPasswordType{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *payDetailAction = [UIAlertAction actionWithTitle:@"交易记录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self goTobalanceDetail];
        
    }];
    UIAlertAction *changeDense = [UIAlertAction actionWithTitle:setPasswordType style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self changeDense];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [payDetailAction setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    [cancelAction setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    [changeDense setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    
    [alert addAction:payDetailAction];
    [alert addAction:changeDense];
    [alert addAction:cancelAction];
    
    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)changeDense{
    
    
    PasswordViewController *vc = [[PasswordViewController alloc] init];
   
    if (_isSetPassword == NO) {
        
        vc.passwordType = PassWordTypeSetNew;
    }else{
        
        vc.passwordType = PassWordTypeChange;

    }
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)presentTipAlertSetCode{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"为了您的账户安全，请设置钱包密码" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self changeDense];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    //点击按钮的响应事件
    
    [alert addAction:cancelAction];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
    
}

//进入交易明细
-(void)goTobalanceDetail
{
    balanceDetailController *balanceVC = [[balanceDetailController alloc]init];
    balanceVC.balanceId = self.balanceId;
    [self.navigationController pushViewController:balanceVC animated:YES];
    
}
- (void)requestDataGetWalletForDriverSuccess:(NSDictionary *)resultDic{
    
    self.balance = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"balance"]];
    
    self.balanceId = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"id"]];
    //[[NSUserDefaults standardUserDefaults]setObject:self.balance forKey:@"balance_drive"];
    [self.tableView reloadData];
    
    NSString *wallpw = [resultDic objectForKey:@"wallpw"];
    if ([wallpw isEqual:[NSNull null]] || wallpw == nil || wallpw.length <= 0) {
        
        [self presentTipAlertSetCode];

        _isSetPassword = NO;
    }else{
        _isSetPassword = YES;
    }
    
    
}

- (void)requestDataGetWalletForDriverFailed:(NSError *)error{
    
    [MBProgressHUD showErrorMessage:@"网络异常"];
    
}
-(void)senderHttpReque
{
    self.dataArr = [NSMutableArray array];
    MineRequestData *manager  = [MineRequestData shareInstance];
    manager.delegate = self;
    [manager requestDataGetWalletForDriver:nil phone:nil idea:nil];
    
}


-(void)returnAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorColor = BgColorOfUIView;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIView *topView  = [[UIView alloc] initWithFrame:CGRectMake(0, -180, ScreenWidth, 180)];
    topView.backgroundColor = RGB(255, 133, 51);
    topView.tag = 101;
    [self.tableView addSubview:topView];
    topView.clipsToBounds = YES;//删除多余图片（第一行被遮盖)
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (void)wirthBtnClick:(UIButton *)btn{
    
    if (_model.isAuthentication == 1) {
        RefundDepositView *view = [[RefundDepositView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        NSString *tipStr = @"工作人员会在1-3个工作日与您联系，在此期间，您将不能使用抢单功能，确认要进行解冻吗？";
        NSString *titleStr = @"解冻押金";
        
        [view setModel:tipStr title:titleStr];
        view.refundDepositBlock = ^{
            driverInfoModel *model = [JYAccountTool getDriverInfoModelInfo];
            model.isAuthentication = 0;
            [JYAccountTool saveDriverInfoModelInfo:model];
            
            CommitSuccessViewController *vc = [[CommitSuccessViewController alloc] init];
            vc.pushType = PushVCFromRefundDepositView;
            [self.navigationController pushViewController:vc animated:YES];
        };
        [view showBankPickView];
        
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYwalletTableViewSecondCell *cell = [JYwalletTableViewSecondCell cellWithTableView:tableView];
    cell.nameLabel.textColor = RGB(51, 51, 51);
    cell.lineView.backgroundColor = RGB(229, 229, 229);
    cell.lineView.hidden = YES;
    cell.nameLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:15];
    cell.accessImgView.image = [UIImage imageNamed:@"icon_jiantou2"];
    
    if (indexPath.section == 0) {
        
        MyBalanceCell *cel = [MyBalanceCell cellWithTableView:tableView];
        cel.selectionStyle = UITableViewCellSelectionStyleNone;
        [cel.wirthBtn addTarget:self action:@selector(wirthBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cel.backgroundColor = RGB(255, 133, 51);
        cel.wirthBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:12];
        cel.contentView.backgroundColor = RGB(255, 133, 51);
        cel.moneyNumber.text = [NSString stringWithFormat:@"¥%.2f",[self.balance doubleValue]];
        [cel.wirthBtn setTitle:@"不可提现金额: 1000.00" forState:(UIControlStateNormal)];
        
        if (_model.isAuthentication == 1) {
            cel.wirthBtn.hidden = NO;
            cel.wirthImg.hidden = NO;
            
        }else{
            
            cel.wirthBtn.hidden = YES;
            cel.wirthImg.hidden = YES;
        }
        
        return cel;
    }else if (indexPath.section == 1){
        
        cell.nameLabel.text = @"押金";
        if (_model.isAuthentication == 1) {
            cell.detaiLab.text = @"已缴纳";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessImgView.hidden = YES;
            cell.detaiLab.textColor = RGB(102, 102, 102);
            cell.detaiLab.font = [UIFont fontWithName:Default_APP_Font_Reg size:14];
        }else{
            cell.detaiLab.text = @"未缴纳";
            cell.accessImgView.hidden = NO;
            cell.detaiLab.textColor = RGB(255, 75, 45);
        }
        return cell;
        
    }else if (indexPath.section == 2){
        
        cell.lineView.hidden = NO;
        cell.accessImgView.hidden = NO;
        cell.nameLabel.text = @"提现";
        
        return cell;
        
    }else{
        cell.accessImgView.hidden = NO;
        cell.nameLabel.text = @"充值";
        return cell;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return 230;
    }else{
        return 50;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    contenView.backgroundColor = BgColorOfUIView;
    return contenView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 2) {
        return 9;
        
    }else{
        return 0.01;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        //        DepositViewController *controller = [[DepositViewController alloc]init];
        //        [self.navigationController pushViewController:controller animated:YES];
        
        if (_model.isAuthentication == 1) {
            
        }else{
            
            JYWalletRechargeViewController *vc = [[JYWalletRechargeViewController alloc] init];
            vc.type = WalletOperationDeposit;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.section == 2){
        
        WithdrawViewController *controller = [[WithdrawViewController alloc]init];
        controller.balance = self.balance;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if (indexPath.section == 3){
        
        //
        //        JYWalletRechargeViewController *vc = [[JYWalletRechargeViewController alloc] init];
        //        vc.type = WalletOperationRecharge;
        //
        //        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}


- (void)withdrawBtnClick:(UIButton *)btn{
    
    [self presentTipAlert];
    
}
- (void)presentTipAlert{
    
    NSString *message = @"确定要将押金提现？提现后您将不能接单了";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle: UIAlertControllerStyleAlert];
    //修改标题的内容，字号，颜色。使用的key值是“attributedTitle”
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:message];
    [hogan addAttribute:NSFontAttributeName value: [UIFont fontWithName:Default_APP_Font_Reg size:17] range:NSMakeRange(0, [[hogan string] length])];
    [hogan addAttribute:NSForegroundColorAttributeName value:RGB(3, 3, 3) range:NSMakeRange(0, [[hogan string] length])];
    [alert setValue:hogan forKey:@"attributedMessage"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureaction = [UIAlertAction actionWithTitle:@"确认提现" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alert addAction:cancelAction];
    
    [alert addAction:sureaction];
    
    [self presentViewController:alert animated:true completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    
    UIViewController *topVC =  self.navigationController.topViewController;
    if ([topVC isKindOfClass:NSClassFromString(@"MineViewController")]) {
        
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self senderHttpReque];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _model = [JYAccountTool getDriverInfoModelInfo];
    [self.tableView reloadData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.y < -180) {
        CGRect rect = [self.tableView viewWithTag:101].frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        [self.tableView viewWithTag:101].frame = rect;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
