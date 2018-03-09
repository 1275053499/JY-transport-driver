//
//  StatusDeleteViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/9.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "StatusDeleteViewController.h"
#import "StatusTableViewCell.h"
@interface StatusDeleteViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *statusArr;
@property (nonatomic,strong)StatusTableViewCell *statCell;
@property (nonatomic,assign)NSInteger indexRow;

@end

@implementation StatusDeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    [self createTableView];
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.navigationItem.title = @"状态设置";
    _statusArr = [NSMutableArray array];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Log_statusArr"];
    _statusArr = [NSMutableArray arrayWithArray:arr];
    [self createTableView];
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(0, ScreenHeight - 64 -50, ScreenWidth, 50);
    [btn setTitle:@"删除" forState:(UIControlStateNormal)];
    btn.titleLabel.font =  [UIFont fontWithName:Default_APP_Font_Reg size:22];
    btn.titleLabel.textColor =  [UIColor whiteColor];
    [btn setBackgroundColor:BGBlue];
    [btn addTarget:self action:@selector(deleteStatusClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (void)deleteStatusClick:(UIButton *)btn{
    
    NSArray *staArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Log_statusArr"];
    _statusArr = [NSMutableArray arrayWithArray:staArr];
    [_statusArr removeObjectAtIndex:_indexRow];
    NSArray *arr = _statusArr;
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"Log_statusArr"];
    [self returnAction];

    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _statusArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    StatusTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([StatusTableViewCell class]) owner:nil options:0][0];
  
    if (indexPath.row < 3) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.btnImg setBackgroundImage:[UIImage imageNamed:@"icon_kongxinyuan"] forState:(UIControlStateNormal)];
    [cell.btnImg setBackgroundImage:[UIImage imageNamed:@"icon_shixinyuan"] forState:(UIControlStateSelected)];
    cell.typeLabel.text  = _statusArr[indexPath.row];

    return cell;
    
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
    StatusTableViewCell *cell  =[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row > 2) {

        cell.btnImg.selected = !cell.btnImg.selected;
        _indexRow = indexPath.row;
    }
    
    if (_statCell != cell) {
        _statCell.btnImg.selected = NO;
    }
    _statCell = cell;
    



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
