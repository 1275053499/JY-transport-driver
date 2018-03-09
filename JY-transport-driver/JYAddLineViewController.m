
//
//  JYAddLineViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/22.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYAddLineViewController.h"
#import "JYAddLineTableViewCell.h"
#import "JYChooseCityViewController.h"

#import "PSCityPickerView.h"
#import "UIView+Extension.h"
#import "JYMineRequestData.h"
#import "CompanyModelInfo.h"
@interface JYAddLineViewController ()<UITableViewDataSource,UITableViewDelegate,PSCityPickerViewDelegate,UITextFieldDelegate,JYMineRequestDataDelegate,JYChooseCityViewControllerDelegate>
@property (nonatomic,strong)UITableView *tableView;

@property (strong, nonatomic) PSCityPickerView *cityPicker;
@property (nonatomic,strong)NSString *chooseCity;


@property (nonatomic,strong)NSString *startProvicName;
@property (nonatomic,strong)NSString *startProvinceID;
@property (nonatomic,strong)NSString *startCityID;

@property (nonatomic,strong)NSString *endProviceID;
@property (nonatomic,strong)NSString *endCityID;
@property (nonatomic,strong)NSString *endProviceName;
@property (nonatomic,strong)NSString *endCityName;
@property (nonatomic,strong)NSString *chooseEndName;


@end

@implementation JYAddLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    [self createTableView];
    _chooseCity = @"";
    _startProvinceID = @"";
    _startCityID = @"";
    _startProvicName = @"";
    _endCityID = @"";
    _endProviceID = @"";
    _endCityName = @"";
    _endProviceName = @"";
    _chooseEndName = @"";
     self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnBackAction)];
    [self creatFinshBtn];
}
- (void)returnBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)creatFinshBtn{
    
    
    UIButton *finshEdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finshEdBtn.frame = CGRectMake(16,130, ScreenWidth - 32, 50);
    finshEdBtn.layer.cornerRadius = 2.0;
    finshEdBtn.layer.masksToBounds = YES;
    [finshEdBtn setBackgroundColor:RGBA(105, 181, 240, 1)];
    finshEdBtn.titleLabel.font =  [UIFont fontWithName:Default_APP_Font_Reg size:22];
    [finshEdBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finshEdBtn addTarget:self action:@selector(finshBtnBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:finshEdBtn];
}

- (void)finshBtnBtnClick:(UIButton *)btn{

    CompanyModelInfo *model = [JYAccountTool getLogisticsModelInfo];
    
    JYMineRequestData *manager = [JYMineRequestData shareInstance];
    manager.delegate =self;

    NSString *Linename = [NSString stringWithFormat:@"%@ ——— %@",_startProvicName,_endProviceName];
    [manager requsetsaveLogisticslineUrl:@"app/logisticsline/saveLogisticsline" logisticsId:model.id name:Linename originProvince:_startProvinceID endProvince:_endProviceID originCity:_startCityID endCity:_endCityID];

    
}
//设置服务路线
- (void)requestSetServiceLineSuccess:(NSDictionary *)resultDic{
    
    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"0"]) {
        [MBProgressHUD showSuccessMessage:@"设置成功"];
        [self returnBackAction];
    }
}

- (void)requestSetServiceLineFailed:(NSError *)error{
    
    
}
- (void)chooseServiceLine:(NSString *)City lineId:(NSString *)CityID provice:(NSString *)provice proviceID:(NSString *)proviceID{
    
    _endCityName = City;
    _endProviceName = provice;
    _endCityID = CityID;
    _endProviceID = proviceID;
    
    _chooseEndName = [NSString stringWithFormat:@"%@ · %@",_endProviceName,_endCityName];
    [self.tableView reloadData];
    
}
#pragma mark - PSCityPickerViewDelegate
- (void)cityPickerView:(PSCityPickerView *)picker finishPickProvince:(NSString *)province city:(NSString *)city district:(NSString *)district ProvinceID:(NSString *)provinceID cityID:(NSString *)cityID districtID:(NSString *)districtID
{
    
    _startProvinceID = provinceID;
    _startCityID = cityID;
    _startProvicName = province;
    
    _chooseCity = [NSString stringWithFormat:@"%@ · %@",province,city];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
       

}


- (PSCityPickerView *)cityPicker
{
    if (!_cityPicker)
    {
        _cityPicker = [[PSCityPickerView alloc] initWithFrame:CGRectMake(12, ScreenHeight - 220, ScreenWidth - 24, 220)];
        _cityPicker.ComponentNum = 2;
        _cityPicker.ComponentWidth = 160;
        _cityPicker.ComponentRowheight = 40;
        _cityPicker.backgroundColor = [UIColor whiteColor];
        _cityPicker.cityPickerDelegate = self;
    }
    return _cityPicker;
}
-(void)createTableView
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(8,0, ScreenWidth - 16, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 53;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JYAddLineTableViewCell  *cell = [JYAddLineTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.lineTextField.delegate = self;
 
    if (indexPath.section == 0 ) {
        cell.lineTextField.userInteractionEnabled = NO;
        cell.lineTextField.tag = 20 + indexPath.section;
        cell.lineTextField.placeholder = @"请输入起点";
        cell.lineTextField.text = _chooseCity;
        cell.typeImgView.image = [UIImage imageNamed:@"icon_zhongdian"];
        [cell.selectAddressBtn addTarget:self action:@selector(selectAddressClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.selectAddressBtn.tag = 47;
        cell.typeImgView.image = [UIImage imageNamed:@"icon_qidian"];

    }else{
        
        cell.lineTextField.userInteractionEnabled = NO;
        cell.lineTextField.tag = 20 + indexPath.section;
        cell.lineTextField.placeholder = @"请输入终点";
        cell.lineTextField.text = _chooseEndName;
        cell.typeImgView.image = [UIImage imageNamed:@"icon_zhongdian"];
        [cell.selectAddressBtn addTarget:self action:@selector(selectAddressClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.selectAddressBtn.tag = 48;

    }
    
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 9;
    }else{
        return 1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    v.backgroundColor = [UIColor clearColor];
    
    return v;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

//    if (indexPath.section == 0) {
//
//        [self.cityPicker showPickView];
//    }
//    if (indexPath.section == 1) {
//    JYChooseCityViewController *chooseCityVC = [[JYChooseCityViewController alloc] init];
//        chooseCityVC.delegate = self;
//    [self.navigationController pushViewController:chooseCityVC animated:YES];
//
//
//    }
}

- (void)selectAddressClick:(UIButton *)btn{
    switch (btn.tag) {
        case 47:{
            [self.cityPicker showPickView];

        }
            
            break;
        case 48:{
            JYChooseCityViewController *chooseCityVC = [[JYChooseCityViewController alloc] init];
            chooseCityVC.delegate = self;
            [self.navigationController pushViewController:chooseCityVC animated:YES];

        }
            break;
            
        default:
            break;
    }

}
-(void)textFieldDidBeginEditing:(UITextField*)textField

{

    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    [textField resignFirstResponder];
    return YES;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [self.tableView endEditing:YES];
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
