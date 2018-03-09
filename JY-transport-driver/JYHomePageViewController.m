//
//  JYHomePageViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYHomePageViewController.h"

#import "JYHomeGrabOrderTableViewCell.h"
#import "JYGrabTableViewCellSecond.h"
#import "JYGrabTableViewCellThird.h"
#import "JYGrabServiceTableViewCell.h"
#import "JYGrabValueTableViewCell.h"
#import "JYWaitingForValuationVC.h"
#import "JYHomeRequestDate.h"
#import "JYGraSingleModel.h"
#import "JYOrderDetailViewController.h"
@interface JYHomePageViewController () <UITableViewDataSource,UITableViewDelegate,JYHomeRequestDateDelegate>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *homeOrderArr;
@property (nonatomic,assign)NSInteger btnTag;
@property (nonatomic,assign)NSInteger page;
@end

@implementation JYHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"接单广场";
    self.view.backgroundColor = [UIColor whiteColor];
    _btnTag = 0 ;
    _page = 1;
    _homeOrderArr = [NSMutableArray array];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:Default_APP_Font size:20]};
    self.view.backgroundColor = BgColorOfUIView;
    [self createTableView];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-NavigationBarHeight - StateBarHeight - 49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.estimatedRowHeight = 108;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;
    [self.view addSubview:self.tableView];

    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self initRefresh];
}
- (void)initRefresh{
    
    __weak __typeof(self) weakSelf = self;
    //上拉刷新新数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf queryAllList:1];
    }];
    [self.tableView.mj_header beginRefreshing];
    //下拉加载更多数据
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        

        weakSelf.page ++;
        
        [weakSelf queryAllList:weakSelf.page];
        
    }];


}
- (void)queryAllList:(NSInteger)page{
    
    JYHomeRequestDate *manager = [JYHomeRequestDate shareInstance];
    manager.delegate = self;
    [manager requsetGetListToLogistics:@"app/logisticsorder/getListToLogistics" phone:userPhone_Log page:page];
    
}

