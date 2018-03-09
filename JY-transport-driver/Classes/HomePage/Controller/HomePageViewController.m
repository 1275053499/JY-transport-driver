//
//  HomePageViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/20.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "HomePageViewController.h"
#import "GetOrderHomeCell.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "ModelOrder.h"
#import "orderDetailViewController.h"
#import "driverModel.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "JYGrabValueTableViewCell.h"
#import <AFNetworkReachabilityManager.h>
#import "EmptyTableView.h"

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate>
{
    int page;
}
@property(nonatomic,strong)NSMutableArray *statusFrames;
@property(nonatomic,strong)NSMutableArray *driverStatus;//司机信息
@property(nonatomic,strong)EmptyTableView *tableView;
//@property(nonatomic,strong)AMapLocationManager *locationManager;
@property(nonatomic,strong)CLLocation *location;
@property(nonatomic,weak)UIImageView *NODataImage;
@property (nonatomic,strong)NSString *driverBasicStatus;
@property (nonatomic,strong)NSTimer *timerFirst;

@property (nonatomic,strong)BMKLocationService *locService;
@property (nonatomic,assign)BOOL isUpdaing;

@end

@implementation HomePageViewController

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
  

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:Default_APP_Font size:20]};

    self.statusFrames = [NSMutableArray array];
    _driverStatus = [NSMutableArray array];
    page=1;
    self.view.backgroundColor = BgColorOfUIView;
    [self creatTableView];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.distanceFilter = 10;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    [_locService startUserLocationService];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRefreshView) name:@"RobOrderSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRefreshView) name:@"orderCancelSuccess" object:nil];//收到订单成功取消的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRefreshView) name:@"orderEndSuccess" object:nil];//// 最终的结束服务通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRefreshView) name:@"orderbeginWorking" object:nil];//开始服务通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeg:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationdidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //没有网络
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NetworkReachabilityStatusUnknown) name:@"noWork" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNewOrder) name:@"GetNewOrder" object:nil];//附近有新的订单  需要刷新接单广场
    _isUpdaing = NO;
   
//    [self addTimerQueryData];
}

- (void)NetworkReachabilityStatusUnknown{
    
    [self.tableView.mj_header endRefreshing];
}
#pragma mark - BMKMapViewDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    _location = userLocation.location;
    NSLog(@"===================%f",userLocation.location.coordinate.latitude);
    
}

- (void)updateNewOrder{
    
    [self queryDriverInfo];
    

}
//进入前台
- (void)applicationWillEnterForeg:(NSNotification *)nottfication{
    
    [self setupRefreshView];
    [self performSelector:@selector(addTimerQueryData) withObject:nil afterDelay:0.5];
}

//退到后台
- (void)applicationdidEnterBackground:(NSNotification *)nottfication{
    //关闭定时器
    [self.timerFirst invalidate];
    _timerFirst = nil;
    
}
- (void)addTimerQueryData{
    if (_timerFirst) {
        return;
    }
    _timerFirst = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(queryDriverInfo) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timerFirst forMode:NSRunLoopCommonModes];

}

//页面消失，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    [self.timerFirst invalidate];
    _timerFirst = nil;
}
/**
 *  设置导航栏的内容
 */
- (void)setupNavBar
{
    self.navigationItem.title=@"接单广场";

}

//- (void)noNetWorkTip{
//
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您现在没有可用网络" preferredStyle: UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //点击按钮的响应事件；
//    }]];
//    //弹出提示框；
//    [self presentViewController:alert animated:true completion:nil];
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self setupRefreshView];
    [self performSelector:@selector(addTimerQueryData) withObject:nil afterDelay:0.5];
    //开启定时器
    
}
//查询司机状态
- (void)queryDriverInfo{
    
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/chartered/getTruckerInfo"];
 
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":userPhone} success:^(id responseObj) {
         NSArray *arr =[NSArray arrayWithObject:responseObj];
        
        _driverStatus = [driverModel mj_objectArrayWithKeyValuesArray:arr];
        driverModel *mode = _driverStatus[0];
        _driverBasicStatus = mode.basicStatus;
        [self loadNewDataq];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showErrorMessage:@"网络异常"];
         [self.tableView.mj_header endRefreshing];

    }];
}


