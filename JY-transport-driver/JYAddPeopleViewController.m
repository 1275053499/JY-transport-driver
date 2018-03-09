//
//  JYAddPeopleViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/29.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYAddPeopleViewController.h"
#import "JYAddpeopleTableViewCell.h"
#import "JYAddLineTableViewCell.h"
#import "UIView+Extension.h"
#import "JYMineRequestData.h"
#import "CompanyModelInfo.h"
#import "JYMyOutletsViewController.h"
#import "JYOutletsModel.h"
#import "JYPeopleModel.h"
@interface JYAddPeopleViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,JYMineRequestDataDelegate,JYMyOutletsViewControllerDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSString *addPeoplePhone;
@property (nonatomic,strong)NSString *addPeoplename;
@property (nonatomic,strong)NSString *addPeoplerole;
@property (nonatomic,strong)NSString *AddpeopleOutletes;
@property (nonatomic,strong)NSString *outletesID;
@property (nonatomic,strong)JYOutletsModel *outletesModel;
@end

@implementation JYAddPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];

    
    _addPeoplename = @"";
    _addPeoplerole = @"";
    _addPeoplePhone = @"";
    _AddpeopleOutletes = @"";
    _outletesID = @"";
    if ([_idetor isEqualToString:@"idetorPeople"]) {
        
        _addPeoplename = _peoplemodel.name;
//      _AddpeopleOutletes =_peoplemodel.role ;
        _addPeoplePhone = _peoplemodel.phone;
        _outletesID = _peoplemodel.branchid;
        _addPeoplerole = _peoplemodel.role ;
    }
    
    
    self.view.backgroundColor = BgColorOfUIView;
    UIBarButtonItem *rightItem = [UIBarButtonItem addRight_ItemWithTitle:@"完成" target:self action:@selector(finshBtnBtnClick:)];
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Reg size:18],
                          NSForegroundColorAttributeName:[UIColor whiteColor]};
    [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self createTableView];
    
}

- (void)finshBtnBtnClick:(UIButton *)btn{
    
    if ([_idetor isEqualToString:@"addPeople"]) {
        
        [self addNewPeople];
    }
    if ([_idetor isEqualToString:@"idetorPeople"]) {
        
        [self idetorPeopleInfo];
    }
}- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(8,9, ScreenWidth - 16, ScreenHeight-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
}

- (void)addNewPeople{
   
    if ([self finishedTip]) {
        JYMineRequestData *manager = [JYMineRequestData shareInstance];
        manager.delegate = self;
        [manager requsetAddPeopleUrl:@"app/logisticsclerk/saveLogisticsclerk" branchid:_outletesID phone:_addPeoplePhone name:_addPeoplename role:_addPeoplerole];
        
    }
}
- (BOOL)finishedTip{
    
    [self.view endEditing:YES];
    
    if (_addPeoplename.length <= 0) {
        
        [MBProgressHUD showInfoMessage:@"请输入姓名"];
        return NO;
    }else if (_addPeoplePhone.length <= 0){
        
        [MBProgressHUD showInfoMessage:@"请输入手机号码"];
        return NO;
        
    }else if (_addPeoplerole.length <= 0){
        
        [MBProgressHUD showInfoMessage:@"请输入职位"];
        return NO;
        
    }
    else if (_AddpeopleOutletes.length <= 0){
        
        [MBProgressHUD showInfoMessage:@"请输入网点"];
        
        return NO;
        
    }else{
        return YES;
    }

}
- (void)idetorPeopleInfo{
     if ([self finishedTip]) {
    
    JYMineRequestData *manager = [JYMineRequestData shareInstance];
    manager.delegate = self;
    
    [manager requsetUpdatePeopleUrl:@"app/logisticsclerk/updateClerkToGroup" JYPeopleModel:_peoplemodel name:_addPeoplename phone:_addPeoplePhone role:_addPeoplerole outletes:_outletesID];

    
     }
}


- (void)chooseOurletsForAddPeople:(JYOutletsModel *)model{
    
    _outletesModel = model;
   _AddpeopleOutletes =  _outletesModel.name;
    _outletesID = _outletesModel.id;
    [self.tableView reloadData];
    
}
/**
 *  修改业务员信息
 */