- (void)requestGetListToLogisticsSuccess:(NSDictionary *)resultDic{

    
    if (_page == 1) {
        
        self.homeOrderArr = [JYGraSingleModel mj_objectArrayWithKeyValuesArray:resultDic];
        [self.tableView.mj_footer endRefreshing];

    }else{
        
        NSMutableArray *dataArr = [NSMutableArray array];
        dataArr = [JYGraSingleModel mj_objectArrayWithKeyValuesArray:resultDic];
        [self.homeOrderArr addObjectsFromArray:dataArr];
        if (dataArr.count < 10) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.tableView.mj_footer endRefreshing];
            
        }
        
    }
    
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];

}
- (void)requestGetListToLogisticsFailed:(NSError *)error{
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.homeOrderArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {

      return 44;

    }else if (indexPath.row == 1){
        return 88;
    }else if (indexPath.row == 2){
        return 40;
    }else if (indexPath.row == 3){
        return 40;
    }else {
        return UITableViewAutomaticDimension;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    JYGrabTableViewCellThird *cellThird = [JYGrabTableViewCellThird cellWithTableView:tableView];
    cellThird.selectionStyle = UITableViewCellSelectionStyleNone;
    JYGraSingleModel *model = self.homeOrderArr[indexPath.section];
    NSDictionary *dicCargo = model.jyCargoDetails;

    if (indexPath.row == 0) {
        
        JYGrabValueTableViewCell *cell = [JYGrabValueTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([model.orderType isEqualToString:@"2"]) {
            cell.orderTypeImg.hidden = NO;
            cell.orderTypeImg.image = [UIImage imageNamed:@"order_labelling_gang"];

        }else{
            cell.orderTypeImg.hidden = YES;

        }
        if (model.timeType == 0) {

            cell.sendType.text = @"即时发货";
        }else{
          
            [cell setDateFromString:model.deliveryTime];

        }
        return cell;

//        JYGrabTableViewCellSecond *cell = [JYGrabTableViewCellSecond cellWithTableView:tableView];
//        cell.cityTypeLabel.hidden = YES;
//        cell.CityTimeLabel.hidden = YES;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;

    }else if (indexPath.row == 1){
        
        JYHomeGrabOrderTableViewCell *cell = [JYHomeGrabOrderTableViewCell cellWithTableView:tableView];
        [cell.grabBtn addTarget:self action:@selector(grabBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.grabBtn.tag = indexPath.section;
        cell.grabBtn.backgroundColor = BGBlue;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        JYGraSingleModel *model = self.homeOrderArr[indexPath.section];
        if ([model.orderType isEqualToString:@"2"]) {
            [cell.grabBtn setTitle:@"接单" forState:(UIControlStateNormal)];
        }else  if ([model.orderType isEqualToString:@"1"]) {
            [cell.grabBtn setTitle:@"估价" forState:(UIControlStateNormal)];
        }
        cell.startAddress.text = model.originatingSite;
        cell.endAddress.text = model.destination;
        [cell.grabBtn rounded:40];
        return cell;

    }else if (indexPath.row == 2){
        
        NSString *name = [dicCargo objectForKey:@"name"];
        NSString *amount = [dicCargo objectForKey:@"amount"];
        NSString *weight = [dicCargo objectForKey:@"weight"];

        cellThird.nameLabel.text = [NSString stringWithFormat:@"名称： %@",name];
        cellThird.midLabel.text = [NSString stringWithFormat:@"重量： %@",weight];
        cellThird.lastLabel.text = [NSString stringWithFormat:@"数量： %@",amount];
        return cellThird;

    }else if (indexPath.row == 3){
        
        NSString *packing = [dicCargo objectForKey:@"packing"];
        NSString *volume = [dicCargo objectForKey:@"volume"];

        cellThird.nameLabel.text = [NSString stringWithFormat:@"体积： %@",volume];
        cellThird.midLabel.text = [NSString stringWithFormat:@"包装： %@",packing];
        
        NSString *isInsureStr = model.isInsure;
        int isInsureNum = [isInsureStr intValue];
        if (isInsureNum == 1) {
            cellThird.midLabel.textColor = BGBlue;
            cellThird.lastLabel.text = @"已投保";
            
        }else{
            
            cellThird.lastLabel.text = @"";
            
        }
        return cellThird;
        
    }else{
        JYGrabServiceTableViewCell *cell = [JYGrabServiceTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        JYGraSingleModel *model = self.homeOrderArr[indexPath.section];

        [cell layoutServiceView:model.serviceDetails];
        return cell;
    }
    
  
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    contenView.backgroundColor = BgColorOfUIView;
    return contenView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 9;
}
- (void)grabBtnClick:(UIButton *)btn{
    JYHomeRequestDate *manager = [JYHomeRequestDate shareInstance];
    manager.delegate = self;
    JYGraSingleModel *model = self.homeOrderArr[btn.tag];
    _btnTag = btn.tag;
    
    [manager requsetGrabOrders:@"app/logisticsorder/grabOrder" phone:userPhone_Log orderId:model.id];
    
}
- (void)requestGrabOrderSuccess:(NSDictionary *)resultDic{
    
    NSString *message = [resultDic objectForKey:@"message"];
    NSString *SUCCESS = [resultDic objectForKey:@"SUCCESS"];
    if (SUCCESS) {
       
        JYGraSingleModel *model = self.homeOrderArr[_btnTag];
        JYWaitingForValuationVC *vc = [[JYWaitingForValuationVC alloc] init];
        vc.orderId = model.id;
        
        if ([model.orderType isEqualToString:@"2"]) {
            
            JYOrderDetailViewController *detaileVC = [[JYOrderDetailViewController alloc] init];
            detaileVC.orderID = model.id;
            [self.navigationController pushViewController:detaileVC animated:YES];

        }else{
            
            [self.navigationController pushViewController:vc animated:YES];

        }
        


    }else{
        
        if ([message isEqualToString:@"410"]) {
            
        }else if ([message isEqualToString:@"404"]){
            
        }else{
            
        }
        

    }

}

- (void)requestGrabOrderFailed:(NSError *)error{
    
    
}
@end
