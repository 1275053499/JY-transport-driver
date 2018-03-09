
//
//  JYOrderDetailViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/17.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYOrderDetailViewController.h"
#import "JYOrderDetailCell.h"
#import "JYGrabTableViewCellSecond.h"
#import "JYGrabTableViewCellThird.h"
#import "JYGrabServiceTableViewCell.h"
#import "JYDescripeTableViewCell.h"
#import "JYORderNumberTableViewCell.h"
#import "JYLookPhotoViewController.h"
#import "JYLookLogisticsViewController.h"
#import "JYMessageRequestData.h"
#import "JYOrderDetailModel.h"
#import "JYWaitingAnimationViewController.h"
#import "JYPayStatusTableViewCell.h"
#import "ScanViewController.h"
#import "JYGrabValueTableViewCell.h"
@interface JYOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,JYMessageRequestDataDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)FMButton *cancelButton;
@property (nonatomic,strong)FMButton *sureButton;
@property (nonatomic,strong)JYOrderDetailModel *detailModel;

@end

@implementation JYOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
     self.navigationItem.title = @"订单详情";
      self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem addRight_ItemWithTitle:@"添加运单号" target:self action:@selector(finshBtnBtnClick)];

    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Reg size:18],
                          NSForegroundColorAttributeName:[UIColor whiteColor]};
    [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;

    
    if ([self.orderStatus isEqualToString:@"6"]) {
       
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self creatTableView];
    [self creatFootView];

}
- (void)finshBtnBtnClick{
    ScanViewController *vc = [[ScanViewController alloc] init];
    vc.whitchVCFrom = @"JYOrderDetailViewController";
    vc.orderId = _detailModel.id;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)creatTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , ScreenHeight - 64 ) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled = YES;
    self.tableView.estimatedRowHeight = 100.0f;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值

    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;
}
- (void)returnAction{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    JYWaitingAnimationViewController *animationVC =(JYWaitingAnimationViewController *) self.parentViewController;
    if ([animationVC isKindOfClass:[JYWaitingAnimationViewController class]]) {
        self.orderID = animationVC.orderID;
    }
    
    [self getDetailOrderInfo];

}

//获得订单详情
- (void)getDetailOrderInfo{
    
    JYMessageRequestData *manager = [JYMessageRequestData shareInstance];
    manager.delegate = self;
    [manager requsetgetDetailOrderInfo:@"app/logisticsorder/getDetailOrder" orderId:self.orderID];
     
}
- (void)requsetgetDetailOrderInfoSuccess:(NSDictionary *)resultDic{
    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"404"] || [message isEqualToString:@"1"] || [message isEqualToString:@"500"]) {
        
    }else{
        
        JYOrderDetailModel *model = [JYOrderDetailModel mj_objectWithKeyValues:resultDic];
        _detailModel = model;
        if (_detailModel.transportNumber == nil || [_detailModel.transportNumber isEqual:[NSNull null]] || _detailModel.transportNumber.length <= 0) {
            
         
            
        }else{
            
//            if ([_detailModel.orderStatus isEqualToString:@"3"] || [_detailModel.orderStatus isEqualToString:@"4"] || [_detailModel.orderStatus isEqualToString:@"8"]) {
//                self.navigationItem.rightBarButtonItem =  [UIBarButtonItem itemWithIcon:@"icon_wode_saoma" highIcon:@"icon_wode_saoma" target:self action:@selector(returnAction)];
//
//
//            }else{
                            self.navigationItem.rightBarButtonItem = nil;

//            }

        }
        [self.tableView reloadData];
        
    }
}

