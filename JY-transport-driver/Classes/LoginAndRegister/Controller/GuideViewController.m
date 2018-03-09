//
//  GuideViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/20.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "GuideViewController.h"
#import "CustomTabBarViewController.h"
#import "JYCustomTabBarViewController.h"
@interface GuideViewController ()<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
//    NSTimer *timer;
    UIButton *loginButton;
    UIButton *jumpButton;
    NSInteger imageCount;
    NSArray *imageArray;
    UIImageView *pageView;
    
}
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageArray = @[@"Guidepage1",@"Guidepage2",@"Guidepage3",@"Guidepage4"];
    imageCount = imageArray.count;
    [self initSubviews];
    // Do any additional setup after loading the view from its nib.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        
    }
    return self;
}

-(void)initSubviews
{
    //循环滚动
    
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    scrollView.pagingEnabled=YES;
    scrollView.bounces=YES;
    scrollView.backgroundColor=[UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    pageView = [[UIImageView alloc] init];
    pageView.image = [UIImage imageNamed:@"pagecontrol0"];
    pageView.frame = CGRectMake((scrollView.frame.size.width - 90)/2, scrollView.frame.size.height - 30, 90, 9);

    [self.view addSubview:pageView];
    
    
    _pageControl.pageIndicatorTintColor=[UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:223.0/255.0 green:48.0/255.0 blue:49.0/255.0 alpha:1.0];
    _pageControl.currentPage=0;
//    [self.view bringSubviewToFront:_pageControl];
    
    
    jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jumpButton.frame = CGRectMake(ScreenWidth - 60 - 15, 27, 55 * HOR_SCALE, 25);
    [jumpButton setTitle:@"跳过" forState:UIControlStateNormal];
    jumpButton.layer.cornerRadius = (jumpButton.frame.size.height)/2;
    jumpButton.layer.masksToBounds = YES;
//    jumpButton.layer.borderColor= BGBlue.CGColor;
//    jumpButton.layer.borderWidth= 0.5;

    jumpButton.titleLabel.font = [UIFont systemFontOfSize:15];
    jumpButton.backgroundColor = [UIColor whiteColor];
    jumpButton.hidden = NO;
    [jumpButton setTitleColor:BGBlue forState:(UIControlStateNormal)];
    [jumpButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpButton];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame=CGRectMake((ScreenWidth-280 * HOR_SCALE)/2, ScreenHeight- 60, 280 * HOR_SCALE, 40);
    [loginButton setTitle:@"立即体验" forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 20;
    loginButton.layer.masksToBounds = YES;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    loginButton.backgroundColor = [UIColor whiteColor];
    loginButton.hidden = YES;
    [loginButton setTitleColor:BGBlue forState:(UIControlStateNormal)];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    
    [self showImages];
}

-(void)showImages
{
    scrollView.contentSize=CGSizeMake(ScreenWidth*([imageArray count]), ScreenHeight-StateBarHeight);
    _pageControl.numberOfPages = imageCount;
    for (NSInteger i=0;i<[imageArray count];i++)
    {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenHeight)];
        imageView.image=ImageNamed([imageArray objectAtIndex:i]);
        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageView.contentMode =  UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageView.clipsToBounds  = YES;
        [scrollView addSubview:imageView];
    }
}
//
//-(void)autoScrollImage
//{
//    NSInteger currentPage=floor((scrollView.contentOffset.x-scrollView.frame.size.width/(imageCount+2))/scrollView.frame.size.width)+1;
//
//    if (currentPage==imageCount)
//    {
//        [scrollView scrollRectToVisible:CGRectMake(0, 0, ScreenWidth, ScreenHeight) animated:NO];
//        [scrollView scrollRectToVisible:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight) animated:YES];
//    }
//    else
//    {
//        float x = ScreenWidth*(currentPage+1);
//        [scrollView scrollRectToVisible:CGRectMake(x, 0, ScreenWidth, ScreenHeight) animated:YES];
//    }
//
//    NSInteger offsetIndex=scrollView.contentOffset.x/320;
//    if (offsetIndex==imageCount)
//    {
//        offsetIndex=0 ;
//    }
//    else if(offsetIndex==0)
//    {
//        offsetIndex=0 ;
//    }
//    _pageControl.currentPage = offsetIndex;
//    pageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pagecontrol%ld", (long)_pageControl.currentPage]];
//}

#pragma -mark UIScrollViewDelegate  代理

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    
    int currentPage = round(scrollView.contentOffset.x/ScreenWidth);
    pageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pagecontrol%ld",(long) currentPage]];
    if (currentPage == imageCount - 1) {
        loginButton.hidden = NO;
        jumpButton.hidden = YES;

    }else{
         loginButton.hidden = YES;
        jumpButton.hidden = NO;

        
    }


}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    if ([timer isValid])
//    {
//        [timer invalidate];
//        timer = nil;
//    }
}

//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)login:(id)sender
{
    
    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:UserLoginType];
        // 显示状态栏
        if ([type isEqualToString:@"2"]) {
            [UIApplication sharedApplication].statusBarHidden = NO;
            [UIApplication sharedApplication].keyWindow.rootViewController = [[CustomTabBarViewController alloc] init];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];

        }
        if ([type isEqualToString:@"3"]) {
            [UIApplication sharedApplication].statusBarHidden = NO;
            [UIApplication sharedApplication].keyWindow.rootViewController = [[JYCustomTabBarViewController alloc] init];
            
        }
    

    
}

- (void)dealloc{
    
//    [timer invalidate];
//    timer = nil;
}


@end
