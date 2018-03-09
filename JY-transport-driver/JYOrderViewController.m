//
//  JYOrderViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYOrderViewController.h"

#import "DLTabedSlideView.h"
#import "DLFixedTabbarView.h"

#import "JYBaseOrderViewController.h"
#import "JYSearchOrderViewController.h"
@interface JYOrderViewController ()<DLTabedSlideViewDelegate>
@property(nonatomic,strong)DLTabedSlideView *tabedSlideView;
@property(nonatomic,strong)NSArray *titles;
@property (nonatomic,assign)NSInteger index;

@property (nonatomic, strong) NSMutableDictionary *cacheVCDataDic;//用户缓存控制器的数据，防止多次每次都请求


@end

@implementation JYOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font size:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];

    _index = 0;

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addRight_ItemWithIcon:@"icon_sousuo" highIcon:@"icon_sousuo" target:self action:@selector(searchClick)];
   
 
    self.titles=@[@"进行中",@"已完成",@"已取消"];
    [self initSubView];
    
}

- (void)searchClick{
    
    JYSearchOrderViewController *vc = [[JYSearchOrderViewController alloc] init];
    if (_index == 0) {
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (_index == 1){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MultipleSelect" object:nil];

    }
   
}
- (NSMutableDictionary *)cacheVCDataArray {
    if(_cacheVCDataDic == nil) {
        _cacheVCDataDic = [[NSMutableDictionary alloc] init];
    }
    return _cacheVCDataDic;
}



- (void)initSubView
{
    self.tabedSlideView=[[DLTabedSlideView alloc]init];
    _tabedSlideView.delegate = self;
    _tabedSlideView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:_tabedSlideView];
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.backgroundColor = [UIColor whiteColor];

    self.tabedSlideView.tabItemNormalColor = [UIColor colorWithHexString:@"#333333"];
    self.tabedSlideView.tabItemSelectedColor=[UIColor colorWithHexString:@"#00A4FF"];
    self.tabedSlideView.tabbarTrackColor = [UIColor colorWithHexString:@"#00A4FF"];

    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i <self.titles.count; i++) {
        DLTabedbarItem *item = [DLTabedbarItem itemWithTitle:_titles[i] image:nil selectedImage:nil];
        
        [array addObject:item];
    }
    self.tabedSlideView.tabbarItems = array;
    [self.tabedSlideView buildTabbar];
    self.tabedSlideView.selectedIndex=0;
}

-(NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender
{
    
    return _titles.count;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabedSlideView.selectedIndex = _index;
}
-(UIViewController* )DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index
{
    
    JYBaseOrderViewController *orderVC = [[JYBaseOrderViewController alloc]init];
    orderVC.index = index;
    _index = index;
    return orderVC;
    
}


- (void)DLTabedSlideView:(DLTabedSlideView *)sender didSelectedAt:(NSInteger)index{
    
    _index = index;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
