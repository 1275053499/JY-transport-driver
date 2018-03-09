//
//  MineViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/20.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "MineViewController.h"
#import "WalletViewController.h"
#import "travellingDetailViewController.h"
#import "SetViewController.h"
#import "CarFleetViewController.h"
#import "EditPersonalInfoVC.h"
#import "driverInfoModel.h"
#import <UIImageView+WebCache.h>

#import "JYMyiconTableViewCell.h"
#import "MyiconImageView.h"
#import "MineTableViewCell.h"



@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)driverInfoModel *drivModel;
@property (nonatomic,strong)MyiconImageView *imageView;
//@property (nonatomic,strong)UIButton *rightItem;


@end

@implementation MineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupNavBar];
    _drivModel = [JYAccountTool getDriverInfoModelInfo];

    self.navigationItem.title = @"我的";
    [self createTableView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatBtnItem];
}

/**
 *   设置导航栏的内容
 */
-(void)setupNavBar
{
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addRight_ItemWithIcon:@"intercalate" highIcon:@"intercalate" target:self action:@selector(intercalate)];
}
- (void)intercalate
{
    SetViewController *setVC = [[SetViewController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
}

-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //[self CreatHeaderView];
    
    self.tableView.scrollEnabled = YES;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
    _imageView  = [[MyiconImageView alloc] initWithFrame:CGRectMake(0, -180, ScreenWidth, 180)];
    
    _imageView.tag = 101;
    _imageView.drivModel = _drivModel;
    [self.tableView addSubview:_imageView];
    _imageView.clipsToBounds = YES;//删除多余图片（第一行被遮盖)
    [_imageView.chooseIconBtn addTarget:self action:@selector(editorPersonInfo:) forControlEvents:(UIControlEventTouchUpInside)];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.y < -180) {
        CGRect rect = [self.tableView viewWithTag:101].frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        [self.tableView viewWithTag:101].frame = rect;
    }
    
}

- (void)editorPersonInfo:(UIButton *)btn{
    
    EditPersonalInfoVC * editPersonaVC = [[EditPersonalInfoVC alloc] init];
    [self.navigationController pushViewController:editPersonaVC animated:YES];

}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:[viewController isKindOfClass:[self class]] animated:YES];
}

- (void)creatBtnItem{

    UIButton *rightItem = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightItem.frame = CGRectMake(ScreenWidth - 44 -8 , StateBarHeight + NavigationBarHeight / 2 - 44/2, 44, 44);
    [rightItem setImage:[UIImage imageNamed:@"intercalate"] forState:(UIControlStateNormal)];
    [rightItem setImage:[UIImage imageNamed:@"intercalate"] forState:(UIControlStateHighlighted)];

    [rightItem addTarget:self action:@selector(intercalate) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rightItem];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:Default_APP_Font size:20];
    titleLabel.text = @"我的";
    titleLabel.frame = CGRectMake((ScreenWidth - 100)/2,StateBarHeight + NavigationBarHeight / 2 - 22/2 , 100, 22);

    [self.view addSubview:titleLabel];

}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    _drivModel = [JYAccountTool getDriverInfoModelInfo];
    _imageView.drivModel = _drivModel;
    [_tableView reloadData];
    
    if (self.tabBarController.selectedIndex == 3) {//此处避免minevc 因为下面动画抖动，不用动画会有bug
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
    }else{
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
    }


}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
        
    }else if (section == 1){
        
        return 1;
    }else{
        
        return 1;
        
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MineTableViewCell *cell = [MineTableViewCell cellWithTableView:tableView];
    cell.nameLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
    cell.nameLabel.textColor = RGB(51, 51, 51);
    cell.accessoryImg.image = [UIImage imageNamed:@"icon_jiantou2"];
    
    if (indexPath.section == 0){
        
        cell.imgView.image =[UIImage imageNamed:@"icon_qianbao"];
        cell.nameLabel.text=@"我的钱包";
        
    }else if(indexPath.section == 1){
        
        cell.imgView.image =[UIImage imageNamed:@"icon_lufeixiangqing"];
        cell.nameLabel.text=@"路费详情";
        
        
    }else{
        
        cell.imgView.image =[UIImage imageNamed:@"icon_lianxikefu"];
        cell.nameLabel.text=@"联系客服";
        cell.lineView.hidden = YES;
        
    }
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==0) {
        return 0.001;
    }else{
        
        return 9;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    view.backgroundColor = BgColorOfUIView;
    
    return view;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    view.backgroundColor = BgColorOfUIView;
    
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.001;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        
        WalletViewController *walletVC = [[WalletViewController alloc]init];
        [self.navigationController pushViewController:walletVC animated:YES];
        
    }else if(indexPath.section == 1){
        
        
        travellingDetailViewController *baseVC = [[travellingDetailViewController alloc]init];
        [self.navigationController pushViewController:baseVC animated:YES];
        
        
    }else{
        
        [self presentAlertActionSheet];
    }
    
}

- (void)presentAlertActionSheet{
    
    
    
    //            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"075521016380"];
    //            UIWebView *callWebview = [[UIWebView alloc] init];
    //            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    //            [self.view addSubview:callWebview];
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", @"075521016380"];
    
    if (IOS_VERSION >= 10.0) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        
    } else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    
    if([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [super didReceiveMemoryWarning];
}


@end
