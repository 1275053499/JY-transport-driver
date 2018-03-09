//
//  JYWaitingForValuationVC.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/17.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYWaitingForValuationVC.h"

#import "JYGrabServiceTableViewCell.h"
#import "JYORderNumberTableViewCell.h"
#import "JYGrabValueTableViewCell.h"
#import "JYGrabTableViewCellThird.h"
#import "JYOrderAddressTableViewCell.h"
#import "JYDescripeTableViewCell.h"
#import "JYLookPhotoViewController.h"
#import "ScottAlertView.h"
#import "JYOfferTableViewCell.h"
#import "JYHomeRequestDate.h"
#import "JYWaitingAnimationViewController.h"
#import "JYOrderDetailModel.h"
#import "JYMessageRequestData.h"
@interface JYWaitingForValuationVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,JYHomeRequestDateDelegate,JYMessageRequestDataDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSString *evulte;//输入的估价
@property (nonatomic,strong)JYOrderDetailModel *detailModel;
@property (nonatomic,strong)UIButton *sureBtn;
@property (nonatomic,strong)UIButton *yueBtn;


@end

@implementation JYWaitingForValuationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _evulte = @"";
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(back)];
    self.navigationItem.title = @"订单详情";
    [self createTableView];
    [self creatBtn];
    [self getDetailOrderInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
    
}
- (void)willChangeStatusBarFrameNotification:(NSNotification *)nottfication{
    
    self.tableView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight -50);

    _sureBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight,135,50);
    _yueBtn.frame = CGRectMake(135, ScreenHeight - NavigationBarHeight - StateBarHeight- 50,(ScreenWidth - 135), 50);

}
- (void)creatBtn{
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight,135,50);
    [sureBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:RGBA(105,181 ,240, 1)];
    sureBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:22];
    [sureBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn = sureBtn;
    [self.view addSubview:sureBtn];
    
    UIButton *yueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yueBtn.frame = CGRectMake(135, ScreenHeight - NavigationBarHeight - StateBarHeight- 50,(ScreenWidth - 135), 50);
    [yueBtn setTitle:@"发送估价" forState:UIControlStateNormal];
    yueBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:22];
    [yueBtn setBackgroundColor:BGBlue];
    [yueBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _yueBtn = yueBtn;
    [self.view addSubview:yueBtn];
    
}
- (void)cancelBtnClick:(UIButton *)btn{
    
    
}
//获得订单详情
- (void)getDetailOrderInfo{
    
    JYMessageRequestData *manager = [JYMessageRequestData shareInstance];
    manager.delegate = self;
    [manager requsetgetDetailOrderInfo:@"app/logisticsorder/getDetailOrder" orderId:self.orderId];
    
}
- (void)requsetgetDetailOrderInfoSuccess:(NSDictionary *)resultDic{
    
    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"404"] || [message isEqualToString:@"1"] || [message isEqualToString:@"500"]) {
        
    }else{
        
        JYOrderDetailModel *model = [JYOrderDetailModel mj_objectWithKeyValues:resultDic];
        _detailModel = model;
        [self.tableView reloadData];
        
    }
}

- (void)requsetgetDetailOrderInfoFailed:(NSError *)error{
    
}
- (void)sureBtnClick:(UIButton*)btn{
    
    if (_evulte == nil || _evulte.length<= 0) {
        
        [self presentTipAlert];
        

    }else{
        
        JYHomeRequestDate *manager = [JYHomeRequestDate shareInstance];
        manager.delegate = self;
      JYServiceProviderModel *mod =  _detailModel.jyServiceProvider;
        
        [manager requestSendEvaluation:@"app/logisticsorder/sendEvaluation" evaluation:_evulte orderId:self.orderId relationId:mod.id];
        
        
        
    }
    
}