- (void)requsetgetDetailOrderInfoFailed:(NSError *)error{
    
}
-(void)creatFootView
{
//    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    sureBtn.frame = CGRectMake(0, ScreenHeight - 50 - 64,ScreenWidth,50);
//    [sureBtn setTitle:@"取消订单" forState:UIControlStateNormal];
//    [sureBtn setBackgroundColor:RGBA(105,181 ,240, 1)];
//    sureBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:22];
//    [sureBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:sureBtn];
    
//    UIButton *yueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    yueBtn.frame = CGRectMake(135, ScreenHeight - 64- 50,(ScreenWidth - 135), 50);
//    [yueBtn setTitle:@"去支付" forState:UIControlStateNormal];
//    yueBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:22];
//    [yueBtn setBackgroundColor:BGBlue];
//    [yueBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view  addSubview:yueBtn];
}
- (void)cancelBtnClick:(UIButton *)button{
    
    
}
- (void)sureBtnClick:(UIButton *)btn{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 4 || section == 5) {
        return 0;
    }else if (section == 2){
        
        if (_detailModel.transportNumber == nil || [_detailModel.transportNumber isEqual:[NSNull null]] || _detailModel.transportNumber.length <= 0) {
            
            return 0;
        }else{
            return 9;
        }
   
    }else{
        return 9;
    }
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([self.orderStatus isEqualToString:@"6"]) {
                return 44;
            }else{
                return 137;
                
            }
        
        }else if (indexPath.row == 1){
            
            return UITableViewAutomaticDimension;
            
        }else if (indexPath.row == 2){
            return 40;
        }else if (indexPath.row == 3){
            return 40;
        }else {
            return UITableViewAutomaticDimension;

        }
    }else if (indexPath.section == 1){
        
        return 44;
    }else if (indexPath.section == 2){
        
        
        if (_detailModel.transportNumber == nil || [_detailModel.transportNumber isEqual:[NSNull null]] || _detailModel.transportNumber.length <= 0) {
            
            return 0;
        }else{
            
            return 44;
 
        }
        
    }else if (indexPath.section == 3){
        
        return 28;
    }else{
        
        return 83;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 5;
    }else if (section == 3){
        return 5;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            JYGrabTableViewCellSecond *cell = [JYGrabTableViewCellSecond cellWithTableView:tableView];
            if ([self.orderStatus isEqualToString:@"6"]) {
                cell.hidden = YES;
                
                JYGrabValueTableViewCell *cellTime = [JYGrabValueTableViewCell cellWithTableView:tableView];
                cellTime.selectionStyle = UITableViewCellSelectionStyleNone;
                cellTime.sendType.textColor = BGBlue;
                cellTime.sendType.text = @"即时发货";
                return cellTime;
                
            }
          
            
            cell.model = _detailModel;
            
            
            return cell;
        }else if (indexPath.row == 1){
            JYOrderDetailCell *cell  = [JYOrderDetailCell cellWithTableView:tableView];
             cell.model = _detailModel;

            return cell;
        }else if (indexPath.row == 2){
            
            JYGrabTableViewCellThird *cell = [JYGrabTableViewCellThird cellWithTableView:tableView];
            cell.nameConstraintLeading.constant = 48;
            [tableView layoutIfNeeded];
            [cell setvalueforCellRowTwo:_detailModel.jyCargoDetails];

            return cell;
        }else if (indexPath.row == 3){
            
            JYGrabTableViewCellThird *cell = [JYGrabTableViewCellThird cellWithTableView:tableView];
            cell.nameConstraintLeading.constant = 48;
            [tableView layoutIfNeeded];
            [cell setvalueforCellRowThree:_detailModel.jyCargoDetails isInsure:_detailModel.isInsure];

            return cell;
        }else{
            
            JYGrabServiceTableViewCell *cell = [JYGrabServiceTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell layoutServiceView:_detailModel.serviceDetails];
            return cell;

        }
      

    }else if (indexPath.section == 1){
        
        JYDescripeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYDescripeTableViewCell class]) owner:nil options:0][0];
       
        cell.naemLabel.text = @"查看货物描述";
        return cell;
        
    }else if (indexPath.section == 2){
        
        JYDescripeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYDescripeTableViewCell class]) owner:nil options:0][0];
       
        cell.naemLabel.text = @"查看物流";

        if (_detailModel.transportNumber == nil || [_detailModel.transportNumber isEqual:[NSNull null]] || _detailModel.transportNumber.length <= 0) {
            
            cell.hidden = YES;
        }else{
            
            cell.hidden = NO;
            
        }

               return cell;
        
    } else {
        
        JYPayStatusTableViewCell *cell = [JYPayStatusTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];

        if (indexPath.row == 0) {
            cell.statusName.text = @"订单编号:";
            cell.statusLabel.text = _detailModel.orderNo;
            cell.statusLabel.textColor = RGB(102, 102, 102);
            cell.statusName.textColor = RGB(102, 102, 102);
        }else if (indexPath.row == 1){
            
            cell.statusName.text = @"运单编号:";
            cell.statusLabel.text = _detailModel.transportNumber;
            cell.statusLabel.textColor = RGB(102, 102, 102);
            cell.statusName.textColor = RGB(102, 102, 102);
            if (_detailModel.transportNumber == nil || [_detailModel.transportNumber isEqual:[NSNull null]] || _detailModel.transportNumber.length <= 0) {
                
                cell.statusLabel.text = @"未添加";
            }

        }else if (indexPath.row == 2){
            cell.statusName.text = @"下单时间:";
            cell.statusLabel.text = _detailModel.orderTime;
            cell.statusLabel.textColor = RGB(102, 102, 102);
            cell.statusName.textColor = RGB(102, 102, 102);


        }else if (indexPath.row == 3){
            cell.model = _detailModel;
           
        }else{
            
            cell.statusName.text = @"支付状态:";
            cell.statusLabel.text = @"未支付";
        }
       
        return cell;

    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1) {
        JYLookPhotoViewController *vc = [[JYLookPhotoViewController alloc] init];
        vc.describePhoto = _detailModel.describePhoto;
        vc.describeContent = _detailModel.describeContent;

        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2) {
        JYLookLogisticsViewController *vc = [[JYLookLogisticsViewController alloc] init];
        vc.transportNumber = _detailModel.transportNumber;
        vc.orderDetailModel = _detailModel;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth , 9)];
        contenView.backgroundColor = BgColorOfUIView;
    
        return contenView;
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
