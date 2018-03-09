//
//  JYChooseCityViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/8.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYChooseCityViewController.h"
#import "JYChooseCityTableViewCell.h"
#import "JYChooseCityRightTableViewCell.h"

@interface JYChooseCityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *leftTableview;
@property (nonatomic,strong)UITableView *righttableView;
@property (nonatomic,assign)NSInteger indexNum;
@property (nonatomic,strong)NSArray *allProvinceInfo;
@property (nonatomic,strong)NSArray *allCityArr;
@property (nonatomic,assign)NSInteger selectIndex;//选中左边的indxe
@property (nonatomic,strong)NSString *selectprovice;
@property (nonatomic,strong)NSString *selectproviceID;

@property (nonatomic,strong)NSMutableArray *selectCityArr;
@property (nonatomic,strong)NSMutableArray *selectCityIDArr;
@property (nonatomic,strong)NSMutableArray *indexArr;


@end


static float kLeftTableViewWidth = 160;

@implementation JYChooseCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightbarBtn:@"保存"];
    _selectIndex = 0;
    _selectprovice = @"北京市";
    _selectproviceID = @"2";
    
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnBackAction)];
    _selectCityArr = [NSMutableArray array];
    _selectCityIDArr = [NSMutableArray array];
    _indexArr = [NSMutableArray array];

    [self createTableView];
}
- (void)setRightbarBtn:(NSString*)title{
    
    UIBarButtonItem *rightItem = [UIBarButtonItem addRight_ItemWithTitle:title target:self action:@selector(saveLine)];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:RGBA(255, 255, 255, 1) forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)returnBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSArray *)allProvinceInfo
{
    if (!_allProvinceInfo)
    {
        NSBundle *bundle=[NSBundle mainBundle];
        NSString *path=[bundle pathForResource:@"allCitoy" ofType:@"plist"];
        _allProvinceInfo = [[NSArray alloc]initWithContentsOfFile:path];
        
    }
    return _allProvinceInfo;
}

- (NSArray *)allCityArr{
    
    if (!_allCityArr) {
        NSMutableArray *cityArr = [NSMutableArray array];
        for (NSDictionary *dic in self.allProvinceInfo) {
            
            NSArray *arr = [dic objectForKey:@"nodesList"];
            [cityArr addObject:arr];
        }
        _allCityArr = cityArr;
        
    }
    return _allCityArr;
    
}
- (void)saveLine{
    
    NSString *cityStr = [_selectCityArr componentsJoinedByString:@"/"];
    if (_selectCityArr.count <= 0 ) {
        cityStr = @"北京";
        NSArray *cityArr = self.allCityArr[_selectIndex];
        NSDictionary *dic = cityArr[0];
        NSString *city = [dic objectForKey:@"regionName"];
        cityStr = city;
    }
    NSString *cityID = [_selectCityIDArr componentsJoinedByString:@","];
    
    if ([self.delegate respondsToSelector:@selector(chooseServiceLine:lineId:provice:proviceID:)]) {
        
        [self.delegate chooseServiceLine:cityStr lineId:cityID provice:_selectprovice proviceID:_selectproviceID];
         NSLog(@"-----City%@----====%@CityID=======%@proviceID=======provice%@",cityStr,cityID,_selectproviceID,_selectprovice);
        [self returnBackAction];
    }
    
}

-(void)createTableView
{
    self.leftTableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kLeftTableViewWidth, ScreenHeight -64) style:UITableViewStylePlain];
    self.leftTableview.delegate = self;
    self.leftTableview.dataSource = self;
    self.leftTableview.scrollEnabled = YES;
    self.leftTableview.showsVerticalScrollIndicator = NO;
    self.leftTableview.bounces = NO;

    self.leftTableview.tableFooterView = [[UIView alloc]init];
    self.leftTableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.leftTableview];
    self.leftTableview.backgroundColor = BgColorOfUIView;
    self.leftTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.leftTableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
    
    
    self.righttableView = [[UITableView alloc]initWithFrame:CGRectMake(kLeftTableViewWidth,0, ScreenWidth -kLeftTableViewWidth, ScreenHeight -64) style:UITableViewStylePlain];
    
    self.righttableView.delegate = self;
    self.righttableView.dataSource = self;
    self.righttableView.scrollEnabled = YES;
    self.righttableView.bounces = NO;
    self.righttableView.backgroundColor = [UIColor whiteColor];
    self.righttableView.allowsMultipleSelection = YES;
