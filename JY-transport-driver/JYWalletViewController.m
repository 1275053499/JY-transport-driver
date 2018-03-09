//
//  JYWalletViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYWalletViewController.h"
#import "JYwalletTableViewCell.h"
#import "JYwalletTableViewSecondCell.h"
#import "UIView+Extension.h"

#import "JYWalletRechargeViewController.h"
@interface JYWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation JYWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的钱包";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    [self createTableView];

}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 180;
    }else{
        
        return 50;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYwalletTableViewSecondCell *cell = [JYwalletTableViewSecondCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];

//    if (indexPath.section == 0) {
//        JYwalletTableViewCell *cel = [JYwalletTableViewCell cellWithTableView:tableView];
//        return cel;
//    }else if (indexPath.section == 1){
//        cell.btnCell.tag = 64;
//        cell.btnCell.backgroundColor =  BGBlue;
//        [cell.btnCell setTitle:@"充值" forState:(UIControlStateNormal)];
//        [cell.btnCell setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//        cell.btnCell.titleLabel.font =  [UIFont fontWithName:Default_APP_Font_Reg size:22];
//        [cell.btnCell addTarget:self action:@selector(btnCellCick:) forControlEvents:(UIControlEventTouchUpInside)];
//
//    }else if (indexPath.section == 2){
//        cell.btnCell.tag = 65;
//        cell.btnCell.backgroundColor =  [UIColor whiteColor];
//        [cell.btnCell setTitle:@"提现" forState:(UIControlStateNormal)];
//        [cell.btnCell setTitleColor:BGBlue forState:(UIControlStateNormal)];
//        cell.btnCell.titleLabel.font =  [UIFont fontWithName:Default_APP_Font_Reg size:22];
//        [cell.btnCell addTarget:self action:@selector(btnCellCick:) forControlEvents:(UIControlEventTouchUpInside)];
//
//    }else if (indexPath.section == 3){
//        cell.btnCell.tag = 66;
//        cell.btnCell.backgroundColor =  [UIColor whiteColor];
//        [cell.btnCell setTitle:@"明细" forState:(UIControlStateNormal)];
//        [cell.btnCell setTitleColor:BGBlue forState:(UIControlStateNormal)];
//        cell.btnCell.titleLabel.font =  [UIFont fontWithName:Default_APP_Font_Reg size:22];
//        [cell.btnCell addTarget:self action:@selector(btnCellCick:) forControlEvents:(UIControlEventTouchUpInside)];
//
//    }
    return cell;
    
    
}
- (void)btnCellCick:(UIButton *)btn{
    
    if (btn.tag == 64) {
        JYWalletRechargeViewController *vc = [[JYWalletRechargeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (btn.tag == 65){
        
    }else{
        
        
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
