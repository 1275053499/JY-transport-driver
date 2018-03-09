//
//  CustomTabBarViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/20.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "CustomNavigationViewController.h"
#import "CustomButton.h"
#import "HomePageViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"
#import "JYFavorableViewController.h"
@interface CustomTabBarViewController ()

//
//  JYCustomTabBarViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

@end

@implementation CustomTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BGBlue;
    
    [self createViewControllers];
    self.selectedIndex = 0;
    
}

- (void)createViewControllers
{
    HomePageViewController *homePageViewController = [[HomePageViewController alloc] init];
    CustomNavigationViewController *homePageNavigationController = [[CustomNavigationViewController alloc] initWithRootViewController:homePageViewController];
    homePageNavigationController.delegate = self;
    
    MessageViewController *messageViewController = [[MessageViewController alloc] init];
    CustomNavigationViewController *messageNavigationController = [[CustomNavigationViewController alloc] initWithRootViewController:messageViewController];
    messageNavigationController.delegate = self;
    
    JYFavorableViewController *favorableViewController = [[JYFavorableViewController alloc] init];
    CustomNavigationViewController *favorableNavigationController = [[CustomNavigationViewController alloc] initWithRootViewController:favorableViewController];
    favorableNavigationController.delegate = self;
    
    MineViewController *mineViewController = [[MineViewController alloc] init];
    CustomNavigationViewController *mineNavigationController = [[CustomNavigationViewController alloc] initWithRootViewController:mineViewController];
    mineNavigationController.delegate = self;

    
    homePageNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tab_icon_receiptlist_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homePageNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_icon_receiptlist_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    messageNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tab_icon_order_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
- (UIImage *)scaleImageToSize:(UIImage* )img size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
