//
//  JYaddOutletsViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/29.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYaddOutletsViewController.h"

#import "JYAddLineTableViewCell.h"
#import "UIView+Extension.h"
#import "JYMineRequestData.h"
#import "CompanyModelInfo.h"
#import "JYOutletsModel.h"
#import "JYLookAddressViewController.h"
@interface JYaddOutletsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,JYMineRequestDataDelegate,MapViewControllerDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *finshEdBtn;
@property (nonatomic,strong)NSString *outletsName;
@property (nonatomic,strong)NSString *outletsPhone;
@property (nonatomic,assign)CLLocationCoordinate2D location;
@property (nonatomic,strong)NSString *outletsAddress;
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *district;
@property (nonatomic,strong)NSString *city;

@end

@implementation JYaddOutletsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加网点";
    self.view.backgroundColor = BgColorOfUIView;
    
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    [self createTableView];
    _outletsName = @"";
    _outletsPhone = @"";
    _outletsAddress = @"";
    _province = @"";
    _district = @"";
    _city = @"";
    if ([_idetor isEqualToString:@"idetor"]) {
        
        _outletsName = _outLetsModel.name;
        _outletsPhone = _outLetsModel.landline;
        _outletsAddress = _outLetsModel.address;

        UIBarButtonItem *rightItem = [UIBarButtonItem addRight_ItemWithTitle:@"完成" target:self action:@selector(finshBtnBtnClick:)];
        
        NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Reg size:18],
                              NSForegroundColorAttributeName:[UIColor whiteColor]};
        [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightItem;

    }

}

- (void)loadNewDataForIdetor{
    
    if ([self finishedTip]) {
        JYMineRequestData *manager = [JYMineRequestData shareInstance];
        manager.delegate = self;
        [self returnAction];
        
        [manager requsetUpdateLogisticsbaranchUrl:@"app/logisticsbaranch/updateLogisticsbaranch" OutletsModel:_outLetsModel name:_outletsName address:_outletsAddress landline:_outletsPhone];

    }
}

- (BOOL)finishedTip{
    
    [self.view endEditing:YES];
    
    if (_outletsPhone.length <= 0) {
        
        [MBProgressHUD showInfoMessage:@"请输入网点座机"];
        return NO;
    }else if (_outletsName.length <= 0){
        
        [MBProgressHUD showInfoMessage:@"请输入网点名字"];
        return NO;
        
    }else if (_outletsAddress.length <= 0){
        
        [MBProgressHUD showInfoMessage:@"请输入网点地址"];
        return NO;
    }else{
        
        return YES;
    }
}

- (void)loadNewDataForAddOutlets{
    
    if ([self finishedTip]) {
        
        CompanyModelInfo *model = [JYAccountTool getLogisticsModelInfo];
        JYMineRequestData *manager = [JYMineRequestData shareInstance];
        manager.delegate = self;
        [self returnAction];
        
        [manager requsetSaveLogisticsbaranchUrl:@"app/logisticsbaranch/saveLogisticsbaranch" ID: model.id name:_outletsName address:_outletsAddress landline:_outletsPhone province:_province city:_city district:_district location:_location];

    }
    
}
//新增网点
- (void)requestSaveLogisticsbaranchSuccess:(NSDictionary *)resultDic{
    
    if ([resultDic objectForKey:@"message"]) {
        [MBProgressHUD showSuccessMessage:@"添加成功"];

    }

}

- (void)requestSaveLogisticsbaranchFailed:(NSError *)error{
    
    
}

