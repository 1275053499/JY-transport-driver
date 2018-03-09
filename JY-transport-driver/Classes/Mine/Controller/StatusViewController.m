//
//  StatusViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/9.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "StatusViewController.h"
#import "StatusTableViewCell.h"
#import "StatusDeleteViewController.h"
#import "StatusAddViewController.h"
@interface StatusViewController ()<UITableViewDataSource,UITableViewDelegate,StatusAddViewControllerDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *statusArr;
@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    [self creatRightBtn];
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.navigationItem.title = @"状态设置";
  
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    NSArray *staArr = [NSArray array];

    [super viewWillAppear:animated];
    staArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Log_statusArr"];
    
    if (staArr == nil || staArr.count < 3) {
        
        NSArray *arr = @[@"揽件",@"派件",@"签收"];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"Log_statusArr"];
        _statusArr = [NSMutableArray arrayWithArray:arr];
        
    }else{
        
        _statusArr = [NSMutableArray arrayWithArray:staArr];
        
    }
    [self.tableView reloadData];

    
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatRightBtn{
    UIView *BottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(42, 0, 35, 35);
    [addBtn setImage:[UIImage imageNamed:@"icon_tianjia"] forState:(UIControlStateNormal)];
    [addBtn addTarget:self action:@selector(addStutasClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(0, 0, 35, 35);
    [deleteBtn setImage:[UIImage imageNamed:@"icon_shanghcu"] forState:(UIControlStateNormal)];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [BottomView addSubview:deleteBtn];
    [BottomView addSubview:addBtn];

    
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:BottomView];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
}
- (void)addLogStatus:(NSString *)str{
    
    if (str != nil || str.length > 0) {
        
        
        NSArray *staArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Log_statusArr"];
        _statusArr = [NSMutableArray arrayWithArray:staArr];
        [_statusArr addObject:str];
        NSArray *arr = _statusArr;

        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"Log_statusArr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        

        [self.tableView reloadData];

    }
}
- (void)addStutasClick:(UIButton *)btn{
    
    StatusAddViewController *vc = [[StatusAddViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];

    
}
- (void)deleteBtnClick:(UIButton *)btn{
    
    StatusDeleteViewController *vc = [[StatusDeleteViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,9, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
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
    
    static NSString *Status = @"Status";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:Status];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:Status];
        
    }
    cell.textLabel.textColor = RGB(51, 51, 51);
    cell.textLabel.font =  [UIFont fontWithName:Default_APP_Font_Reg size:16];
    cell.textLabel.text = _statusArr[indexPath.row];
    
    
    return cell;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(chooseWhichStatus:index:)]) {
        
        [self.delegate chooseWhichStatus:_statusArr[indexPath.row] index:indexPath.row];
        [self returnAction];
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
