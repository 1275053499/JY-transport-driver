//
//  JYPersonHomeViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYPersonHomeViewController.h"

#import "JYHomeGrabOrderTableViewCell.h"
#import "JYGrabTableViewCellSecond.h"
#import "JYGrabTableViewCellThird.h"
#import "JYGrabServiceTableViewCell.h"
#import "JYGrabValueTableViewCell.h"
@interface JYPersonHomeViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation JYPersonHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"接单广场";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:Default_APP_Font size:20]};
    self.view.backgroundColor = BgColorOfUIView;
    [self createTableView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.estimatedRowHeight = 50.0f;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 2) {
        return 3;
    }else{
         return 5;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
            return 137;
        }else if (indexPath.row == 1){
            return 88;
        }else if (indexPath.row == 2){
            return 40;
        }else if (indexPath.row == 3){
            return 40;
        }else if (indexPath.row == 4){
            return 40;
        }else{
            return 0;
        }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        JYGrabTableViewCellSecond *cell = [JYGrabTableViewCellSecond cellWithTableView:tableView];
        cell.sendTypeLabel.hidden = YES;
        cell.cityTypeLabel.text = @"同城急件·小件";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 2) {
            cell.cityTypeLabel.text = @"同城急件·文件";

        }
        
        return cell;
        
    }else if (indexPath.row == 1){
        
        JYHomeGrabOrderTableViewCell *cell = [JYHomeGrabOrderTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [cell.grabBtn rounded:40];
        return cell;
        
    }else if (indexPath.row == 2){
        JYGrabTableViewCellThird *cell = [JYGrabTableViewCellThird cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.nameLabel.text = @"名称： 电脑桌";
        cell.midLabel.text = @"尺寸： 2m x 2m x 2m";
        cell.lastLabel.text = @"";

        if (indexPath.section == 2) {
            cell.nameLabel.text = @"已投保";
            cell.nameLabel.textColor = BGBlue;
            cell.midLabel.text = @"";

        }
        
               return cell;
        
    }else if (indexPath.row == 3){
        
        JYGrabTableViewCellThird *cell = [JYGrabTableViewCellThird cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.nameLabel.text = @"数量： 10件";
        cell.midLabel.text = @"重量： 60kg";
        cell.lastLabel.text = @"包装： 木箱";
        return cell;
        
    }else if (indexPath.row == 4){
        
        JYGrabTableViewCellThird *cell = [JYGrabTableViewCellThird cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.nameLabel.text = @"已投保";
        cell.nameLabel.textColor = BGBlue;
        cell.lastLabel.text = @"";
        cell.midLabel.text = @"";
        return cell;
        
    }else{
      
        return nil;
    }
    
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    contenView.backgroundColor = BgColorOfUIView;
    return contenView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 6;
}
@end
