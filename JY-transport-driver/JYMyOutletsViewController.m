//
//  JYMyOutletsViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/29.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYMyOutletsViewController.h"
#import "JYMyOutletsTableViewCellSecond.h"
#import "UIView+Extension.h"
#import "JYaddOutletsViewController.h"
#import "JYMineRequestData.h"
#import "CompanyModelInfo.h"
#import "JYOutletsModel.h"
@interface JYMyOutletsViewController ()<UITableViewDelegate,UITableViewDataSource,JYMineRequestDataDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *outletesaArr;

@end

@implementation JYMyOutletsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addRight_ItemWithIcon:@"icon_tianjia" highIcon:@"icon_tianjia" target:self action:@selector(addOutlets)];
   
        self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    
    [self createTableView];
}

- (void)addOutlets
{   JYaddOutletsViewController *vc =[[JYaddOutletsViewController alloc] init];
    vc.idetor = @"addOutlets";
    [self.navigationController pushViewController:vc animated:YES];
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
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(8,0, ScreenWidth - 16, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    

}
- (void)viewWillAppear:(BOOL)animated{
    
    [self initRefresh];
}
- (void)initRefresh{
    
    __weak __typeof(self) weakSelf = self;
    //上拉刷新新数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf queryOutletsList];
    }];
    [self.tableView.mj_header beginRefreshing];
    //下拉加载更多数据
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    
//        [weakSelf getMoreOutletsList];
        
//    }];
//    self.tableView.mj_footer.automaticallyHidden = YES;

}
- (void)queryOutletsList{
    
    CompanyModelInfo *mode = [JYAccountTool getLogisticsModelInfo];
    JYMineRequestData *manager = [JYMineRequestData shareInstance];
    manager.delegate = self;
    [manager requsetgetLogisticsbaranchListUrl:@"app/logisticsbaranch/getLogisticsbaranchList" ID:mode.id];
    
}
- (void)getMoreOutletsList{
    
//    [self.tableView.mj_footer endRefreshingWithNoMoreData];

}

- (void)requestGetLogisticsbaranchListSuccess:(NSDictionary *)resultDic{
    
    self.outletesaArr = [JYOutletsModel mj_objectArrayWithKeyValuesArray:resultDic];
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];


}

- (void)requestGetLogisticsbaranchListFailed:(NSError *)error{
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.outletesaArr.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    return 120;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
    JYMyOutletsTableViewCellSecond *cell = [JYMyOutletsTableViewCellSecond cellWithTableView:tableView];
    
    if ([_whichVCPush isEqualToString:@"JYAddPeopleViewController"]) {
        cell.selectionStyle =  UITableViewCellSelectionStyleDefault;
    }else{
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        JYOutletsModel *model = _outletesaArr[indexPath.section];
        cell.nameLabel.text = model.address;
        cell.telPhoneLabel.text = model.landline;
    
        cell.idetorBtn.tag = indexPath.section;
        [cell.idetorBtn addTarget:self action:@selector(idetorBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.outletsName.text = model.name;


        return cell;

    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
           return 9;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_whichVCPush isEqualToString:@"JYAddPeopleViewController"]) {
        
        JYOutletsModel *model = _outletesaArr[indexPath.section];
        if ([self.delegate respondsToSelector:@selector(chooseOurletsForAddPeople:)]) {
            
            [self.delegate chooseOurletsForAddPeople:model];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}
- (void)idetorBtnClick:(UIButton *)btn{
    
    JYaddOutletsViewController *vc =[[JYaddOutletsViewController alloc] init];
    vc.idetor = @"idetor";
    JYOutletsModel *model = _outletesaArr[btn.tag];

    vc.outLetsModel = model;
    [self.navigationController pushViewController:vc animated:YES];
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
