//
//  JYCustomTabBarViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYCustomTabBarViewController.h"
#import "CustomButton.h"
#import "JYHomePageViewController.h"
#import "JYOrderViewController.h"
#import "JYMineViewController.h"
#import "JYCustomNavigationViewController.h"
#import "JYFavorableViewController.h"
#import "JYPersonHomeViewController.h"
@interface JYCustomTabBarViewController ()
@property (nonatomic,strong)NSString *loginType;

@end

@implementation JYCustomTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _loginType = [[NSUserDefaults standardUserDefaults] objectForKey:UserLoginType];
    [self createViewControllers];
     self.selectedIndex = 0;
    
}

- (void)createViewControllers
{

    UINavigationController *homePageNavigationController;
    
    if ([_loginType isEqualToString:@"5"]) {
        
        JYPersonHomeViewController *homePageViewController = [[JYPersonHomeViewController alloc] init];
        homePageNavigationController = [[JYCustomNavigationViewController alloc] initWithRootViewController:homePageViewController];

        
    }else if ([_loginType isEqualToString:@"3"] || [_loginType isEqualToString:@"4"]){
        
        JYHomePageViewController *homePageViewController = [[JYHomePageViewController alloc] init];
        
          homePageNavigationController = [[JYCustomNavigationViewController alloc] initWithRootViewController:homePageViewController];
    }
    
  
    
    homePageNavigationController.delegate = self;

    
    JYOrderViewController *messageViewController = [[JYOrderViewController alloc] init];
    UINavigationController *messageNavigationController = [[JYCustomNavigationViewController alloc] initWithRootViewController:messageViewController];
    messageNavigationController.delegate = self;
    
    JYFavorableViewController *favorableViewController = [[JYFavorableViewController alloc] init];
    UINavigationController *favorableNavigationController = [[JYCustomNavigationViewController   alloc] initWithRootViewController:favorableViewController];
    favorableNavigationController.delegate = self;
    
    JYMineViewController *mineViewController = [[JYMineViewController alloc] init];
    UINavigationController *mineNavigationController = [[JYCustomNavigationViewController alloc] initWithRootViewController:mineViewController];
    mineNavigationController.delegate = self;
    
    homePageNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tab_icon_receiptlist_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homePageNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_icon_receiptlist_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    messageNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tab_icon_order_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_icon_order_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    favorableNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tab_icon_activity_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    favorableNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_icon_activity_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    mineNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tab_icon_mine_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_icon_mine_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    

    homePageNavigationController.tabBarItem.title = @"首页";
    messageNavigationController.tabBarItem.title = @"订单";
    mineNavigationController.tabBarItem.title = @"我的";
    favorableNavigationController.tabBarItem.title = @"活动";
    //改变tabbarController 文字选中颜色(默认渲染为蓝色)

    
   [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:RGB(196, 196, 196)} forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:BGBlue} forState:UIControlStateSelected];

    
    //创建一个数组包含四个导航栏控制器
    NSArray *vcArry = [NSArray arrayWithObjects:homePageNavigationController,messageNavigationController,favorableNavigationController,mineNavigationController,nil];
    
    //将数组传给UITabBarController
    self.viewControllers = vcArry;
    
    for (UITabBarItem *item in self.tabBar.items) {
        item.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);

    }
    for (UITabBarItem *item in self.tabBar.items) {
        [item setTitlePositionAdjustment:UIOffsetMake(0, -2)];
        
    }

}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)newOrder:(NSNotification *)notification{
    
    
    
    id  vc =  [self presentingVC];
//    if () {
//        
//    }else{
//        [self presentTipForNewOrder];
//        
//    }
    
}

//获取到当前所在的视图
- (UIViewController *)presentingVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[JYCustomTabBarViewController class]]) {
        result = [(JYCustomTabBarViewController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}
- (void)presentTipForNewOrder{
    
    NSString *message = @"客户已经确定出价，开始服务吧";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@" " message:message preferredStyle: UIAlertControllerStyleAlert];
    
    //修改标题的内容，字号，颜色。使用的key值是“attributedTitle”
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:message];
    [hogan addAttribute:NSFontAttributeName value: [UIFont fontWithName:Default_APP_Font_Reg size:17] range:NSMakeRange(0, [[hogan string] length])];
    [hogan addAttribute:NSForegroundColorAttributeName value:RGB(3, 3, 3) range:NSMakeRange(0, [[hogan string] length])];
    [alert setValue:hogan forKey:@"attributedMessage"];
    
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureaction = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alert addAction:cancelaction];
    [alert addAction:sureaction];
    
    
    [self presentViewController:alert animated:true completion:nil];
}

@end
