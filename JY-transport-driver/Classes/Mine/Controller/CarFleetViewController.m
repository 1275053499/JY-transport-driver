//
//  CarFleetViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "CarFleetViewController.h"
#import "CarFleetCell.h"

@interface CarFleetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation CarFleetViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    [self createTableView];
 }

-(void)createTableView
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight =101;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CarFleetCell *cell = [CarFleetCell cellWithTableView:tableView];
    
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
