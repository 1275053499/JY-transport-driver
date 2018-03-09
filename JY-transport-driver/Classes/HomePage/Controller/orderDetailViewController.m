//
//  orderDetailViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "orderDetailViewController.h"
#import "OrderMessageCell.h"
#import "OrderDetailTwoCell.h"
#import "OrderThreeCell.h"
#import "OrderDetailFourCell.h"
#import "OrderDetailCell.h"
#import "OrderDetailSixCell.h"
#import "OrderMapViewController.h"

#import "OrderHeardTableViewCell.h"
#import "cancelAlertView.h"
#import "CarTypeTableViewCell.h"
#import "cancelAlertView.h"
#import "JYLookPhotoTableViewCell.h"
#import "SendStatusViewController.h"
#import "TimeOutFeeView.h"
#import "NoticeTableViewCell.h"
#import "LookEvaluateViewController.h"
#import "DriverEvaluateViewController.h"
@interface orderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,cancelAlertViewDelegate>

@property(nonatomic,strong)NSMutableArray *statusFrames;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *arrivePlaceAddressArray;
@property(nonatomic,strong)FMButton *payButton;
@property(nonatomic,strong)FMButton *cancelButton;
@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,weak)UIView *footView ;
@property(nonatomic,strong)ModelOrder *model;
@property(nonatomic,strong)NSTimer *timerorder;
@property (nonatomic,strong)cancelAlertView *alert;
@end

@implementation orderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self   getOrderDetail];//获得订单详情
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addRight_ItemWithTitle:@"单据" target:self action:@selector(sendStatus)];
    
    self.arrivePlaceAddressArray = [NSMutableArray array];
    NSArray *arr= [self.OrderModel.arrivePlace componentsSeparatedByString:@","];
    [self.arrivePlaceAddressArray addObjectsFromArray:arr];
    [self.arrivePlaceAddressArray removeLastObject];
    //    self.arr = @[@"我想换一辆车",@"我觉得太贵了",@"信息填写错误，从新下订单",@"其它原因"];
    self.arr = @[@"时间临时有变",@"价钱没谈好",@"信息填写错误，要重新下订单",@"其他原因"];
    
    self.navigationItem.title = @"订单详情";
    self.statusFrames = [NSMutableArray array];
    self.view.backgroundColor = BgColorOfUIView;
    
    [self creatTableView];

    if (![self.OrderModel.basicStatus isEqualToString:@"3"]){
    
        [self creatFootView];

    }
    //创建footView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderEndSucces) name:@"orderEndSuccess" object:nil];//订单结束成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderDetail) name:@"orderbeginWorking" object:nil];//订单开始成功服务
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnAction) name:@"orderCancelSuccess" object:nil];//收到订单成功取消的通知 退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationdidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeg:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderDetail) name:@"sureDriver" object:nil];//用户确认司机  刷新司机订单状态
    
}
- (void)sendStatus{
    
    SendStatusViewController *sendVC = [[SendStatusViewController alloc] init];
    sendVC.orderNum = self.OrderModel.orderNo;
    [self.navigationController pushViewController:sendVC animated:YES];
    
}
//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
    //开启定时器
    [self performSelector:@selector(addTimerUpData) withObject:nil afterDelay:0.5];
    [self getOrderDetail];
}


//进入前台
- (void)applicationWillEnterForeg:(NSNotification *)nottfication{
    
    //开启定时器
    [self performSelector:@selector(addTimerUpData) withObject:nil afterDelay:0.5];
    [self getOrderDetail];
}

//退到后台
- (void)applicationdidEnterBackground:(NSNotification *)nottfication{
    //关闭定时器
    [self.timerorder invalidate];
    self.timerorder = nil;
    
}
//页面消失，
-(void)viewDidDisappear:(BOOL)animated
{
    [_timerorder invalidate];
    _timerorder = nil;
    
}
// 添加一个定时器3秒一次检测订单
-(void)addTimerUpData
{
    if (_timerorder) {
        return;
    }
    _timerorder = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(getOrderDetail) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timerorder forMode:NSRunLoopCommonModes];
}

