//
//  JYEditCompanyInfoViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/30.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYEditCompanyInfoViewController.h"
#import "JYEditCompanyInfoTableViewCell.h"
#import "JYEditCompanyNameViewController.h"
#import "JYEditCompanyPhoneViewController.h"
#import "CompanyProfileViewController.h"
#import "JYEditCompanyIconViewController.h"
#import "JYEditCompanyCellSecondCell.h"
#import "CompanyModelInfo.h"
#import <UIImageView+WebCache.h>
#import "ClerkModel.h"
@interface JYEditCompanyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,JYEditCompanyNameViewControllerDelegate,JYEditCompanyPhoneViewControllerDelegate,CompanyProfileViewControllerDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)CompanyModelInfo *companyModel;
@property (nonatomic,strong)UIImageView *heardImgView;
@property (nonatomic,strong)ClerkModel *clerkModel;
@property (nonatomic,strong)NSString *UserType;
@end

@implementation JYEditCompanyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];

    [self createTableView];
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    _companyModel = [JYAccountTool getLogisticsModelInfo];
    _UserType = [JYAccountTool loginType];
    _clerkModel = [JYAccountTool getLogisticsclerkModelInfo];
    
    [self.tableView reloadData];
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(8,0, ScreenWidth - 16, ScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
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
        if ([_UserType isEqualToString:@"4"]) {
            return 3;
        }else{
            return 4;
        }

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 86;
    }else{
        return 50;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
      JYEditCompanyCellSecondCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYEditCompanyCellSecondCell class]) owner:nil options:0][0];
    
    
     cell.textLabel.font =  [UIFont fontWithName:Default_APP_Font_Reg size:16];
    cell.textLabel.textColor = RGB(51, 51, 51);
    UIImageView *accessimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_jiantou2"]];

    if (indexPath.section == 0) {
        
       
        JYEditCompanyInfoTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYEditCompanyInfoTableViewCell class]) owner:nil options:0][0];
        UIImageView *accessimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_jiantou2"]];
        cell.accessoryView = accessimg;
        if ([_UserType isEqualToString:@"4"]) {
        
        }
        NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
        NSString *urlstr = [NSString stringWithFormat:@"%@%@",url,_companyModel.icon];
        if ([_UserType isEqualToString:@"4"]) {
            
            urlstr = [NSString stringWithFormat:@"%@%@",url,_clerkModel.icon];
        }
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"default_avatar"]];

        return cell;

    }
    if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.type.text = @"手机号码";
                cell.name.text = userPhone_Log;
            }else if (indexPath.row == 1){
                
                cell.type.text = @"座机";
                cell.name.text = _companyModel.landline;
                cell.accessoryView = accessimg;
                
                if ([_UserType isEqualToString:@"4"]) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.type.text = @"所属公司";
                    cell.name.text = _clerkModel.logisticsName;
                    cell.accessoryView = nil;

                }
            }else if (indexPath.row == 2){
                
                cell.type.text = @"公司名称";
                cell.name.text = _companyModel.companyname;
                cell.accessoryView = accessimg;
                if ([_UserType isEqualToString:@"4"]) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.type.text = @"所属网点";
                    cell.name.text = _clerkModel.branchName;;
                    cell.accessoryView = nil;
                }
            }else {
                
                cell.type.text = @"公司简介";
                cell.accessoryView = accessimg;

            }
        }
    
    return cell;
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        JYEditCompanyIconViewController *vc = [[JYEditCompanyIconViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }else if (indexPath.section == 1){
        if ([_UserType isEqualToString:@"4"]) {
            
        } else {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            JYEditCompanyPhoneViewController *vc = [[JYEditCompanyPhoneViewController alloc] init];
            vc.phoneStr = _companyModel.phone;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        
        }else if (indexPath.row == 2){
            JYEditCompanyNameViewController *vc = [[JYEditCompanyNameViewController alloc] init];
            vc.nameStr = _companyModel.companyname;
                vc.delegate = self;

            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
            
            CompanyProfileViewController *vc = [[CompanyProfileViewController alloc] init];
            vc.profileStr = _companyModel.introductions;
            vc.delegate = self;

            [self.navigationController pushViewController:vc animated:YES];
            
        }
            
        }

    }
}


#pragma mark =============== name delegate ===============

- (void)changeNameValue:(NSString *)value{
    
    if (value != nil || value.length > 0) {
        
        [self queryLogisticsInfo:@"companyname" :value];
    }
    
}

#pragma mark =============== Phone delegate ===============

- (void)changePhoneValue:(NSString *)value{
    
    if (value != nil || value.length > 0) {
        
        [self queryLogisticsInfo:@"landline" :value];
    }
    
}

#pragma mark =============== introductions delegate ===============

- (void)changeIntroductionsValue:(NSString *)value{
    
    if (value != nil || value.length > 0) {
        
        [self queryLogisticsInfo:@"introductions" :value];
    }
    
}

- (void)queryLogisticsInfo:(NSString*)tpye :(NSString*)str{
    
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/logisticsgroup/updateLogisticsGroup"];
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"id":_ID,tpye:str} success:^(id responseObj) {
        
        
        if ([tpye isEqualToString:@"companyname"]) {
            
            _companyModel.companyname = str;
        }
        if ([tpye isEqualToString:@"landline"]) {
            
            _companyModel.landline = str;
        }
        if ([tpye isEqualToString:@"introductions"]) {
            
            _companyModel.introductions = str;
        }
        
        [JYAccountTool saveLogisticsModelInfo:_companyModel];
        [self.tableView reloadData];

        
    } failure:^(NSError *error) {

    }];
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
