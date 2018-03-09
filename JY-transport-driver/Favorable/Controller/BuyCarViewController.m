//
//  BuyCarViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/12/14.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "BuyCarViewController.h"
#import "BuyCarView.h"
#import "BuyCarWriteInfoViewController.h"

@interface BuyCarViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)BuyCarView *leftbuyCarView;
@property (nonatomic,strong)BuyCarView *currentbuyCarView;
@property (nonatomic,strong)BuyCarView *rightbuyCarView;
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,assign)NSInteger imgCount;
@property (nonatomic,strong)NSArray *array;
@property (nonatomic,strong)NSArray *nameArr;
@property (nonatomic,strong)UILabel *pageLabel;
@property (nonatomic,strong)NSArray *carTypeArr;

@end

@implementation BuyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.title = @"选择车型";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    
    _currentIndex = 0;
    _nameArr = @[@"依维柯",@"大型面包车",@"微型货车",@"小型货车",@"平板车"];
    _array = @[@"Car_Iveco",@"Car_BigVan",@"Car_MiniTruck",@"Car_SmallTruck",@"Car_modelcar"];
    _imgCount = _array.count;
//    _carTypeArr = @[@"MINIVAN",@"IVECO",@"SMALLTRUCK",@"MEDIUMTRUCK"];
    
    [self creatScrollView];
    [self initImages];
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)creatScrollView{
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight - 36 * HOR_SCALE);
    self.scrollView.backgroundColor = BgColorOfUIView;
    _scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * 3,0);
    self.scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    [self.view addSubview:self.scrollView];
    
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _scrollView.frame.size.height + 2 , 60, 20)];
    _pageLabel.text = @"1/5";
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    _pageLabel.centerX = self.view.centerX;
    _pageLabel.textColor = RGB(153, 153, 153);
    [self.view addSubview:_pageLabel];
    
    UIButton *leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [leftBtn setImage:[UIImage imageNamed:@"icon_lastone"] forState:(UIControlStateNormal)];
    leftBtn.tag = 3018;
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    leftBtn.frame = CGRectMake(15, 210 *HOR_SCALE, 44, 44);
    [self.view addSubview:leftBtn];
    _leftBtn = leftBtn;

    UIButton *rightBtn  = [FMButton buttonWithType:(UIButtonTypeCustom)];
    [rightBtn setImage:[UIImage imageNamed:@"icon_next"] forState:(UIControlStateNormal)];
    [rightBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    rightBtn.frame = CGRectMake(ScreenWidth - 15 - 44,  210 *HOR_SCALE, 44, 44);

    rightBtn.tag = 3019;
    _rightBtn = rightBtn;
    [self.view addSubview:_rightBtn];
    
    
    CGFloat height = _scrollView.frame.size.height;
    _leftbuyCarView = [[BuyCarView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    _currentbuyCarView = [[BuyCarView alloc] initWithFrame:CGRectMake(ScreenWidth, 0,ScreenWidth,height)];
    
    _rightbuyCarView = [[BuyCarView alloc] initWithFrame:CGRectMake(ScreenWidth *2 , 0, ScreenWidth,height)];
    __weak __typeof(self) weakSelf = self;
    _currentbuyCarView.BuyCarBlock = ^(NSString *str){
        
        BuyCarWriteInfoViewController *vc = [[BuyCarWriteInfoViewController alloc] init];
        vc.carType = weakSelf.carTypeArr[weakSelf.currentIndex];
        vc.carName = weakSelf.nameArr[weakSelf.currentIndex];
        NSLog(@"%@===",str);
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.scrollView addSubview:_leftbuyCarView];
    [self.scrollView addSubview:_currentbuyCarView];
    [self.scrollView addSubview:_rightbuyCarView];
    
}


- (void)leftBtnClick:(UIButton *)btn{
    
    if (btn.tag == 3018) {
        _currentIndex = (_currentIndex-1+_imgCount)%_imgCount;
        [self initImages];
        
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth  *2,0)];
        [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
    }else if(btn.tag == 3019){
        
        _currentIndex =++ _currentIndex % _imgCount;
        [self initImages];
        
        [self.scrollView setContentOffset:CGPointMake(0,0)];
        [_scrollView setContentOffset:CGPointMake(ScreenWidth , 0) animated:YES];
        
    }
    
}
- (void)initImages{
    
    NSInteger a = (_currentIndex - 1 + _imgCount) % _imgCount;
    NSInteger b = (_currentIndex + 1) % _imgCount;
    _leftbuyCarView.currentImageView.image = [UIImage imageNamed:_array[a]];
    _leftbuyCarView.carLabel.text = _nameArr[a];
    
    _pageLabel.text = [NSString stringWithFormat:@"%ld/5",(long)_currentIndex + 1];
    _currentbuyCarView.currentImageView.image = [UIImage imageNamed:_array[_currentIndex]];
    _currentbuyCarView.carLabel.text = _nameArr[_currentIndex];
    
    _rightbuyCarView.currentImageView.image = [UIImage imageNamed:_array[b]];
    _rightbuyCarView.carLabel.text = _nameArr[b];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //    int a = round(scrollviewX/ScreenWidth);
    //    NSLog(@"====%d====",a);
    //    if (a == 0) {
    
    CGPoint contentOffset = [_scrollView contentOffset];
    
    if(contentOffset.x > ScreenWidth){
        _currentIndex = ++_currentIndex % _imgCount;
        [self initImages];
        [_scrollView setContentOffset:CGPointMake(ScreenWidth , 0)];
    }
    else if(contentOffset.x < ScreenWidth ){
        _currentIndex = (_currentIndex-1+_imgCount)%_imgCount;
        [self initImages];
        [_scrollView setContentOffset:CGPointMake(ScreenWidth , 0)];
    }
    else{
        NSLog(@"do nothing");
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
