//
//  MessageViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/20.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "MessageViewController.h"
#import "DLTabedSlideView.h"
#import "DLFixedTabbarView.h"
#import "BaseOrderViewController.h"

#import "SearchOrderView.h"
#import "SearchLookCarOrderVC.h"


@interface MessageViewController ()<DLTabedSlideViewDelegate>
@property(nonatomic,strong)DLTabedSlideView *tabedSlideView;
@property(nonatomic,strong)NSArray *titles;
@property (nonatomic,assign)NSInteger index;

@property (nonatomic, strong) NSMutableDictionary *cacheVCDataDic;//用户缓存控制器的数据，防止多次每次都请求
@property (nonatomic,strong)SearchOrderView *searchView;

@end

@implementation MessageViewController


- (NSMutableDictionary *)cacheVCDataArray {
    if(_cacheVCDataDic == nil) {
        _cacheVCDataDic = [[NSMutableDictionary alloc] init];
    }
    return _cacheVCDataDic;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单";
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
    self.titles=@[@"进行中",@"已完成",@"已取消"];
    [self initSubView];
    
    // 2.加载数据
}

- (void)willChangeStatusBarFrameNotification:(NSNotification *)nottfication{
    
    
    if ([UIApplication sharedApplication].statusBarFrame.size.height >20) {
        
        _searchView.frame  = CGRectMake(0,StateBarHeight, ScreenWidth, ScreenHeight - StateBarHeight );
    }else{
        _searchView.frame  =CGRectMake(0,0, ScreenWidth, ScreenHeight);
        
    }
    
}

- (void)searchClick{
    
    if (_index == 1) {
        _searchView  = [[SearchOrderView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight) viewController:self];
        
        if ([UIApplication sharedApplication].statusBarFrame.size.height >20) {
            
            _searchView  = [[SearchOrderView alloc] initWithFrame:CGRectMake(0,StateBarHeight, ScreenWidth, ScreenHeight - StateBarHeight ) viewController:self];
        }
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_searchView];
    }
}

- (void)initSubView
{
    self.tabedSlideView=[[DLTabedSlideView alloc]init];
    _tabedSlideView.delegate = self;
    _tabedSlideView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:_tabedSlideView];
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.tabItemNormalColor = RGB(153, 153, 153);
    self.tabedSlideView.tabItemSelectedColor = BGBlue;
    self.tabedSlideView.backgroundColor = [UIColor whiteColor];
    self.tabedSlideView.tabbarTrackColor = BGBlue;
    

    NSMutableArray *array=[NSMutableArray array];
    for (int i = 0; i <self.titles.count; i++) {
        DLTabedbarItem *item=[DLTabedbarItem itemWithTitle:_titles[i] image:nil selectedImage:nil];
        [array addObject:item];
    }
    self.tabedSlideView.tabbarItems=array;
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
    
    BaseOrderViewController *orderVC = [[BaseOrderViewController alloc]init];
    orderVC.index = index;
    return orderVC;
    

}
- (void)DLTabedSlideView:(DLTabedSlideView *)sender didSelectedAt:(NSInteger)index{
    
    _index = index;
    [self changeNavigationItem];
}

- (void)changeNavigationItem{
    
    if (_index == 0) {
        self.navigationItem.rightBarButtonItem = nil;

    }else if (_index == 1){
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem addRight_ItemWithIcon:@"order_icon_screening" highIcon:@"order_icon_screening" target:self action:@selector(searchClick)];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
