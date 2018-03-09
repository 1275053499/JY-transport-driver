//
//  JYBaseOrderViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/16.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYBaseOrderViewController.h"
#import "JYHomePageTableViewCell.h"
#import "JYOrderDetailViewController.h"
#import "JYMessageRequestData.h"
#import "JYMessageModel.h"
#import "JYWaitingAnimationViewController.h"
#import "JYWaitingForValuationVC.h"
@interface JYBaseOrderViewController ()<UITableViewDelegate,UITableViewDataSource,JYMessageRequestDataDelegate>

@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSTimer *timerBase;
@property (nonatomic,assign)NSInteger page;

@end

@implementation JYBaseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    self.view.backgroundColor = BgColorOfUIView;
    self.dataArr = [NSMutableArray array];

    [self creatTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MultipleSelect) name:@"MultipleSelect" object:nil];

    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [self setupRefreshView];

    [super viewWillAppear:animated];
}

-(void)setupRefreshView
{
    __weak __typeof(self) weakSelf = self;
    //上拉刷新新数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadNewData:self.index page:1];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    //下拉加载更多数据
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.page ++;
        [weakSelf loadNewData:self.index page:weakSelf.page];
        
    }];
}


//下拉刷新数据
-(void)loadNewData:(NSInteger)index page:(NSInteger)page
{
    JYMessageRequestData *manager = [JYMessageRequestData shareInstance];
    manager.delegate  = self;
    index = index + 1;
    [manager requsetGetOrderToLogistics:@"app/logisticsorder/getOrderToLogistics" phone:userPhone_Log statusPage:index page:page];
    
}

- (void)requestGetOrderToLogisticsSuccess:(NSDictionary *)resultDic{
    

    if (_page == 1) {
        
        self.dataArr = [JYMessageModel mj_objectArrayWithKeyValuesArray:resultDic];
        [self.tableView.mj_footer endRefreshing];


    }else{
        
        NSMutableArray *dataArr = [NSMutableArray array];
        dataArr = [JYMessageModel mj_objectArrayWithKeyValuesArray:resultDic];
        [self.dataArr addObjectsFromArray:dataArr];
        if (dataArr.count < 10) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.tableView.mj_footer endRefreshing];
            
        }
    }
    
   
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}
- (void)requestGetOrderToLogisticsFailed:(NSError *)error{
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];


    
}
//上拉加载旧数据
-(void)getMoreData:(NSInteger)index
{
   
    
}
//创建UItableView
-(void)creatTableView
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49 - 60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.rowHeight = 156;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}

#pragma mark - UITableData

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataArr.count;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    JYHomePageTableViewCell *cell = [JYHomePageTableViewCell cellWithOrderTableView:tableView];
    cell.messageModel = self.dataArr[indexPath.section];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 9;
    }else{
        
        return 9;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    contenView.backgroundColor = BgColorOfUIView;
    return contenView;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.tableView.isEditing) {
        
   

    JYMessageModel *messageModel = self.dataArr[indexPath.section];

    if ([messageModel.orderType isEqualToString:@"2"]) {

        JYOrderDetailViewController *orederVC = [[JYOrderDetailViewController alloc]init];
        orederVC.orderStatus = messageModel.orderStatus;
        orederVC.orderID = messageModel.id;
        [self.navigationController pushViewController:orederVC animated:YES];

    }else if ([messageModel.orderType isEqualToString:@"1"]){

        if ([messageModel.orderStatus isEqualToString:@"0"] || [messageModel.orderStatus isEqualToString:@"2"] || [messageModel.orderStatus isEqualToString:@"7"]) {

            JYWaitingAnimationViewController *vc = [[JYWaitingAnimationViewController alloc] init];
            vc.orderStutas = messageModel.orderStatus;
            vc.orderID = messageModel.id;

            [self.navigationController pushViewController:vc animated:YES];

        }else if ([messageModel.orderStatus isEqualToString:@"1"]){
            JYWaitingForValuationVC *vc = [[JYWaitingForValuationVC alloc] init];
            vc.orderId = messageModel.id;
            [self.navigationController pushViewController:vc animated:YES];

        }else {
            JYOrderDetailViewController *orederVC = [[JYOrderDetailViewController alloc]init];
            orederVC.orderStatus = messageModel.orderStatus;
            orederVC.orderID = messageModel.id;

            [self.navigationController pushViewController:orederVC animated:YES];

        }
    }

}
}
- (void)MultipleSelect{
    self.tableView.editing =!self.tableView.editing;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(void)dealloc{
    
    
}

- (void)didReceiveMemoryWarning {
    
    if([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [super didReceiveMemoryWarning];
}
@end

