//
//  JYCustomNavigationViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYCustomNavigationViewController.h"

@interface JYCustomNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation JYCustomNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置手势识别器的代理
    __weak __typeof(self) weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  第一次使用这个类的时候会调用(1个类只会调用1次)
 */
+ (void)initialize
{
    // 1.设置导航栏主题
    [self setupNavBarTheme];
    
    // 2.设置导航栏按钮主题
    [self setupBarButtonItemTheme];
}
/**
 *  设置导航栏按钮主题
 */
+ (void)setupBarButtonItemTheme
{
    
    UINavigationBar *appearance = [UINavigationBar appearance];
    //设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    //去除阴影
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs];
}

/**
 *  设置导航栏主题
 */
+ (void)setupNavBarTheme
{
    
    //通过appearance对象能修改整个项目中所有的UIBarButtonItem样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    //普通状态
    NSMutableDictionary *testAttrs = [NSMutableDictionary dictionary];
    testAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    testAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    //去除阴影
    //testAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:testAttrs forState:UIControlStateNormal];
    
    //不可用状态
    NSMutableDictionary *disaTestAttrs = [NSMutableDictionary dictionaryWithDictionary:testAttrs];
    disaTestAttrs[NSForegroundColorAttributeName] = RGB(0, 100, 255);
    [appearance setTitleTextAttributes:disaTestAttrs forState:UIControlStateDisabled];
    
    
    //设置背景
    [appearance setBackButtonBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    // 取出appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 设置背景
    [navBar setBackgroundImage:[UIImage imageNamed:@"Guide"] forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  

    
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark------工具方法-----------
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
//push的时候判断到子控制器的数量。当大于零时隐藏BottomBar 也就是UITabBarController 的tababar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.viewControllers.count>0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        // 设置导航栏按钮
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"btn-01-n" highIcon:@"btn-01-n" target:self action:@selector(back)];
        
    }
    [super pushViewController:viewController animated:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 手势何时有效 : 当导航控制器的子控制器个数 > 1就有效
    return self.childViewControllers.count > 1;
}


- (void)back
{
    [self popViewControllerAnimated:YES];
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