//更新网点
- (void)requestUpdateLogisticsbaranchSuccess:(NSDictionary *)resultDic{
    
    [MBProgressHUD showSuccessMessage:@"修改成功"];

}
- (void)requestUpdateLogisticsbaranchFailed:(NSError *)error{
    
    
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(8,0, ScreenWidth - 16, 230) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    if ([_idetor isEqualToString:@"idetor"]) {
        return;
    }
    UIButton *finshEdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finshEdBtn.frame = CGRectMake(16,180, ScreenWidth - 32, 50);
    finshEdBtn.layer.cornerRadius = 2.0;
    finshEdBtn.layer.masksToBounds = YES;
    [finshEdBtn setBackgroundColor:RGBA(105, 181, 240, 1)];
    finshEdBtn.titleLabel.font =  [UIFont fontWithName:Default_APP_Font_Reg size:22];
    [finshEdBtn setTitle:@"完成" forState:UIControlStateNormal];
    _finshEdBtn = finshEdBtn;
    [finshEdBtn addTarget:self action:@selector(finshBtnBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:finshEdBtn];

}

- (void)finshBtnBtnClick:(UIButton *)btn{
   
    if ([_idetor isEqualToString:@"idetor"]) {
        
        [self loadNewDataForIdetor];
    }
    if ([_idetor isEqualToString:@"addOutlets"]) {
        
        [self loadNewDataForAddOutlets];
    }
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 选择地图位置回调－－－赋值
- (void)didSelectAddress:(NSString*)address poi:(NSString*)poi location:(CLLocationCoordinate2D)location{
    
    _location = location;
    _outletsAddress = [NSString stringWithFormat:@"%@%@",address,poi];
    [self.tableView reloadData];

}

//城市名称回调
- (void)selectProvinceInMapView:(NSString *)province city:(NSString *)city district:(NSString *)district{

    _province = province;
    _city = city;
    _district = district;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYAddLineTableViewCell *cell = [JYAddLineTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectAddressBtn.hidden = YES;
    cell.lineTextField.font =  [UIFont fontWithName:Default_APP_Font_Reg size:16];
    cell.lineTextField.textColor = RGB(51, 51, 51);
    if (indexPath.row == 0) {
        cell.lineTextField.userInteractionEnabled = YES;
        cell.lineTextField.tag = 20;
        cell.lineTextField.placeholder = @"请输入网点名称";
        cell.lineTextField.delegate = self;
        [cell.lineTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        cell.lineTextField.returnKeyType = UIReturnKeyDone;

        cell.lineTextField.text = _outletsName;
        
        [cell.typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
            
        }];
        cell.typeImgView.image = [UIImage imageNamed:@"icon_suoshuwangdian"];

    }else if (indexPath.row == 1){
        
        cell.lineTextField.userInteractionEnabled = NO;
        cell.selectAddressBtn.hidden = NO;
        [cell.selectAddressBtn addTarget:self action:@selector(selectAddressClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.lineTextField.placeholder = @"请输入网点地址";

        cell.lineTextField.text = _outletsAddress;
        cell.typeImgView.image = [UIImage imageNamed:@"icon_wangdiandizhi"];
        
    }else if (indexPath.row == 2){
        [cell.typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
            
        }];
        cell.typeImgView.size = CGSizeMake(25 ,25);

        cell.lineTextField.userInteractionEnabled = YES;
        cell.lineTextField.tag = 21;
        cell.lineTextField.delegate = self;
        cell.lineTextField.returnKeyType = UIReturnKeyDone;
        cell.lineTextField.placeholder = @"请输入网点座机";
        [cell.lineTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        cell.lineTextField.text = _outletsPhone;
    
        cell.typeImgView.image = [UIImage imageNamed:@"icon_dianhua-1"];
    }
    return cell;
    
}
- (void)selectAddressClick:(UIButton *)btn{
    
    JYLookAddressViewController *mapVC = [[JYLookAddressViewController alloc]init];
    mapVC.delegate = self;
    [self.navigationController pushViewController:mapVC animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [self.tableView endEditing:YES];
}


-(void)textFieldDidBeginEditing:(UITextField*)textField

{
    
    
}

-(void)textFieldDidChange :(UITextField *)textField{
    
    switch (textField.tag) {
        case 20:

                _outletsName = textField.text;

            break;
        case 21:

                _outletsPhone = textField.text;
 
            break;
        default:
            break;
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    [textField resignFirstResponder];
    return YES;
    
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