-(void)setupRefreshView
{
    
    if (self.tableView.mj_header.isRefreshing) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    //上拉刷新新数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

    [weakSelf queryDriverInfo];
    }];
      [self.tableView.mj_header beginRefreshing];
    //下拉加载更多数据
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
      [weakSelf getMoreData];
        
    }];
}
//下拉刷新数据
-(void)loadNewDataq
{
    page=1;

    NSString *phoneNumber = [JYAccountTool userName];
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/searchReqByDirver"];
    
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":phoneNumber,@"latitude":@(self.location.coordinate.latitude),@"longitude":@(self.location.coordinate.longitude),@"page":@"1"} success:^(id responseObj) {
        
        [self.tableView.mj_footer resetNoMoreData];
        [self.statusFrames removeAllObjects];

            NSMutableArray *dataArr = [ModelOrder mj_objectArrayWithKeyValuesArray:responseObj];
            
            [self.statusFrames addObjectsFromArray:dataArr];
        
            [self.tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.statusFrames.count frame:self.tableView.frame];
        
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        
 
    } failure:^(NSError *error) {
        
         [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showErrorMessage:@"网络异常"];
    }];
    
}
//上拉加载旧数据
-(void)getMoreData
{
    page ++;
    NSString *phoneNumber = userPhone;
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/searchReqByDirver"];
      [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":phoneNumber,@"latitude":@(self.location.coordinate.latitude),@"longitude":@(self.location.coordinate.longitude),@"page":[NSString stringWithFormat:@"%d",page]} success:^(id responseObj) {
          
  
          if([responseObj isKindOfClass:[NSDictionary class]]){
              if ( [[responseObj objectForKey:@"message"] isEqualToString:@"404"]) {
                  
                  [MBProgressHUD showErrorMessage:@"暂无更多数据"];
                  [self.tableView.mj_footer endRefreshingWithNoMoreData];

              }

          }else{
 
              
              NSMutableArray *dataArr = [ModelOrder mj_objectArrayWithKeyValuesArray:responseObj];
              [self.statusFrames addObjectsFromArray:dataArr];
              
              [self.tableView reloadData];
              [self.tableView.mj_footer endRefreshing];
 
          }
        
    } failure:^(NSError *error) {
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showErrorMessage:@"网络异常" ];
        
    }];
    
    
}
//创建UItableView
-(void)creatTableView
{
    
    self.tableView = [[EmptyTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49 - NavigationBarHeight - StateBarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - UITableData

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.statusFrames.count;
    
 
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ModelOrder *model = self.statusFrames[indexPath.section];

    if (indexPath.row == 0) {
        JYGrabValueTableViewCell *cell = [JYGrabValueTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (model.timeType == 1) {
        
            cell.sendType.text = @"即时用车";
        }else{

            [cell setDateFromString:model.departTime];
        
        }
        return cell;

    }else if (indexPath.row ==1){
        JYGrabValueTableViewCell *cell = [JYGrabValueTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.sendType.font = [UIFont fontWithName:Default_APP_Font_Reg size:50];
        cell.sendType.text = [@"¥" stringByAppendingString:[NSString stringWithFormat:@"%.0f",model.bid]];
        
        return cell;
    }else{
        GetOrderHomeCell *cell = [GetOrderHomeCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.Robmodel = model;
        [cell.RobOrederButton addTarget:self action:@selector(robOrderBegin:) forControlEvents:UIControlEventTouchUpInside];
        cell.RobOrederButton.tag = indexPath.section;
        
        return cell;

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }else{
        return 9;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    contenView.backgroundColor = BgColorOfUIView;
    return contenView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return 43;
    }else if (indexPath.row == 1){
        
        return 88;
    }else{
        
        return UITableViewAutomaticDimension;
    }

}


#pragma mark CoreLocation deleagte (定位失败)
/*定位失败则执行此代理方法*/
/*定位失败弹出提示窗，点击打开定位按钮 按钮，会打开系统设置，提示打开定位服务*/
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    /*设置提示提示用户打开定位服务*/
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok =[UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /*打开定位设置*/
        NSURL * settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingsURL];
    }];
    UIAlertAction * cacel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:ok];
    [alert addAction:cacel];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)robOrderBegin:(UIButton*)button
{
        NSString *phoneNumber = userPhone;
        orderDetailViewController *orederVC = [[orderDetailViewController alloc]init];
        orederVC.OrderModel = self.statusFrames[button.tag];
        ModelOrder *Model = self.statusFrames[button.tag];
        
        NSString *baseStr = base_url;
        NSString *urlStr = [baseStr stringByAppendingString:@"/app/chartered/lootCharteredOrder"];
        
        [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":phoneNumber,@"orderId": Model.orderNo} success:^(id responseObj) {
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RobOrderSuccess" object:nil];
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"RobOrderSuccess"];
            [self.navigationController pushViewController:orederVC animated:YES];
            
            
            
            
        } failure:^(NSError *error) {
            [MBProgressHUD showErrorMessage:@"网络异常"];
        }];

    }
    

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    orderDetailViewController *orederVC = [[orderDetailViewController alloc]init];
//    
//    ModelOrder *orderModel = self.statusFrames[indexPath.section];
//    orederVC.OrderModel= orderModel;
//    
//    
//    [self.navigationController pushViewController:orederVC animated:YES];
//
//
//}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RobOrderSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderCancelSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderEndSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderbeginWorking" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noWork" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetNewOrder" object:nil];

}
- (void)didReceiveMemoryWarning {
    
    if([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [super didReceiveMemoryWarning];
}
@end
