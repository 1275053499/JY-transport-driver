//
//  ChoosePayAccountViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/10/24.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "ChoosePayAccountViewController.h"
#import "WithdrawTypeCell.h"
#import "BindAccountViewController.h"
#import "driverInfoModel.h"
#import "BankCardViewController.h"
@interface ChoosePayAccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)driverInfoModel *model;
@end

@implementation ChoosePayAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.navigationItem.title = @"账户选择";
    [self createTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    _model = [JYAccountTool getDriverInfoModelInfo];
    [self.tableView reloadData];
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
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WithdrawTypeCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WithdrawTypeCell class]) owner:nil options:0][0];
    if (indexPath.row == 0) {
        
        cell.imgType.image = [UIImage imageNamed:@"icon_ipay"];
        
        if (_model.ailpayAccount == nil || [_model.ailpayAccount isEqual:[NSNull null]] || _model.ailpayAccount.length <= 0 ){
            
            cell.contentlabel.text = @"未绑定";
        }else{
            
            cell.contentlabel.text = _model.ailpayAccount;
        }
        return cell;
        
    }else{
        
        cell.imgType.image = [UIImage imageNamed:@"icon_bankcard"];
        if (_model.bankCard == nil || [_model.bankCard isEqual:[NSNull null]] || _model.bankCard.length <= 0 ){
        
            cell.contentlabel.text = @"未绑定";
        }else{
            
            cell.contentlabel.text = _model.bankCard;

        }
        
        return cell;
        
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
    
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        if ([self isAilpayAccount] ) {
            
            if (_choosePayAccount) {
                _choosePayAccount(_model.ailpayAccount,AliAccount);
                
            }
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            
            BindAccountViewController *vc = [[BindAccountViewController alloc] init];
            vc.type = BindAccountForAli;
            [self.navigationController pushViewController:vc animated:YES];
        }
       
    }else if (indexPath.row == 1){
      
        if ([self isbankAccount]) {
            
            if (_choosePayAccount) {
                _choosePayAccount(_model.bankCard,WechatAccount);
                
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            BankCardViewController *vc = [[BankCardViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }

    }else{
        
       
    }
      
    
}


- (BOOL)isAilpayAccount{
    
    if (_model.ailpayAccount == nil || [_model.ailpayAccount isEqual:[NSNull null]] || _model.ailpayAccount.length <= 0 ) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)isbankAccount{
    
    if (_model.bankCard == nil || [_model.bankCard isEqual:[NSNull null]] || _model.bankCard.length <= 0 ) {
        return NO;
    }else{
        return YES;
    }
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
