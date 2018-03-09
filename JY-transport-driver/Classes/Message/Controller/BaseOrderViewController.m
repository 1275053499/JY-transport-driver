//
//  BaseOrderViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "BaseOrderViewController.h"
#import "ModelOrder.h"
#import "orderDetailViewController.h"
#import "OrderTableViewCell.h"
#import "EmptyTableView.h"
@interface BaseOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
 int page;
}
@property(nonatomic,strong)NSMutableArray *statusFrames;
@property(nonatomic,strong)EmptyTableView *tableView;
@end

@implementation BaseOrderViewController
{
 
      NSString *currentCategory_;
    NSMutableArray *categoriesArr_;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    categoriesArr_ = [NSMutableArray array];
    self.statusFrames = [NSMutableArray array];
    page=1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTableView];
    [self setupRefreshView];
//    [self addTimerQueryData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRefreshView) name:@"RobOrderSuccess" object:nil];//抢订单成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRefreshView) name:@"orderCancelSuccess" object:nil];//收到订单成功取消的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRefreshView) name:@"orderEndSuccess" object:nil];//// 最终的结束服务通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRefreshView) name:@"orderbeginWorking" object:nil];//开始服务通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationdidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeg:) name:UIApplicationWillEnterForegroundNotification object:nil];
    //没有网络
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NetworkReachabilityStatusUnknown) name:@"noWork" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryData) name:@"sureDriver" object:nil];//用户确认司机  刷新司机订单状态

}


- (void)NetworkReachabilityStatusUnknown{
    
    [self.tableView.mj_header endRefreshing];
}

//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
    [self loadNewData:self.index];
}

//进入前台
- (void)applicationWillEnterForeg:(NSNotification *)nottfication{
    
  [self loadNewData:self.index];

    
}
//退到后台
- (void)applicationdidEnterBackground:(NSNotification *)nottfication{
   
    
}
//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
   
}
- (void)queryData{
    
    [self loadNewData:self.index];
}
-(void)setupRefreshView
{
     __weak __typeof(self) weakSelf = self;
    //上拉刷新新数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNewData:self.index];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    //下拉加载更多数据

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
         [weakSelf getMoreData:self.index];
        
     }];
//    self.tableView.mj_footer.hidden = YES;
}

//下拉刷新数据
-(void)loadNewData:(NSInteger)index
{
  
    NSString *phoneNumber = userPhone;
    page=1;
    NSArray *catagoryArr = @[@"2",@"4",@"5"];
    currentCategory_ = [catagoryArr objectAtIndex:index];
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/getOrderByTrucker"];
    
     [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":phoneNumber,@"status":currentCategory_,@"page":@"1"} success:^(id responseObj) {

         [self.tableView.mj_footer resetNoMoreData];
         [self.statusFrames removeAllObjects];

         _statusFrames = [ModelOrder mj_objectArrayWithKeyValuesArray:responseObj];
         [self.tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.statusFrames.count frame:self.tableView.frame];
       
         [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
         
    } failure:^(NSError *error) {
        
        [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
         [self.tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.statusFrames.count frame:self.tableView.frame];
         [MBProgressHUD showErrorMessage:@"网络异常"];
    }];
 }
//上拉加载旧数据
-(void)getMoreData:(NSInteger)index
{
    NSString *phoneNumber = userPhone;
    page ++;
    NSArray *catagoryArr = @[@"2",@"4",@"5"];
    currentCategory_ = [catagoryArr objectAtIndex:index];
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/getOrderByTrucker"];
    
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":phoneNumber,@"status":currentCategory_,@"page":[NSString stringWithFormat:@"%d",page]} success:^(id responseObj) {
        
        
        if([responseObj isKindOfClass:[NSDictionary class]]){
            if ( [[responseObj objectForKey:@"message"] isEqualToString:@"404"]) {
                
                [MBProgressHUD showErrorMessage:@"暂无更多数据"];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }
            
        }else{
            NSMutableArray *dataArr = [ModelOrder mj_objectArrayWithKeyValuesArray:responseObj];
            NSMutableArray *statusFrameArray = [NSMutableArray array];
            
            for (ModelOrder *model in dataArr) {
                
                [statusFrameArray addObject:model];
            }
            
                [self.statusFrames addObjectsFromArray:statusFrameArray];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];

                
            }
        
        [self.tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.statusFrames.count frame:self.tableView.frame];


        } failure:^(NSError *error) {

        [self.tableView reloadData];

        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showErrorMessage:@"网络异常"];
    }];


}
//创建UItableView
-(void)creatTableView
{
    
    self.tableView = [[EmptyTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-40 - NavigationBarHeight - StateBarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;

    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionHeaderHeight = 9;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - UITableData

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    
   

    return self.statusFrames.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 188;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    OrderTableViewCell *cell = [OrderTableViewCell cellWithTableView:tableView];
    cell.model = self.statusFrames[indexPath.section];
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else{
        return 9;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        contenView.backgroundColor = BgColorOfUIView;
    
    return contenView;
 }
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    orderDetailViewController *orederVC = [[orderDetailViewController alloc]init];
    
    ModelOrder *orderModel = self.statusFrames[indexPath.section];
    orederVC.OrderModel= orderModel;
    
    
    [self.navigationController pushViewController:orederVC animated:YES];
    
    
}
-(void)dealloc{
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RobOrderSuccess" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderCancelSuccess" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderEndSuccess" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderbeginWorking" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sureDriver" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noWork" object:nil];
}
- (void)didReceiveMemoryWarning {
    
    if([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [super didReceiveMemoryWarning];
}
@end