-(void)getOrderDetail
{
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/getReqDetailByOrderNo"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"orderNo": self.OrderModel.orderNo} success:^(id responseObj) {
        
        ModelOrder *model = [ModelOrder mj_objectWithKeyValues:responseObj];
        
        self.model = model;
        [self.tableView reloadData];
        
        
        if ([self.OrderModel.basicStatus isEqualToString:@"3"] ) {
            
            
            self.tableView .frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-StateBarHeight - NavigationBarHeight);
            
        }else{
            
            //抢单
            if ([self.model.basicStatus isEqualToString:@"1"]) {
                self.footView.hidden = NO;
                self.cancelButton.hidden = NO;
                self.payButton.hidden = NO;
                self.payButton.frame = CGRectMake(135, 0, ScreenWidth - 135, 50);
                self.cancelButton.frame = CGRectMake(0, 0,135, 50);
                
                [self.payButton setTitle:@"去服务" forState:UIControlStateNormal];
                [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                
                //不确定
            }else if ([self.model.basicStatus isEqualToString:@"6"]){
                
                
                self.footView.hidden = NO;
                self.payButton.hidden = YES;
                self.cancelButton.hidden = NO;
                self.cancelButton.frame = CGRectMake(0, 0, ScreenWidth, 50);
                [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                
                // 进行中
            }else if ([self.model.basicStatus isEqualToString:@"2"]){
                self.footView.hidden = NO;
                self.payButton.hidden = NO;
                self.cancelButton.hidden = YES;
                self.payButton.frame = CGRectMake(0, 0, ScreenWidth, 50);
                [self.payButton  setTitle:@"进入地图" forState:UIControlStateNormal];
                
            }else if ([self.model.basicStatus isEqualToString:@"3"]){
                
                self.footView.hidden = YES;
                self.payButton.hidden = YES;
                self.cancelButton.hidden = YES;
                self.tableView .frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-StateBarHeight - NavigationBarHeight);
                
            }else if ([self.model.basicStatus isEqualToString:@"4"]){
                
                self.footView.hidden = NO;
                self.payButton.hidden = YES;
                self.cancelButton.hidden = NO;
                self.cancelButton.frame = CGRectMake(0, 0, ScreenWidth, 50);
                [self.cancelButton setTitle:@"去评价" forState:UIControlStateNormal];
                
                //取消
            }else if ([self.model.basicStatus isEqualToString:@"7"] || [self.model.basicStatus isEqualToString:@"8"]){
                
                self.footView.hidden = NO;
                self.payButton.hidden = NO;
                self.cancelButton.hidden = YES;
                self.payButton.frame = CGRectMake(0, 0, ScreenWidth, 50);
                [self.payButton  setTitle:@"进入地图" forState:UIControlStateNormal];
                
            }else if ([self.model.basicStatus isEqualToString:@"9"]){

                self.footView.hidden = YES;
                self.payButton.hidden = YES;
                self.cancelButton.hidden = YES;
                self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-StateBarHeight - NavigationBarHeight);

            }
            else{
                
                self.footView.hidden = YES;
                self.payButton.hidden = YES;
                self.cancelButton.hidden = YES;
                self.tableView .frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-StateBarHeight - NavigationBarHeight);

                
            }
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"网络异常"];
    }];
    
    
    
    
    
}




//结束服务成功
-(void)orderEndSucces
{
    [self getOrderDetail];
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
}


