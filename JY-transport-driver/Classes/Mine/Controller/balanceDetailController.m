//
//  balanceDetailController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/23.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "balanceDetailController.h"
#import "balanceDetailTableViewCell.h"
#import "balanceDetailModel.h"
#import "PaymentDetailsController.h"
@interface balanceDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation balanceDetailController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    page = 1;
    self.dataArr = [NSMutableArray array];
    self.navigationItem.title = @"全部";
    [self createTableView];
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    
    [self setupRefreshView];
}

-(void)setupRefreshView
{
    
    __weak __typeof(self) weakSelf = self;
    //上拉刷新新数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
        [self.tableView.mj_header beginRefreshing];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    //下拉加载更多数据
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreData];
        
    }];
}


-(void)loadNewData
{

    
    page = 1;
   
    if (self.balanceId == nil) {
        [self.tableView.mj_header endRefreshing];
         return;
    }
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/wallet/getWalletDetail"];
    

    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"belongto":self.balanceId,@"page":@"1"} success:^(id responseObj) {
        
        self.dataArr = [balanceDetailModel mj_objectArrayWithKeyValuesArray:responseObj];

        
        
        [self.tableView.mj_header endRefreshing];
        
        if (self.dataArr.count < 10) {
            
        
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
        
         
            [self.tableView.mj_footer resetNoMoreData];
            self.tableView.mj_footer.automaticallyHidden = YES;
    
            
        }
         [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showErrorMessage:@"网络异常"];
        
    }];
 }

//上拉加载旧数据
-(void)getMoreData
{
    page ++;
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/wallet/getWalletDetail"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"belongto":self.balanceId,@"page":[NSString stringWithFormat:@"%d",page]} success:^(id responseObj) {
        
      NSMutableArray *moreDataArr   = [balanceDetailModel mj_objectArrayWithKeyValuesArray:responseObj];
        
        [self.dataArr addObjectsFromArray:moreDataArr];
        
        
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        if (moreDataArr.count<10) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
            //self.tableView.mj_footer.hidden =YES;
        }
        
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showErrorMessage:@"网络异常"];
        
    }];
    
//    NSString *phoneNumber = userPhone;
//    [[NetWorkHelper shareInstance]Post:existURL parameter:@{@"phone":phoneNumber,@"latitude":@(self.location.coordinate.latitude),@"longitude":@(self.location.coordinate.longitude),@"page":[NSString stringWithFormat:@"%d",page]} success:^(id responseObj) {
//        
//        
//        if([[NSString stringWithFormat:@"%@",[[responseObj mj_JSONString] class]] isEqualToString:@"__NSCFString"]){
//            //user.name的json数据没有双引号，格式为_NSCFString
//            
//            
//            
//            
//            
//            [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
//                
//                [MBProgressHUD showError:@"暂无更多数据"];
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                
//            }];
//            
//            
//            
//        }else{
//            
//            
//            
//            NSMutableArray *dataArr = [ModelOrder mj_objectArrayWithKeyValuesArray:responseObj];
//            
//            [self.statusFrames addObjectsFromArray:dataArr];
//            
//            [self.tableView reloadData];
//            [self.tableView.mj_footer endRefreshing];
//            
//            
//            
//        }
//        
//    } failure:^(NSError *error) {
//        
//        [MBProgressHUD showError:@"网络异常" toView:self.view];
//        
//    }];
    
    
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
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.separatorColor = BgColorOfUIView;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight =63;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    balanceDetailTableViewCell *cell = [balanceDetailTableViewCell cellWithTableView:tableView];
    
    balanceDetailModel *model = self.dataArr[indexPath.row];
    cell.model = model;

    
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PaymentDetailsController *payVC = [[PaymentDetailsController alloc] init];
    payVC.balDetModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:payVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