//    self.righttableView.tableFooterView = [[UIView alloc]init];
//    self.righttableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.righttableView];
    self.righttableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSIndexPath *inddex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.righttableView didSelectRowAtIndexPath:inddex];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableview) {
        return self.allProvinceInfo.count;
    }else if (tableView == _righttableView){
        
        NSArray *arr = self.allCityArr[_selectIndex];
        
        return arr.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _leftTableview) {
        
        JYChooseCityTableViewCell *cell = [JYChooseCityTableViewCell cellWithTableView:tableView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        NSDictionary *provenceDic = self.allProvinceInfo [indexPath.row];
        NSString *regionName = [provenceDic objectForKey:@"regionName"];
        
        cell.name.text = regionName;


        return cell;

    }else{
        
        JYChooseCityRightTableViewCell *cel = [JYChooseCityRightTableViewCell cellWithTableView:tableView];
        cel.selectionStyle = UITableViewCellSelectionStyleNone;

        cel.nameBtn.userInteractionEnabled = NO;
        cel.selectImage.userInteractionEnabled = NO;
        [cel.nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [cel.nameBtn setTitleColor:RGB(105, 181, 240) forState:(UIControlStateSelected)];
        cel.nameBtn.tag = indexPath.row;
        [cel.selectImage setBackgroundImage:[UIImage imageNamed:@"Shape"] forState:(UIControlStateSelected)];

        NSArray *cityArr = self.allCityArr[_selectIndex];
        NSDictionary *dic = cityArr[indexPath.row];
        NSString *city = [dic objectForKey:@"regionName"];
        [cel.nameBtn setTitle:city forState:(UIControlStateNormal)];
        
        for (int i = 0; i< _indexArr.count; i++) {
            
            NSInteger index = [_indexArr[i] integerValue];
            if (index == indexPath.row ) {
                cel.nameBtn.selected  = YES;
                cel.selectImage.selected = YES;
            }
        }
        
        return cel;

        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JYChooseCityRightTableViewCell *cell = [self.righttableView cellForRowAtIndexPath:indexPath];

    if (tableView == _leftTableview) {
        
        _selectIndex = indexPath.row;
        [_indexArr removeAllObjects];

        //获取点击的省和ID
        [self getSelectProviceNameAndId:indexPath.row];
        
        [_leftTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
        [_righttableView reloadData];
        
        if (_indexArr > 0) {
            [_indexArr removeAllObjects];
            [_selectCityArr removeAllObjects];
            [_selectCityIDArr removeAllObjects];
        }
        NSIndexPath *inddex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.righttableView didSelectRowAtIndexPath:inddex];


    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (!cell.selectImage.selected) {
            
            [self getSelectCityNameAndId:indexPath.row];
            [_indexArr addObject:@(indexPath.row)];
            
        }else{
            
            [_indexArr removeObject:@(indexPath.row)];
            NSArray *cityArr = self.allCityArr[_selectIndex];
            NSDictionary *dic = cityArr[indexPath.row];
            NSNumber *cityid = [dic objectForKey:@"regionId"];
            NSString *cityidStr = [NSString stringWithFormat:@"%@",cityid];
            NSString *cityName = [dic objectForKey:@"regionName"];
            [_selectCityArr removeObject:cityName];
            [_selectCityIDArr removeObject:cityidStr];
        }
        
        cell.selectImage.selected = !cell.selectImage.selected;
        cell.nameBtn.selected = !cell.nameBtn.selected;
        
//        SLog(@"-----City%@----====%@CityID=======%@proviceID=======provice%@",_selectCityArr,_selectCityIDArr,_selectproviceID,_selectprovice);

        
    }
  
}
//获取点击的省和ID
- (void)getSelectProviceNameAndId:(NSInteger)index{
    
    NSDictionary *provenceDic = self.allProvinceInfo [index];
    _selectprovice = [provenceDic objectForKey:@"regionName"];
    NSNumber *proviceID = [provenceDic objectForKey:@"regionId"];
    _selectproviceID = [NSString stringWithFormat:@"%@",proviceID];
    NSLog(@"%@%@",_selectprovice,_selectproviceID);

}

//获取点击的市和ID
- (void)getSelectCityNameAndId:(NSInteger)index{
    
    NSArray *cityArr = self.allCityArr[_selectIndex];
    NSDictionary *dic = cityArr[index];
    NSNumber *cityid = [dic objectForKey:@"regionId"];
    NSString *cityidStr = [NSString stringWithFormat:@"%@",cityid];
    NSString *cityName = [dic objectForKey:@"regionName"];
    
    [_selectCityArr addObject:cityName];
    [_selectCityIDArr addObject:cityidStr];

   
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