- (void)requestUpdatePeopleSuccess:(NSDictionary *)resultDic{
    
    NSString *message =[resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"0"]) {
        
        [MBProgressHUD showInfoMessage:@"添加人员成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}
- (void)requestUpdatePeopleFailed:(NSError *)error{
    
    
    
}
/**
 *  添加业务员
 */
- (void)requestAddPeopleSuccess:(NSDictionary *)resultDic{
    
    NSString *message =[resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"0"]) {
        
        [MBProgressHUD showInfoMessage:@"添加人员成功"];
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}

- (void)requestAddPeopleFailed:(NSError *)error{
    
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 4;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 113;
    }else{
        return 50;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        JYAddpeopleTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYAddpeopleTableViewCell class]) owner:nil options:0][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else{
        
        JYAddLineTableViewCell *cell = [JYAddLineTableViewCell cellWithTableView:tableView];
        cell.selectAddressBtn.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lineTextField.font =  [UIFont fontWithName:Default_APP_Font_Reg size:16];
        cell.lineTextField.textColor = RGB(51, 51, 51);
        if (indexPath.row == 0) {
            [cell.typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(24);
                
            }];

            cell.typeHeighConstr.constant = 24;
            cell.typeImgWidthConstr.constant = 29;
            cell.lineTextField.userInteractionEnabled = YES;
            cell.lineTextField.tag = 30;
            cell.lineTextField.delegate = self;
            cell.lineTextField.placeholder = @"请输入姓名";
            cell.lineTextField.text = _addPeoplename;
            
            
            cell.typeImgView.image = [UIImage imageNamed:@"icon_xiangmingshuru"];
            cell.lineTextField.returnKeyType = UIReturnKeyDone;
            [cell.lineTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }else if (indexPath.row == 1){
            [cell.typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
            }];
            cell.typeHeighConstr.constant = 30;
            cell.typeImgWidthConstr.constant = 21;
            cell.lineTextField.userInteractionEnabled = YES;
            cell.lineTextField.tag = 31;
            cell.lineTextField.delegate =self;
            cell.lineTextField.returnKeyType = UIReturnKeyDone;
            [cell.lineTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.lineTextField.placeholder = @"请输入手机号码";
            cell.typeImgView.image = [UIImage imageNamed:@"icon_shurushoujihaoma"];
            cell.lineTextField.text = _addPeoplePhone;

        }else if (indexPath.row == 2){
            cell.typeHeighConstr.constant = 23;
            cell.typeImgWidthConstr.constant = 30;
            cell.lineTextField.userInteractionEnabled = YES;
            cell.lineTextField.tag = 32;
            cell.lineTextField.delegate =self;
            cell.lineTextField.returnKeyType = UIReturnKeyDone;
            [cell.lineTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.lineTextField.placeholder = @"请输入职位";
            cell.lineTextField.text = _addPeoplerole;
            cell.typeImgView.image = [UIImage imageNamed:@"icon_shurujuese"];
        }else{
            cell.typeHeighConstr.constant = 30;
            cell.typeImgWidthConstr.constant = 30;
            cell.imageView.hidden  = YES;
            cell.lineTextField.userInteractionEnabled = NO;
            cell.lineTextField.placeholder = @"请输入所属网点";
            cell.lineTextField.tag = 32;

            cell.lineTextField.text = _AddpeopleOutletes;
            cell.typeImgView.image = [UIImage imageNamed:@"icon_suoshuwangdian-1"];
            cell.lineTextField.returnKeyType = UIReturnKeyDone;
        }
        
        return cell;

    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 9;

    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            JYMyOutletsViewController *vc = [[JYMyOutletsViewController alloc] init];
            vc.delegate = self;
            vc.whichVCPush = @"JYAddPeopleViewController";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)textFieldDidChange :(UITextField *)textField{
    
    switch (textField.tag) {
        case 30:
            
                _addPeoplename = textField.text;

            break;
        case 31:
            
                _addPeoplePhone = textField.text;

            break;
        case 32:
         
                _addPeoplerole = textField.text;
        
            break;
        case 33:
            
                _AddpeopleOutletes = textField.text;
            
        
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
