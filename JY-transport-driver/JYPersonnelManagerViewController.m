//
//  JYPersonnelManagerViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/29.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYPersonnelManagerViewController.h"
#import "JYPeopleTableViewCell.h"
#import "UIView+Extension.h"
#import "JYMineRequestData.h"
#import "CompanyModelInfo.h"
#import "JYAddPeopleViewController.h"
#import "JYPeopleModel.h"
@interface JYPersonnelManagerViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate,JYMineRequestDataDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *peopleArr;
@property (nonatomic, strong) NSMutableArray *results;
@end

@implementation JYPersonnelManagerViewController
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];

        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (NSMutableArray *)peopleArr {
    if (_peopleArr == nil) {
        _peopleArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _peopleArr;
}

- (NSMutableArray *)results {
    if (_results == nil) {
        _results = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _results;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addRight_ItemWithIcon:@"icon_tianjia" highIcon:@"icon_tianjia" target:self action:@selector(addPeople)];

    
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.view.backgroundColor = BgColorOfUIView;
    
    // 创建UISearchController, 这里使用当前控制器来展示结果
    UISearchController *search = [[UISearchController alloc]initWithSearchResultsController:nil];
    // 设置结果更新代理
    search.searchResultsUpdater = self;
    // 因为在当前控制器展示结果, 所以不需要这个透明视图
    search.dimsBackgroundDuringPresentation = NO;
    // 是否自动隐藏导航
//        search.hidesNavigationBarDuringPresentation = NO;
    self.searchController = search;
        self.definesPresentationContext = YES;

    // 将searchBar赋值给tableView的tableHeaderView
    self.tableView.tableHeaderView = search.searchBar;
    
    search.searchBar.delegate = self;
//    [self initRefresh];
}
//- (void)initRefresh{
//    
//    __weak __typeof(self) weakSelf = self;
//    //上拉刷新新数据
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        [weakSelf queryAllPeople];
//    }];
//    [self.tableView.mj_header beginRefreshing];
    //下拉加载更多数据
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        
//        
//    }];
    
//    self.tableView.mj_footer.automaticallyHidden = YES;
    
//}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self queryAllPeople];
    
}

- (void)queryAllPeople{
    
    CompanyModelInfo *model = [JYAccountTool getLogisticsModelInfo];
    JYMineRequestData *manager = [JYMineRequestData shareInstance];
    manager.delegate = self;
    [manager requsetgetLogisticsbaranchListUrl:@"app/logisticsclerk/getListByGroup" ID:model.id];
    
}

- (void)requestGetLogisticsbaranchListSuccess:(NSDictionary *)resultDic{
      
        self.peopleArr = [JYPeopleModel mj_objectArrayWithKeyValuesArray:resultDic];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];

}

- (void)requestGetLogisticsbaranchListFailed:(NSError *)error{
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];

}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addPeople{
    
    JYAddPeopleViewController *vc =[[JYAddPeopleViewController alloc] init];
    vc.idetor = @"addPeople";
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active) {
        
        return self.results.count ;
    }
    
    return self.peopleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JYPeopleTableViewCell *cell = [JYPeopleTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
   JYPeopleModel *peoplemodel = self.peopleArr[indexPath.section];
    cell.name.text = peoplemodel.name;
    cell.phone.text = peoplemodel.phone;
    cell.outlets.text = peoplemodel.branchName;
    cell.role.text = peoplemodel.role;
    cell.idetorBtn.tag = indexPath.section;
    [cell.idetorBtn addTarget:self action:@selector(idetorBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active ) {
        
         return cell;
    } else {
       
    }
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchController.active) {
        NSLog(@"选择了搜索结果中的%@", [self.results objectAtIndex:indexPath.row]);
    } else {
        
        NSLog(@"选择了列表中的%@", [self.peopleArr objectAtIndex:indexPath.row]);
    }
    
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
//    NSString *inputStr = searchController.searchBar.text ;
//    if (self.results.count > 0) {
//        [self.results removeAllObjects];
//    }
//    for (NSString *str in self.peopleArr) {
//        
//        if ([str.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
//            
//            [self.results addObject:str];
//        }
//    }
    
    [self.tableView reloadData];
}


- (void)idetorBtnClick:(UIButton *)btn{
    
    JYAddPeopleViewController *vc =[[JYAddPeopleViewController alloc] init];
    vc.idetor = @"idetorPeople";
    vc.peoplemodel = self.peopleArr[btn.tag];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
