

//
//  PaymentDetailsController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/8.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "PaymentDetailsController.h"
#import "PaymentdDetailsCell.h"
@interface PaymentDetailsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation PaymentDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收支详情";
    self.view.backgroundColor =  BgColorOfUIView;
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    [self creatTableview];
    
    
}

- (void)creatTableview{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.separatorColor = BgColorOfUIView;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PaymentdDetailsCell *cell = [PaymentdDetailsCell cellWithTableView:tableView];
    cell.userInteractionEnabled = NO;
    balanceDetailModel *mode = self.balDetModel;
    if (indexPath.row == 0) {
        cell.paymentType.text = @"流水号";
        cell.paymentName.text = mode.orderNo;
    }else if (indexPath.row == 1){
        cell.paymentType.text = @"支付账户";
        cell.paymentName.text = mode.payer;
        
    }else if (indexPath.row == 2){
        cell.paymentType.text = @"金额";
        cell.paymentName.textColor = RGBA(231, 17, 17,1);
        cell.paymentName.text = mode.amount;
        
    }else if (indexPath.row == 3){
        cell.paymentType.text = @"支付方式";
        cell.paymentName.text = mode.payType;
        
    }else if (indexPath.row == 4){
        cell.paymentType.text = @"时间";
        cell.paymentName.text = mode.createDate;
        
    }else{
        cell.paymentType.text = @"余额";
        cell.paymentName.text = mode.settlement;
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)returnAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
