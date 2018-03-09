//
//  JYMineViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYMineViewController.h"

#import "WalletViewController.h"
#import "travellingDetailViewController.h"
#import "SetViewController.h"
#import "CarFleetViewController.h"
#import "ScanViewController.h"
#import "JYMyiconTableViewCell.h"

#import "ServiceLineViewController.h"
#import "JYWalletViewController.h"
#import "JYMyOutletsViewController.h"
#import "JYPersonnelManagerViewController.h"
#import "JYEditCompanyInfoViewController.h"
#import "CompanyModelInfo.h"
#import <UIImageView+WebCache.h>
#import "ScanViewController.h"
#import "ClerkModel.h"
#import "MyiconImageView.h"
@interface JYMineViewController () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)CompanyModelInfo *companyModel;
@property (nonatomic,strong)ClerkModel *clerkModel;
@property (nonatomic,strong)NSString *UserType;
@property (nonatomic,strong)MyiconImageView *imageView;

@end

@implementation JYMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _companyModel = [JYAccountTool getLogisticsModelInfo];
    _UserType = [JYAccountTool loginType];
    _clerkModel = [JYAccountTool getLogisticsclerkModelInfo];
    self.navigationItem.title = @"我";

      [self createTableView];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:Default_APP_Font size:20]};
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addRight_ItemWithIcon:@"intercalate" highIcon:@"intercalate" target:self action:@selector(pop)];
  
    
}

- (void)pop
{
    SetViewController *setVC = [[SetViewController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    _companyModel = [JYAccountTool getLogisticsModelInfo];
    _UserType = [JYAccountTool loginType];
    _clerkModel = [JYAccountTool getLogisticsclerkModelInfo];
    if ([_UserType isEqualToString:@"4"]) {
        
        _imageView.clerkModel = _clerkModel;
        
    }else{
        
        _imageView.companyModel = _companyModel;
    }
    
    [_tableView reloadData];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;

}
- (void)viewWillDisappear:(BOOL)animated{
    
    //如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Guide"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = NO;
   
}

-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;

    [self.view addSubview:self.tableView];
    
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
    
    _imageView  = [[MyiconImageView alloc] initWithFrame:CGRectMake(0, -180, ScreenWidth, 180)];
    _imageView.tag = 101;
    [self.tableView addSubview:_imageView];
    _imageView.clipsToBounds = YES;//删除多余图片（第一行被遮盖)
    [_imageView.chooseIconBtn addTarget:self action:@selector(editorPersonInfo:) forControlEvents:(UIControlEventTouchUpInside)];
    

    if ([_UserType isEqualToString:@"4"]) {
        
        _imageView.clerkModel = _clerkModel;
        
    }else{
        
        _imageView.companyModel = _companyModel;
    }
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
    
    JYEditCompanyInfoViewController * editPersonaVC = [[JYEditCompanyInfoViewController alloc] init];
    editPersonaVC.ID = _companyModel.id;
    [self.navigationController pushViewController:editPersonaVC animated:YES];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if (section == 0){
    
        return 2;
    
    }else{
        if ([_UserType isEqualToString:@"4"]) {
            
            return 3;
        }else{
            return 5;

        }
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"userInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
    cell.textLabel.textColor = RGB(51, 51, 51);
    UIImageView *accessimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_jiantou2"]];
    cell.accessoryView = accessimg;


     if (indexPath.section == 0){
       
        if (indexPath.row == 0) {
            cell.imageView.image =[UIImage imageNamed:@"icon_qianbao"];
            cell.textLabel.text=@"我的钱包";
            
        }else{
            
            cell.imageView.image =[UIImage imageNamed:@"icon_youhuiquan"];
            cell.textLabel.text=@"优惠券";
            
        }
        
        return cell;
    }else{
        
        if (indexPath.row==0) {
            cell.imageView.image =[UIImage imageNamed:@"icon_fuwuluxian"];
            cell.textLabel.text=@"服务线路";
            
        }else if (indexPath.row==1){
            cell.imageView.image =[UIImage imageNamed:@"icon_wodewangdian"];
            cell.textLabel.text=@"我的网点";
            if ([_UserType isEqualToString:@"4"]) {
                cell.imageView.image =[UIImage imageNamed:@"icon_wode_saoma"];
                cell.textLabel.text=@"扫一扫";
            }
           

        }else if (indexPath.row==2){
            cell.imageView.image =[UIImage imageNamed:@"mine_icon_personnel"];
            cell.textLabel.text=@"人员管理";
            if ([_UserType isEqualToString:@"4"]) {
                cell.imageView.image =[UIImage imageNamed:@"icon_lianxikefu"];
                cell.textLabel.text=@"联系客服";
//                cell.separatorInset = UIEdgeInsetsMake(0, 0,0,ScreenWidth);


            }
           
        }else if (indexPath.row==3){
            
            cell.imageView.image =[UIImage imageNamed:@"icon_wode_saoma"];
            cell.textLabel.text=@"扫一扫";
        }else{
            
            cell.imageView.image =[UIImage imageNamed:@"icon_lianxikefu"];
            cell.textLabel.text=@"联系客服";
//            cell.separatorInset = UIEdgeInsetsMake(0, 0,0,ScreenWidth);



        }
        
        return cell;
    }
    
}
    


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;

    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    v.backgroundColor = BgColorOfUIView;
    
    return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    v.backgroundColor = BgColorOfUIView;
    
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==0) {
        return 0.001;
    }else{
        
        return 9;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0) {
            
               JYWalletViewController *wallVC = [[JYWalletViewController alloc] init];
               [self.navigationController pushViewController:wallVC animated:YES];
        
    }else{
        
        if (indexPath.row == 0) {
            ServiceLineViewController *ve = [[ServiceLineViewController alloc] init];
            [self.navigationController pushViewController:ve animated:YES];
        }else if(indexPath.row == 1){
            if ([_UserType isEqualToString:@"4"]) {
                ScanViewController *outVC = [[ScanViewController alloc] init];
                outVC.whitchVCFrom = @"JYMineViewController";
                [self.navigationController pushViewController:outVC animated:YES];

            }else{
                JYMyOutletsViewController *outVC = [[JYMyOutletsViewController alloc] init];
                [self.navigationController pushViewController:outVC animated:YES];
            }
            
        }else if(indexPath.row == 2){
            if ([_UserType isEqualToString:@"4"]) {
                [self presentAlertActionSheet];

            }else{
                JYPersonnelManagerViewController *outVC = [[JYPersonnelManagerViewController alloc] init];
                [self.navigationController pushViewController:outVC animated:YES];
            }
        }else if(indexPath.row == 3){
            ScanViewController *outVC = [[ScanViewController alloc] init];
            outVC.whitchVCFrom = @"JYMineViewController";
            [self.navigationController pushViewController:outVC animated:YES];
        }else{
            [self presentAlertActionSheet];
        }
        }
    
}

- (void)presentAlertActionSheet{
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *title = @"致电人工客服";
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"075521016380"];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        

        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [cameraAction setValue:RGBA(0, 118, 255, 1) forKey:@"titleTextColor"];
    [cancelAction setValue:RGBA(0, 118, 255, 1) forKey:@"titleTextColor"];
    

    [alert addAction:cameraAction];
    [alert addAction:cancelAction];
    
    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    
    if([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [super didReceiveMemoryWarning];
}




@end