- (void)requestSendEvaluationSuccess:(NSDictionary *)resultDic{
    
    JYWaitingAnimationViewController *vc = [[JYWaitingAnimationViewController alloc] init];
    vc.orderID = self.orderId;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)requestSendEvaluationFailed:(NSError *)error{
    
    
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth , ScreenHeight - NavigationBarHeight - StateBarHeight -50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.estimatedRowHeight = 50.0f;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
//   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 1;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 44;
        }else if (indexPath.row == 1){
            return 92;
        }else if (indexPath.row == 2){
            return 40;
        }else if (indexPath.row == 3){
            return 40;
        }else{
            return 40;
        }
       
    }else if (indexPath.section == 1){
        
        return UITableViewAutomaticDimension;
    }else if (indexPath.section == 2){
        
        return 44;
    }else if (indexPath.section == 3){
        
        return 83;
    }else{
        return 140;
    }
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JYGrabTableViewCellThird *cellThird = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYGrabTableViewCellThird class]) owner:nil options:0][0];
    cellThird.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JYCargoDetailsModel *dicCargo = _detailModel.jyCargoDetails;

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            JYGrabValueTableViewCell *cell = [JYGrabValueTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setDateFromString:_detailModel.deliveryTime];

            return cell;
            
        }else if (indexPath.row == 1){
            
            JYOrderAddressTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYOrderAddressTableViewCell class]) owner:nil options:0][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.startAddress.text = _detailModel.originatingSite;
            cell.endAddress.text = _detailModel.destination;

            
            return cell;
            
        } else if (indexPath.row == 2){
            
            
                NSString *name = dicCargo.name;
                NSString *cargoType = dicCargo.cargoType;
                cellThird.nameLabel.text = [NSString stringWithFormat:@"名称： %@",name];
                cellThird.midLabel.text = [NSString stringWithFormat:@"类型： %@",cargoType];
                cellThird.lastLabel.text = @"";
            
                return cellThird;
                
            }else if (indexPath.row == 3){
                
                NSString *amount = dicCargo.amount;
                NSString *packing = dicCargo.packing;
                NSString *weight = dicCargo.weight;
                
                cellThird.nameLabel.text = [NSString stringWithFormat:@"重量： %@ kg",weight];
                cellThird.midLabel.text = [NSString stringWithFormat:@"数量： %@ 件",amount];
                cellThird.lastLabel.text = [NSString stringWithFormat:@"包装： %@",packing];
                return cellThird;
                
            }else if (indexPath.row == 4){
                
                int isInsureNum = _detailModel.isInsure;
                if (isInsureNum == 1) {
                    cellThird.midLabel.text = @"已投保";
                    
                }else{
                    
                    cellThird.midLabel.text = @"";
                    
                }
                NSString *volume = dicCargo.volume;
                cellThird.nameLabel.text = [NSString stringWithFormat:@"体积： %@ m³",volume];
                
                cellThird.midLabel.textColor = BGBlue;
                cellThird.lastLabel.text = @"";
                
            }
            return cellThird;

        
    }else if (indexPath.section == 1){
        
        JYGrabServiceTableViewCell  *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYGrabServiceTableViewCell class]) owner:nil options:0][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell layoutServiceView:_detailModel.serviceDetails];
        
        return cell;
    }else if (indexPath.section == 2){
        
        JYDescripeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYDescripeTableViewCell class]) owner:nil options:0][0];
        cell.naemLabel.text = @"查看货物描述";
        return cell;

       
    }else if (indexPath.section == 3){
        
        JYORderNumberTableViewCell  *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYORderNumberTableViewCell class]) owner:nil options:0][0];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _detailModel;

        
        return cell;
    
    }else{
        JYOfferTableViewCell *cell  =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYOfferTableViewCell class]) owner:nil options:0][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textoffer.delegate = self;
        cell.textoffer.returnKeyType = UIReturnKeyDone;
        cell.textoffer.text = _evulte;
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
    if (section == 1) {
        return 0;
    }else{
         return 9;
    }
   
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        JYLookPhotoViewController *vc = [[JYLookPhotoViewController alloc] init];
        vc.describePhoto = _detailModel.describePhoto;
        vc.describeContent = _detailModel.describeContent;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    _evulte = textField.text;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.tableView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight - 64 -50);
        
    }];
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.tableView.frame = CGRectMake(0, -300, ScreenWidth, ScreenHeight- 64-50);

    }];


    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.tableView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight - 64- 50);
        
    }];

    return YES;
}




- (void)presentTipAlert{
    
    NSString *message = @"请写下您的出价";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle: UIAlertControllerStyleAlert];
    //修改标题的内容，字号，颜色。使用的key值是“attributedTitle”
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:message];
    [hogan addAttribute:NSFontAttributeName value: [UIFont fontWithName:Default_APP_Font_Reg size:17] range:NSMakeRange(0, [[hogan string] length])];
    [hogan addAttribute:NSForegroundColorAttributeName value:RGB(3, 3, 3) range:NSMakeRange(0, [[hogan string] length])];
    [alert setValue:hogan forKey:@"attributedMessage"];

    
    UIAlertAction *sureaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];

  
    [alert addAction:sureaction];
    
    [self presentViewController:alert animated:true completion:nil];      
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