//收到订单成功取消的通知 退出
#pragma mark - action handle
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatFootView
{
    
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 50 - StateBarHeight - NavigationBarHeight, ScreenWidth, 50)];
    self.footView =footView;
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    
    FMButton *payButton = [FMButton createFMButton];
    [payButton setTitle:@"去服务" forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:22];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton setBackgroundColor:BGBlue];
    [footView addSubview:payButton];
    
    FMButton *cancelButton = [FMButton createFMButton];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelButton setBackgroundColor:RGB(105, 181, 240)];
    cancelButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:22];
    
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [footView addSubview:cancelButton];
    self.cancelButton = cancelButton;
    
    self.payButton = payButton;
    self.footView.hidden = YES;
    self.payButton.hidden = YES;
    self.cancelButton.hidden = YES;
    
    [cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    payButton.block = ^(FMButton *button){
        
        OrderMapViewController *OrederMapVC = [[OrderMapViewController alloc]init];
        OrederMapVC.OrderModel = self.model;
        [self.navigationController pushViewController:OrederMapVC animated:YES];
        
    };
    
}
- (void)PayMethodSelectionViewControllerBackWithpayName:(NSString *)payname{
    // self.payWayLabel.text = payname;
    NSLog(@"%@",payname);
}
-(void)btnClick:(UIButton *)button
{
    
    
    if ([self.OrderModel.basicStatus isEqualToString:@"4"]) {
        
        DriverEvaluateViewController *vc = [[DriverEvaluateViewController alloc] init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        cancelAlertView *alert = [cancelAlertView GlodeBottomView];
        alert.titleArray = self.arr;
        alert.delegate = self;
        [alert show];
        _alert = alert;
        
    }
}
//取消订单
- (void)cancelReasonButtonClick:(NSInteger)index content:(NSString *)str{
    
    NSString *phoneNumber = userPhone;
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/cancelOrderToTrucker"];
    
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":phoneNumber,@"orderNo":self.model.orderNo} success:^(id responseObj) {
        
        
        if ([[NSString stringWithFormat:@"%@",[responseObj objectForKey:@"message"]] isEqualToString:@"0"]) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"orderCancelSuccess" object:nil];
            
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"RobOrderSuccess"];
            [_alert dissMIssView];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showErrorMessage:@"网络异常"];
    }];
    
}
- (UIView *)creatEvaluteView{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setBackgroundColor:BGBlue];
    btn.frame = CGRectMake(0, 10, ScreenWidth, 50);
    [footView addSubview:btn];
    
    return footView;
}
//创建UItableView
-(void)creatTableView
{
    if ([self.model.basicStatus isEqualToString:@"3"] || [self.model.basicStatus isEqualToString:@"4"] || [self.model.basicStatus isEqualToString:@"5"] || [self.model.basicStatus isEqualToString:@"9"] ){
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64- 50) style:UITableViewStylePlain];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 108;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BgColorOfUIView;
    
    
}

