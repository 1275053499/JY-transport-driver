//
//  EntryScanViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/23.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "EntryScanViewController.h"
#import "JYMessageRequestData.h"
#import "JYOrderDetailViewController.h"
#import "JYSearchOrderViewController.h"
@interface EntryScanViewController ()<UITextFieldDelegate,JYMessageRequestDataDelegate>

@property (nonatomic,strong)NSString *textContent;
@end

@implementation EntryScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    
    _textContent = @"";
    
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem addRight_ItemWithTitle:@"完成" target:self action:@selector(finishClick)];

    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Reg size:18],
                          NSForegroundColorAttributeName:[UIColor whiteColor]};
    [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.title = @"手动输入";


    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"icon_xingmingjiameng"]];
    imgView.frame = CGRectMake(5, 0, 23, 26);
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 26)];
    [bottomView addSubview:imgView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 9, ScreenWidth, 50)];
    textField.placeholder = @"请输入单号";
    textField.delegate =self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.textColor = RGB(51, 51, 51);
    textField.font =  [UIFont fontWithName:Default_APP_Font_Reg size:16];
    textField.leftView = bottomView;
    textField.leftViewMode = UITextFieldViewModeAlways;// 必须设置leftViewMode属性，不然leftView不会显示出来
    
    textField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textField];
    
}
- (void)finishClick{
    
    [self.view endEditing:YES];
    
    if ([self.whitchVCFrom isEqualToString:@"JYOrderDetailViewController"]) {
        
        [self querytransportNumber:_textContent];

    }else if ([self.whitchVCFrom isEqualToString:@"JYMineViewController"]){
        
        JYSearchOrderViewController *vc = [[JYSearchOrderViewController alloc] init];
        vc.transportNumber = _textContent;
        vc.type = @"willView";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    

}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    _textContent = textField.text;
    
    
}

//添加运输单号

- (void)querytransportNumber:(NSString *)str{
    

        if (str.length > 0) {
            
        [MBProgressHUD showActivityMessageInView:@"正在添加"];

            JYMessageRequestData *manager  = [JYMessageRequestData shareInstance];
            manager.delegate = self;
            [manager requsetAddtransportNumber:@"app/logisticsorder/inputTransportNumber" orderId:self.orderId transportNumber:str];
            
        
    }
  }
//添加运输单号
- (void)requsetAddtransportNumberSuccess:(NSDictionary *)resultDic{
    [MBProgressHUD hideHUD];

    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"0"]) {

        [MBProgressHUD showSuccessMessage:@"添加成功"];
        NSArray *arrController =self.navigationController.viewControllers;

        for (UIViewController *lastVC in arrController) {
            
            if ([lastVC isKindOfClass:[JYOrderDetailViewController class]]) {
                
                [self.navigationController popToViewController:lastVC animated:YES];
            }

        }
        
    }
}

- (void)requsetAddtransportNumberFailed:(NSError *)error{
    
    [MBProgressHUD hideHUD];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
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
