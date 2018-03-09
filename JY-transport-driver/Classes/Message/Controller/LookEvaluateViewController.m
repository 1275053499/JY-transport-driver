//
//  LookEvaluateViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/19.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "LookEvaluateViewController.h"
#import "LookEvaluteTableViewCell.h"
#import "LookEvaluteTableViewCellOne.h"

#import "EvaluateModel.h"
@interface LookEvaluateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *evaluateDatas;
@property (nonatomic,strong)NSDictionary *dicData;
@end

@implementation LookEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.title = @"评价";
    
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    _evaluateDatas = [NSMutableArray array];
    [self creatTableView];
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)creatTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 115.0f;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值

    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self addRefreshView];
    

    
}

- (void)addRefreshView{
    
    __weak typeof(self) weakSelf = self;
    //默认block方法：设置下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requsetData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
//    默认block方法：设置上拉加载更多
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//       
//        
//   }];
    
}
- (void)requsetData{
    
   
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:@"app/truckevuser/getEvList"];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"evObject":self.reqApplicant} success:^(id responseObj) {
        
        NSString *code = [responseObj objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {

            NSArray *result = [responseObj objectForKey:@"result"];
            
      
        self.evaluateDatas = [EvaluateModel mj_objectArrayWithKeyValuesArray:result];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
            
        }
       
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];

    }];
    
}

- (void)requestDataForDriverEvaluateSuccess:(NSDictionary *)resultDic{
    
    self.dicData = resultDic;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)requestDataForDriverEvaluateFailed:(NSError *)error{
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    return self.evaluateDatas.count;
   

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
   
    LookEvaluteTableViewCell *cell =[LookEvaluteTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    cell.evaluateodel = self.evaluateDatas[indexPath.row];
    
    return cell;
      
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