#pragma mark - UITableData

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 9;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 1) {
        
        if ([self.model.isLieu isEqualToString:@"1"]) {
            return 1;
        }else{
            return 0;
        }
        
    }
    if (section == 3){
        
        return self.arrivePlaceAddressArray.count+1;;
        
    }else if (section == 5 ){
        
        if (self.model.service.length > 0) {
            
            return 2;
            
        }else{
            
            return 0;
        }
        
    }else if (section == 6 ){
        
        return 2;
        
    }else if (section == 7){
        
        if (self.OrderModel.enclosure == nil || [self.OrderModel.enclosure isEqual:[NSNull null]] || self.OrderModel.enclosure.length <= 0 ) {
            
            return 0;
        }else{
            return 2;
        }
    }else if (section == 8){
        
        return 4;
    }else{
        
        return 1;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"ID111"];
    if (cell==nil) {
        
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID111"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:Default_APP_Font size:12];
    
    ModelOrder *model = self.model;
    if (indexPath.section == 0) {
        
        OrderThreeCell *cell = [OrderThreeCell cellWithOrderTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.money.text = [@"¥" stringByAppendingString:[NSString stringWithFormat:@"%.0f",self.model.bid]];
        cell.money.textColor = RGB(255, 75, 45);
        cell.infoLabel.attributedText = [self infoLabelAttibutedString];
        [cell.moneydetailButton addTarget:self action:@selector(moneydetailButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        if (model.timeType == 1) {
            cell.timeLabel.text = @"即时用车";
        }else{
            
            [cell setDateFromString:model.departTime];
            
        }
        
        return cell;
        
    }else if (indexPath.section == 1){
        
        NoticeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NoticeTableViewCell class]) owner:nil options:0][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.switchBtn.hidden = YES;
        cell.nameLabel.text = @"代收货款";
        cell.nameLabel.textColor = RGB(51, 51, 51);
        cell.nameLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
        cell.detailLab.textColor = RGB(255, 75, 45);
        cell.detailLab.font = [UIFont fontWithName:Default_APP_Font_Reg size:15];
        if (self.model.lieuAmount == nil && [self.model.lieuAmount isEqual:[NSNull null]]) {
            
            
        }else{
            NSString *money = [NSString stringWithFormat:@"¥%@",self.model.lieuAmount];
            cell.detailLab.text = money;
        }
        return cell;
        
    }else if (indexPath.section == 2){
        
        
        OrderHeardTableViewCell *cell = [OrderHeardTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.nameBtn.hidden = YES;
        cell.heardName.text = @"地址信息";
        return cell;
        
        
    }else if (indexPath.section == 3){
        
        OrderMessageCell *cell = [OrderMessageCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            
            cell.place.text = model.departPlace;
            
        }else if (indexPath.row == self.arrivePlaceAddressArray.count){
            
            cell.place.text = self.arrivePlaceAddressArray[indexPath.row-1];
            cell.iconImage.image = [UIImage imageNamed:@"destination-1"];
            
        }else{
            
            cell.iconImage.image = [UIImage imageNamed:@"pass"];
            cell.place.text = self.arrivePlaceAddressArray[indexPath.row-1];
        }
        
        return cell;
        
        
    }else if (indexPath.section == 4){
        
        CarTypeTableViewCell *cell = [CarTypeTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.model = self.model;
        return cell;
        
        return cell;
        
        
    }else if (indexPath.section == 5){
        if (indexPath.row == 0) {
            OrderHeardTableViewCell *cell = [OrderHeardTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.nameBtn.hidden = YES;
            cell.heardName.text = @"服务信息";
            return cell;
        }else{
            
            OrderDetailFourCell *cell = [OrderDetailFourCell cellWithOrderTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell layoutServiceView:model.service];
            
            return cell;
            
            
        }
        
    }else if (indexPath.section == 6){
        
        if (indexPath.row == 0) {
            OrderHeardTableViewCell *cell = [OrderHeardTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.nameBtn.hidden = YES;
            cell.heardName.text = @"联系人信息";
            return cell;
        }else{
            
            OrderDetailSixCell *cell = [OrderDetailSixCell cellWithOrderTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.valueBtn addTarget:self action:@selector(valueBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.valueBtn setTitleColor:BGBlue forState:(UIControlStateNormal)];
            cell.model = self.model;
            [cell.callPeopleBtn addTarget:self action:@selector(callPeoplePhone:) forControlEvents:(UIControlEventTouchUpInside)];
            return cell;
            
        }
        
    }else if (indexPath.section == 7){
        
        if (indexPath.row == 0) {
            OrderHeardTableViewCell *cell = [OrderHeardTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.heardName.text = @"单据信息";
            return cell;
        }else{
            JYLookPhotoTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYLookPhotoTableViewCell class]) owner:nil options:0][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layer.cornerRadius = 2.0;
            cell.layer.masksToBounds = YES;
            cell.contentLabel.textColor = RGB(51, 51, 51);
            
            if (self.OrderModel.enclosure == nil || [self.OrderModel.enclosure isEqual:[NSNull null]] || self.OrderModel.enclosure.length <= 0 ) {
                
            }else{
                
                [cell layoutPhotoView:self.OrderModel.annexDescription photo:self.OrderModel.enclosure];
                
            }
            
            return cell;
            
        }
        
    }else {
        OrderDetailTwoCell *cell = [OrderDetailTwoCell cellWithOrderTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderTitle.textColor = RGB(102, 102, 102);
        
        if (indexPath.row == 0) {
            cell.orderTitle.text = @"订单状态:";
            cell.orderTitle.textColor = RGB(102, 102, 102);
            [cell setOrderStutas:model];
            
        }else if (indexPath.row == 1){
            
            cell.orderTitle.text = @"订单编号:";
            cell.orderContent.text = model.orderNo;
            
        }else if (indexPath.row == 2){
            
            cell.orderTitle.text = @"下单时间:";
            cell.orderContent.text = model.createDate;
        }else{
            cell.orderContent.hidden = YES;
            cell.orderTitle.hidden = YES;
        }
        
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
        
    }else if (section == 1){
        
        if ([self.model.isLieu isEqualToString:@"0"]) {
            return 0.001;
        }else{
            return 9;
        }
    }else if (section == 2) {
        
        return 9;
    }else if (section == 3) {
        
        return 0.001;
    }else if (section == 4){
        if (self.model.service.length <= 0) {
            return 0.001;
        }else{
            return 9;
        }
        
    }else{
        return 9;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        
        return 190;
        
    }else if (indexPath.section == 1){
        
        return  49;
        
    }else if (indexPath.section == 2){
        
        return  49;
        
    }else if (indexPath.section == 3){
        
        return 44;
    }else if (indexPath.section == 4){
        
        return 140;
        
    }else if (indexPath.section == 5){
        
        if (indexPath.row == 0) {
            return 49;
        }else{
            return UITableViewAutomaticDimension;
            
        }
        
    }else if (indexPath.section == 6 ){
        
        if (indexPath.row == 0) {
            return 49;
        }else{
            
            return 99;
        }
        
    }else if (indexPath.section == 7){
        
        if (indexPath.row == 0) {
            return 49;
        }else{
            
            return UITableViewAutomaticDimension;
        }
        
    }else{
        if (indexPath.row == 3) {
            return 10;
        }else{
            
            return 24;
            
        }
    }
    
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    contenView.backgroundColor = BgColorOfUIView;
    
    return contenView;
    
}

- (void)moneydetailButtonClick:(UIButton *)btn{
    
    TimeOutFeeView *view = [[TimeOutFeeView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.title = @"收费详情";
    view.nameArr = @[@"超时时间",@"超时费用",@"客户出价"];
    view.valueArr = @[@"30分钟",@"¥30",@"¥500"];
    [view showTimeOutView];
    
}

- (NSAttributedString *)infoLabelAttibutedString{
    //修改标题的内容，字号，颜色。使用的key值是“attributedTitle”
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"以上价格并未包括路桥费，停车场费及所有杂费，请上车前于司机确认收费。"];
    
    NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Reg size:12],NSForegroundColorAttributeName:RGB(153, 153, 153),};
    
    [attStr setAttributes:firstAttributes range:NSMakeRange(0,attStr.length)];
    
    NSDictionary * secondAttributes = @{ NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Reg size:12],NSForegroundColorAttributeName:BGBlue,};
    NSMutableAttributedString * secondPart = [[NSMutableAttributedString alloc] initWithString:@"点击查看收费详情"];
    [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
    [attStr appendAttributedString:secondPart];
    
    return attStr;
}

- (void)callPeoplePhone:(UIButton *)sender {
    
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", self.model.phone];
    
    if (IOS_VERSION >= 10.0) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        
    } else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
    
}
- (void)valueBtnClick:(UIButton *)btn{
    
    
    LookEvaluateViewController *evaluateVC = [[LookEvaluateViewController alloc] init];
    evaluateVC.reqApplicant = self.model.reqApplicant;
    [self.navigationController pushViewController:evaluateVC animated:YES];
}
-(void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    
    if([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [super didReceiveMemoryWarning];
}
@end
