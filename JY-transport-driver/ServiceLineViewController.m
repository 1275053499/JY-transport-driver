//
//  ServiceLineViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/14.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "ServiceLineViewController.h"
#import "LoginViewController.h"
#import "JYLineTableViewCell.h"
#import "JYAddLineViewController.h"
#import "JYMineRequestData.h"
#import "CompanyModelInfo.h"
#import "JYLineModel.h"
#import "ClerkModel.h"
@interface ServiceLineViewController ()<UITableViewDelegate,UITableViewDataSource,JYMineRequestDataDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *lineArr;
@property (nonatomic,strong)NSString *UserType;
@property (nonatomic,strong)ClerkModel *clerkModel;
@end

@implementation ServiceLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.title = @"服务线路";
//    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnBackAction)];
    [self createTableView];
    NSString *login = [JYAccountTool loginType];
    if ([login isEqualToString:@"4"]) {
        
    }else{
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem addRight_ItemWithIcon:@"icon_tianjia" highIcon:@"icon_tianjia" target:self action:@selector(addLine)];
        
     
    }
   
    
      self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnBackAction)];
   
    UIView *botttomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 55, ScreenWidth, 55)];
    botttomView.backgroundColor = BgColorOfUIView;
    [self.view addSubview:botttomView];
    
    UIButton *finshEdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finshEdBtn.frame = CGRectMake((ScreenWidth - 200)/2, 5, 200, 45);
    finshEdBtn.layer.cornerRadius = 22.5;
    finshEdBtn.layer.masksToBounds = YES;
    [finshEdBtn setBackgroundColor:[UIColor colorWithHexString:@"#118ae7"]];
    [finshEdBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finshEdBtn addTarget:self action:@selector(finshEdBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [botttomView addSubview:finshEdBtn];

    [self initRefresh];
}
- (void)initRefresh{
    
    __weak __typeof(self) weakSelf = self;
    //上拉刷新新数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf queryAllServiceLine];
    }];
    [self.tableView.mj_header beginRefreshing];
        
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    _UserType = [JYAccountTool loginType];
    _clerkModel = [JYAccountTool getLogisticsclerkModelInfo];
    [self queryAllServiceLine];
    
}

- (void)queryAllServiceLine{
    CompanyModelInfo *model = [JYAccountTool getLogisticsModelInfo];
    JYMineRequestData *manager = [JYMineRequestData shareInstance];
    manager.delegate =self;
    if ([_UserType isEqualToString:@"4"]) {
       
        [manager requsetgetLogisticsbaranchListUrl:@"app/logisticsline/getLineByGroup" ID:_clerkModel.logisticsId];
    }else{
        
        [manager requsetgetLogisticsbaranchListUrl:@"app/logisticsline/getLineByGroup" ID:model.id];

    }
    

}
//查询服务路线列表
- (void)requestGetLogisticsbaranchListSuccess:(NSDictionary *)resultDic{
    _lineArr = [NSMutableArray array];

    self.lineArr = [JYLineModel mj_objectArrayWithKeyValuesArray:resultDic];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];

}
- (void)requestGetLogisticsbaranchListFailed:(NSError *)error{
    
    [self.tableView.mj_header endRefreshing];

}

-(void)createTableView
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 53;
}
- (void)addLine{
    
    JYAddLineViewController *addLine = [[JYAddLineViewController alloc] init];
    [self.navigationController pushViewController:addLine animated:YES];
}
- (void)finshEdBtnClick:(UIButton *)btn{
    
    LoginViewController *logIn = [[LoginViewController alloc] init];
    
    [self dismissViewControllerAnimated:logIn completion:nil];
}
- (void)returnBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.lineArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JYLineTableViewCell *cell = [JYLineTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.lineLabel.backgroundColor = [UIColor whiteColor];
    JYLineModel *model = self.lineArr[indexPath.section];
    cell.lineLabel.text = model.name;
    cell.lineLabel.font =  [UIFont fontWithName:Default_APP_Font_Reg size:18];
    cell.lineLabel.textColor = BGBlue;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth -14, 53) cornerRadius:2.0];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = cell.lineLabel.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    cell.lineLabel.layer.mask = maskLayer;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    v.backgroundColor = [UIColor clearColor];
    
    return v;
    
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
